package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivProcessoVerbaleService implements IAttoService{

	private final StatoCivileService statoCivileService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivAnagrafeService civAnagrafeService

	private final CivTipoAttoService civTipoAttoService

	private final CivSposiAttoService civSposiAttoService

	private final CivDocumentoPubblicazioneService civDocumentoPubblicazioneService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivProcessoVerbaleRepository civProcessoVerbaleRepository

    CivProcessoVerbaleService(CivProcessoVerbaleRepository civProcessoVerbaleRepository, StatoCivileService statoCivileService,
							  CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
							  CivComunicazioneAttoService civComunicazioneAttoService, CivAnagrafeService civAnagrafeService, CivTipoAttoService civTipoAttoService,
							  CivSposiAttoService civSposiAttoService, CivDocumentoPubblicazioneService civDocumentoPubblicazioneService,
							  CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civProcessoVerbaleRepository = civProcessoVerbaleRepository
		this.statoCivileService = statoCivileService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civAnagrafeService = civAnagrafeService
		this.civTipoAttoService = civTipoAttoService
		this.civSposiAttoService = civSposiAttoService
		this.civDocumentoPubblicazioneService = civDocumentoPubblicazioneService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civProcessoVerbaleRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civProcessoVerbaleRepository.findBloccato(id)
	}

	CivProcessoVerbale get (Long id, Map params){
		return civProcessoVerbaleRepository.getByParams(id, params)
	}

	CivProcessoVerbale getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		return civProcessoVerbaleRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		return civProcessoVerbaleRepository.implementami(ufficio, anno, atto, parte, serie)
	}

	Page<CivProcessoVerbale> list (Map params) {
		return civProcessoVerbaleRepository.listByParams(params)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivProcessoVerbale obj, EGestioneConsolidamento gc){

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, "'Richiedenti' - Generalità Contraente 1 incomplete ")

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome Contraente 1")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale Contraente 1")

		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, "'Richiedenti' - Generalità Contraente 2 incomplete ")

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Contraente 2")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Contraente 2")

		civValidazioneAttoService.checkSessoContraenti(obj, obj)

		civValidazioneAttoService.checkComuneEventoMandatory(obj, "'Dati Pubblicazione'")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivProcessoVerbale obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVPVU per id " + obj.id)

		CivProcessoVerbale newest = DomainUtils.copyAtto(obj) as CivProcessoVerbale
		newest.id = statoCivileService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civProcessoVerbaleRepository.save(newest)
	}

	CivProcessoVerbale save (ETipoOperazione tipoOperazione, CivProcessoVerbale obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivSposiAtto sposi,
							 CivDocumentoPubblicazione documentoPubblicazione, Map<String, CivFormulaTestoLibero> mapFormule, EGestioneConsolidamento gc,
							 boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, gc)

		if (sposi){
			DomainUtils.initFromAtto(sposi, obj)

			civSposiAttoService.save(sposi, obj.getTipoAttoEnum())
		}

		if (documentoPubblicazione){
			DomainUtils.initFromAtto(documentoPubblicazione, obj)

			civDocumentoPubblicazioneService.save(documentoPubblicazione, obj.getTipoAttoEnum())
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())

			civDatiProvenienzaAttoService.save(datiProvenienza, dvc)
		}

		if (tipoOperazione.isUpdate()){
			switch (gc) {
				case EGestioneConsolidamento.BLOCCO:
					obj.setBloccato(Boolean.TRUE)
					break
				case EGestioneConsolidamento.CONSOLIDAMENTO:
					obj.setCodRec0()
					break
				case EGestioneConsolidamento.ANNULLAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					obj.setCodRec0()
					obj.setBloccato(Boolean.TRUE)
					break
			}
		}

		//Non serve alcun controllo sul comune utente
		if (anagrafe != null){
			//I processi verbali non producono effetti in anagrafe, sicché, per i processi verbali
			//possiamo anche non cancellare il record da civana al consolidamento
			//if (obj.isCodRec3()){
				DomainUtils.initFromAtto(anagrafe, obj)

				civAnagrafeService.save(anagrafe, obj.getTipoAttoEnum())
			//} else {
			//	civAnagrafeService.selectAndDelete(anagrafe)
			//}
		}

		List<CivFormulaTestoLibero> formuleToRemove = []
		List<CivFormulaTestoLibero> formuleToInsert = []
		if (mapFormule){
			for ( Map.Entry<String, CivFormulaTestoLibero> e : mapFormule ) {
				CivFormulaTestoLibero f = e.getValue()
				if (f){
					if (FormulaUtils.addFormulaProcessoVerbale(e.key, tipoOperazione, obj, documentoPubblicazione)){
						formuleToInsert.add(f)
					} else {
						log.info("inserisco ${e.key} fra le formule da cancellare ")
						formuleToRemove.add(f)
					}
				}
			}
		}

		for (CivFormulaTestoLibero innerF: formuleToInsert){
			DomainUtils.initFromAtto(innerF, obj)
			civFormulaTestoLiberoService.save(innerF, obj.getTipoAttoEnum())
		}

		for (CivFormulaTestoLibero innerF: formuleToRemove){
			if (innerF.id != null){
				civFormulaTestoLiberoService.delete(innerF)
			}
		}

		if (tipoOperazione.isInsert()){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}

		// Se è stato storicizzato l'atto devo incrementare la versione prima di salvarlo
		if (isRettificato) {
			obj.versioneRettifica = obj.versioneRettifica + 1
		}

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVPVU_V per id " + obj.id)
		CivProcessoVerbale savedPvu = civProcessoVerbaleRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedPvu
	}

    void ripristina(ETipoOperazione tipoOperazione, CivProcessoVerbale obj, EGestioneConsolidamento gc){
        if (tipoOperazione.isUpdate()){
            switch (gc) {
                case EGestioneConsolidamento.BLOCCO:
                    obj.bloccato = getBloccato(obj.id)
                    break
                case EGestioneConsolidamento.CONSOLIDAMENTO:
                    obj.codiceRecord = getCodiceRecord(obj.id)
                    break
				case EGestioneConsolidamento.ANNULLAMENTO:
                case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
                    obj.codiceRecord = getCodiceRecord(obj.id)
                    obj.bloccato = getBloccato(obj.id)
                    break
            }
        }
    }

	void delete(CivProcessoVerbale obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVPVU_V per id " + obj.id)
			civProcessoVerbaleRepository.delete(obj)
		}
	}

}
