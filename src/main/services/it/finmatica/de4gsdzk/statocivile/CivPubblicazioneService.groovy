package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivPubblicazioneService implements IAttoService{

	private final ArcParametroService arcParametroService

	private final StatoCivileService statoCivileService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final CivTipoAttoService civTipoAttoService

	private final CivSposiAttoService civSposiAttoService

	private final CivDocumentoPubblicazioneService civDocumentoPubblicazioneService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivPubblicazioneRepository civPubblicazioneRepository

	CivPubblicazioneService(ArcParametroService arcParametroService, CivPubblicazioneRepository civPubblicazioneRepository, StatoCivileService statoCivileService,
							CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
							CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
							CivSposiAttoService civSposiAttoService, CivDocumentoPubblicazioneService civDocumentoPubblicazioneService,
							CivComunicazioneAttoService civComunicazioneAttoService,
							CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {
		this.arcParametroService = arcParametroService
		this.civPubblicazioneRepository = civPubblicazioneRepository
		this.statoCivileService = statoCivileService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civAnagrafeService = civAnagrafeService
		this.civMargineService = civMargineService
		this.civTipoAttoService = civTipoAttoService
		this.civSposiAttoService = civSposiAttoService
		this.civDocumentoPubblicazioneService = civDocumentoPubblicazioneService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civPubblicazioneRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civPubblicazioneRepository.findBloccato(id)
	}

	CivPubblicazione get (Long id, Map params){
		return civPubblicazioneRepository.getByParams(id, params)
	}

	CivPubblicazione getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
		return civPubblicazioneRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		// La serie può essere nulla
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civPubblicazioneRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	Page<CivPubblicazione> list (Map params) {
		return civPubblicazioneRepository.listByParams(params)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivPubblicazione obj, CivDatiProvenienzaAtto datiProvenienza, CivDocumentoPubblicazione documentoPubblicazione, EGestioneConsolidamento gc){

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, "'Richiedenti' - Generalità sposo incomplete ")

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome Sposo")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale Sposo")

		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, "'Richiedenti' - Generalità sposa incomplete ")

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Sposa")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Sposa")

		civValidazioneAttoService.checkComuneEventoMandatory(obj, "'Dati Pubblicazione'")

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, Boolean.TRUE, Boolean.FALSE, Boolean.FALSE)

		//Basta almeno un doc qualunque dei censiti in maschera
		if ( documentoPubblicazione.documentoPresentatoPubblicazione == ETipoSiNo.SI ){
			Boolean found = Boolean.FALSE
			if ( (documentoPubblicazione.dataEstratto1 != null) && (documentoPubblicazione.comuneEstratto1?.codice != null) && (documentoPubblicazione.comuneEstratto1?.codiceProvincia != null) ){
				found = Boolean.TRUE
			}
			if (!found){
				if ( (documentoPubblicazione.dataCumulativo1 != null) && (documentoPubblicazione.comuneCumulativo1?.codice != null) && (documentoPubblicazione.comuneCumulativo1?.codiceProvincia != null) ){
					found = Boolean.TRUE
				}
			}
			if (!found){
				if ( (documentoPubblicazione.dataEstratto2 != null) && (documentoPubblicazione.comuneEstratto2?.codice != null) && (documentoPubblicazione.comuneEstratto2?.codiceProvincia != null) ){
					found = Boolean.TRUE
				}
			}
			if (!found){
				if ( (documentoPubblicazione.dataCumulativo2 != null) && (documentoPubblicazione.comuneCumulativo2?.codice != null != null) && (documentoPubblicazione.comuneCumulativo2?.codiceProvincia != null) ){
					found = Boolean.TRUE
				}
			}
			if (!found){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_documenti_presentati)
			}
		}

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivPubblicazione obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVPUB per id " + obj.id)

		CivPubblicazione newest = DomainUtils.copyAtto(obj) as CivPubblicazione
		newest.id = statoCivileService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civPubblicazioneRepository.save(newest)
	}

	CivPubblicazione save (ETipoOperazione tipoOperazione, CivPubblicazione obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, CivSposiAtto sposi,
						   CivDocumentoPubblicazione documentoPubblicazione, Map<String, CivFormulaTestoLibero> mapFormule, EGestioneConsolidamento gc,
						   boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, documentoPubblicazione, gc)

		if (margine){
			DomainUtils.initFromAtto(margine, obj)

			civMargineService.save(margine, obj.tipoAttoEnum, Boolean.FALSE, Boolean.FALSE, Boolean.TRUE)
		}

		if (sposi){
			DomainUtils.initFromAtto(sposi, obj)

			civSposiAttoService.save(sposi, obj.tipoAttoEnum)
		}

		if (documentoPubblicazione){
			DomainUtils.initFromAtto(documentoPubblicazione, obj)

			civDocumentoPubblicazioneService.save(documentoPubblicazione, obj.tipoAttoEnum)
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
			//Le pubblicazioni di matrimonio non producono effetti in anagrafe, sicché, nel caso delle pubblicazioni,
			//possiamo anche non cancellare il record da civana
			//if (obj.isCodRec3()){
				DomainUtils.initFromAtto(anagrafe, obj)

				if (obj.natura == ENaturaAtto.T ){
					DomainUtils.initAttoOriginaleAnagrafeFromDatiProvenienzaAtto(anagrafe, datiProvenienza)
				}

				civAnagrafeService.save(anagrafe, obj.tipoAttoEnum)
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
					if (FormulaUtils.addFormulaPubblicazione(e.key, tipoOperazione, obj, datiProvenienza, margine, documentoPubblicazione)){
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
			civFormulaTestoLiberoService.save(innerF, obj.tipoAttoEnum)
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

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVPUB per id " + obj.id)
		CivPubblicazione savedPub = civPubblicazioneRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedPub
	}

	void ripristina(ETipoOperazione tipoOperazione, CivPubblicazione obj, EGestioneConsolidamento gc){
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

	void delete(CivPubblicazione obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVPUB per id " + obj.id)
			civPubblicazioneRepository.delete(obj)
		}
	}

}
