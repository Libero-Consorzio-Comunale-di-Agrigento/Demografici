package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnscService
import it.finmatica.de4gsdzk.IAttoService
import it.finmatica.de4gsdzk.ICertificabile
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAttoService {

	private final CivNascitaService civNascitaService

	private final CivPubblicazioneService civPubblicazioneService

	private final CivMatrimonioService civMatrimonioService

	private final CivUnioneCivileService civUnioneCivileService

	private final CivProcessoVerbaleService civProcessoVerbaleService

	private final CivMorteService civMorteService

	private final CivCittadinanzaService civCittadinanzaService

    CivAttoService(CivNascitaService civNascitaService, CivPubblicazioneService civPubblicazioneService,
				   CivMatrimonioService civMatrimonioService, CivUnioneCivileService civUnioneCivileService,
				   CivProcessoVerbaleService civProcessoVerbaleService, CivMorteService civMorteService, CivCittadinanzaService civCittadinanzaService) {

		this.civNascitaService = civNascitaService
		this.civPubblicazioneService = civPubblicazioneService
		this.civMatrimonioService = civMatrimonioService
		this.civUnioneCivileService = civUnioneCivileService
		this.civProcessoVerbaleService = civProcessoVerbaleService
		this.civMorteService = civMorteService
		this.civCittadinanzaService = civCittadinanzaService
	}

	IAttoService getService(ETipoAtto tipoAtto) {
		switch(tipoAtto) {
			case ETipoAtto.NAS: return civNascitaService
			case ETipoAtto.MAT: return civMatrimonioService
			case ETipoAtto.UCI: return civUnioneCivileService
			case ETipoAtto.PUB: return civPubblicazioneService
			case ETipoAtto.MOR:	return civMorteService
			case ETipoAtto.CIT: return civCittadinanzaService
			case ETipoAtto.PVU: return civProcessoVerbaleService
		}
		return null
	}

	CivAttoBaseDomain create(ETipoAtto tipoAttoEnum){
		CivAttoBaseDomain atto
		switch (tipoAttoEnum) {
			case ETipoAtto.NAS:
				atto = new CivNascita()
				break
			case ETipoAtto.PUB:
				atto = new CivPubblicazione()
				break
			case ETipoAtto.MAT:
				atto = new CivMatrimonio()
				break
			case ETipoAtto.MOR:
				atto = new CivMorte()
				break
			case ETipoAtto.PVU:
				atto = new CivProcessoVerbale()
				break
			case ETipoAtto.UCI:
				atto = new CivUnioneCivile()
				break
			case ETipoAtto.CIT:
				atto = new CivCittadinanza()
				break
		}
		return atto
	}

	CivAttoBaseDomain getAttoFromAnnotazione(Integer tipoAtto, Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		CivAttoBaseDomain attoDomain = getAttoFromComunicazione(tipoAtto, ufficio, anno, atto, parte, serie)
		return attoDomain
	}

	/*
    // In caso di atti registrati presso altri comuni, il tipo dell'atto su cui l'annotazione dovrebbe
    // essere apposta cambia e diventa:
    // tipo_atto 6:  su Atto di Nascita, generata da Atto di Cittadinanza
    // tipo_atto 7:  su Atto di Nascita, generata da Atto di Matrimonio
    // tipo_atto -7: su Atto di Nascita, generata da Atto di Unione Civile
    // tipo_atto 8:  su Atto di Nascita, generata da Atto di Morte
    // tipo_atto 9:  su Atto di Matrimonio, generata da Atto di Separazione / Scioglimento di Matrimonio
    // tipo_atto -9: su Atto di Unione Civile, generata da Cessazione / Scioglimento di Unione Civile
    // (gli estremi dell'atto saranno quelli dell'atto registrato presso il comune utente)
 	*/
	CivAttoBaseDomain getAttoFromComunicazione(Integer tipoAtto, Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		CivAttoBaseDomain attoDomain = null
		switch (tipoAtto.intValue()) {
			case ETipoAtto.NAS.valore:
				attoDomain = civNascitaService.getByUkAtto(ufficio, anno, atto, parte, serie)
				break
			case ETipoAtto.PUB.valore:
				attoDomain = civPubblicazioneService.getByUkAtto(ufficio, anno, atto, parte, serie)
				break
			case ETipoAtto.MAT.valore:
			case CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune:
			case CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune:
				attoDomain = civMatrimonioService.getByUkAtto(ufficio, anno, atto, parte, serie)
				break
			case ETipoAtto.CIT.valore:
			case CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune:
				attoDomain = civCittadinanzaService.getByUkAtto(ufficio, anno, atto, parte, serie)
				break
			case ETipoAtto.PVU.valore:
			case ETipoAtto.UCI.valore:
			case CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune:
			case CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune:
				if ( (parte == null) && ( (serie?:"") == "" ) ){
					attoDomain = civProcessoVerbaleService.getByUkAtto(ufficio, anno, atto, parte, serie)
				} else {
					attoDomain = civUnioneCivileService.getByUkAtto(ufficio, anno, atto, parte, serie)
				}
				break
			case ETipoAtto.MOR.valore:
			case CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune:
				attoDomain = civMorteService.getByUkAtto(ufficio, anno, atto, parte, serie)
				break
		}
		return attoDomain
	}

	CivAttoBaseDomain getAtto(ETipoAtto tipoAttoEnum, Long pkAtto, Map params=null){
		CivAttoBaseDomain attoDomain
		switch (tipoAttoEnum) {
			case ETipoAtto.NAS:
				attoDomain = civNascitaService.get(pkAtto, params)
				break
			case ETipoAtto.PUB:
				attoDomain = civPubblicazioneService.get(pkAtto, params)
				break
			case ETipoAtto.MAT: //Va bene anche per i divorzi in quanto registrati sulla stessa tabella
				attoDomain = civMatrimonioService.get(pkAtto, params)
				break
			case ETipoAtto.PVU:
				attoDomain = civProcessoVerbaleService.get(pkAtto, params)
				break
			case ETipoAtto.UCI: //Va bene anche per gli scioglimenti in quanto registrati sulla stessa tabella
				attoDomain = civUnioneCivileService.get(pkAtto, params)
				break
			case ETipoAtto.CIT:
				attoDomain = civCittadinanzaService.get(pkAtto, params)
				break
			case ETipoAtto.MOR:
				attoDomain = civMorteService.get(pkAtto, params)
				break
		}
		return attoDomain
	}

	Page<CivAttoBaseDomain> search (ETipoAtto tipoAttoEnum, Map params, Map customMandatoryParams=null) {
		if (customMandatoryParams){
			for (val in customMandatoryParams.values()) {
				if (val == null){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori)
				}
			}
		}
		if ( (params.annoDa != null) || (params.annoA != null) || (params.dataRegistrazioneDa) || (params.dataRegistrazioneA) || (params.dataEventoDa) || (params.dataEventoA) ) {
			return list (tipoAttoEnum, params)
		}
		throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori)
	}

	Page<CivAttoBaseDomain> list (ETipoAtto tipoAttoEnum, Map params) {
		switch (tipoAttoEnum) {
			case ETipoAtto.NAS:
				return civNascitaService.list(params)
				break
			case ETipoAtto.PUB:
				return civPubblicazioneService.list(params)
				break
			case ETipoAtto.MAT: //Va bene anche per i divorzi in quanto registrati sulla stessa tabella
				return civMatrimonioService.list(params)
				break
			case ETipoAtto.PVU:
				return civProcessoVerbaleService.list(params)
				break
			case ETipoAtto.UCI: //Va bene anche per gli scioglimenti in quanto registrati sulla stessa tabella
				return civUnioneCivileService.list(params)
				break
			case ETipoAtto.CIT:
				return civCittadinanzaService.list(params)
				break
			case ETipoAtto.MOR:
				return civMorteService.list(params)
				break
		}
		return null
	}

	Integer getCodiceRecord(ETipoAtto tipoAttoEnum, Long id){
		switch (tipoAttoEnum) {
			case ETipoAtto.NAS:
				return civNascitaService.getCodiceRecord(id)
				break
			case ETipoAtto.PUB:
				return civPubblicazioneService.getCodiceRecord(id)
				break
			case ETipoAtto.MAT: //Va bene anche per i divorzi in quanto registrati sulla stessa tabella
				return civMatrimonioService.getCodiceRecord(id)
				break
			case ETipoAtto.PVU:
				return civProcessoVerbaleService.getCodiceRecord(id)
				break
			case ETipoAtto.UCI: //Va bene anche per gli scioglimenti in quanto registrati sulla stessa tabella
				return civUnioneCivileService.getCodiceRecord(id)
				break
			case ETipoAtto.CIT:
				return civCittadinanzaService.getCodiceRecord(id)
				break
			case ETipoAtto.MOR:
				return civMorteService.getCodiceRecord(id)
				break
		}
		return null
	}

	Boolean existsByUkAtto(CivAttoBaseDomain atto){
		Boolean exists = getService(atto.getTipoAttoEnum()).existsByUkAtto(atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie)
		return exists
	}

	////////////////////////////////////////////////////////////////////////
	/////////////////////////// CERTIFICAZIONE  ////////////////////////////
	////////////////////////////////////////////////////////////////////////

	List<ICertificabile> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
		if (statoCivileFiltroList.isEmpty()) {
			return []
		}
		List<ICertificabile> lAtti = []

		Map<ETipoAtto, List<CerStatoCivileFiltro>> m = statoCivileFiltroList.groupBy { it.getTipoAttoEnum() }
		if (m.containsKey(ETipoAtto.NAS)) {
			lAtti.addAll(civNascitaService.listAllByStatoCivileFiltroList(m.get(ETipoAtto.NAS)))
		}
		if (m.containsKey(ETipoAtto.MAT)) {
			lAtti.addAll(civMatrimonioService.listAllByStatoCivileFiltroList(m.get(ETipoAtto.MAT)))
		}
		if (m.containsKey(ETipoAtto.UCI)) {
			lAtti.addAll(civUnioneCivileService.listAllByStatoCivileFiltroList(m.get(ETipoAtto.UCI)))
		}
		if (m.containsKey(ETipoAtto.MOR)) {
			lAtti.addAll(civMorteService.listAllByStatoCivileFiltroList(m.get(ETipoAtto.MOR)))
		}
		return lAtti
	}

	////////////////////////////////////////////////////////////////////////
	///////////////////////////////   ANSC  ////////////////////////////////
	////////////////////////////////////////////////////////////////////////

	IAttoAnscService getAnscService(ETipoAtto tipoAttoEnum) {
		switch(tipoAttoEnum) {
			case ETipoAtto.NAS: return civNascitaService
			case ETipoAtto.MAT: return civMatrimonioService
			case ETipoAtto.UCI: return civUnioneCivileService
			case ETipoAtto.MOR:	return civMorteService
			case ETipoAtto.CIT: return civCittadinanzaService
		}
		return null
	}

	Boolean isInviatoAnsc(ETipoAtto tipoAttoEnum, Long id) {
		return getAnscService(tipoAttoEnum).isInviatoAnsc(id)
	}

	Boolean isFirmatoUscAnsc(ETipoAtto tipoAttoEnum, Long id) {
		return getAnscService(tipoAttoEnum).isFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(ETipoAtto tipoAttoEnum, Long id) {
		return getAnscService(tipoAttoEnum).isFirmatoCartaceoAnsc(id)
	}

	Boolean isConformeAnsc(ETipoAtto tipoAttoEnum, Long id){
		return getAnscService(tipoAttoEnum).isConformeAnsc(id)
	}

	Boolean hasAllegatiInviatiAnsc(ETipoAtto tipoAttoEnum, Long id) {
		return getAnscService(tipoAttoEnum).hasAllegatiInviatiAnsc(id)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		ETipoAtto[] tipiAtto = ETipoAtto.values()

		for (ETipoAtto tipoAttoEnum : tipiAtto) {
			IAttoAnscService service = getAnscService(tipoAttoEnum)
			if (service != null && service.existsIdAttoAnsc(idAttoAnsc)) {
				return true
			}
		}
		return false
	}

	void updateIdAnscUseCase(ETipoAtto tipoAttoEnum, Long id, Long idAnscUseCase){
		getAnscService(tipoAttoEnum).updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(ETipoAtto tipoAttoEnum, Long id, String idAttoAnsc) {
		getAnscService(tipoAttoEnum).updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateMotivoRecuperoAnsc(ETipoAtto tipoAttoEnum, Long id, EMotivoRecupero motivoRecuperoAnsc){
		getAnscService(tipoAttoEnum).updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

    EMotivoRecupero getMotivoRecuperoAnsc(ETipoAtto tipoAttoEnum, Long id){
        getAnscService(tipoAttoEnum).getMotivoRecuperoAnsc(id)
    }

}
