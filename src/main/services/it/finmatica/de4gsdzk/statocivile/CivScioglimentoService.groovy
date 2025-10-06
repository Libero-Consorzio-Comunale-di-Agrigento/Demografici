package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoAnscService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivScioglimentoService implements IAttoAnscService{

	private final StatoCivileService statoCivileService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final CivSposiAttoService civSposiAttoService

	private final CivTestimoniAttoService civTestimoniAttoService

	private final CivTipoAttoService civTipoAttoService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivAnnotazioneAttoService civAnnotazioneAttoService

	private final CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivSoggettoCollegatoService civSoggettoCollegatoService

	private final ArcParametroService arcParametroService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivUnioneCivileRepository civUnioneCivileRepository

    CivScioglimentoService(CivUnioneCivileRepository civUnioneCivileRepository, StatoCivileService statoCivileService,
                           CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
                           CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
                           CivComunicazioneAttoService civComunicazioneAttoService, ArcComuneBaseService arcComuneBaseService,
                           CivSposiAttoService civSposiAttoService, CivTestimoniAttoService civTestimoniAttoService,
                           CivAnnotazioneAttoService civAnnotazioneAttoService, CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService,
						   CivSoggettoCollegatoService civSoggettoCollegatoService, ArcParametroService arcParametroService,
						   CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civUnioneCivileRepository = civUnioneCivileRepository
		this.statoCivileService = statoCivileService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civAnagrafeService = civAnagrafeService
		this.civMargineService = civMargineService
		this.civTipoAttoService = civTipoAttoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.arcComuneBaseService = arcComuneBaseService
		this.civSposiAttoService = civSposiAttoService
		this.civTestimoniAttoService = civTestimoniAttoService
		this.civAnnotazioneAttoService = civAnnotazioneAttoService
		this.civAnnotazioneTestoLiberoService = civAnnotazioneTestoLiberoService
		this.civSoggettoCollegatoService = civSoggettoCollegatoService
		this.arcParametroService = arcParametroService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civUnioneCivileRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civUnioneCivileRepository.findBloccato(id)
	}

	Boolean isInviatoAnsc(Long id) {
		String idAttoAnsc = civUnioneCivileRepository.findIdAttoAnsc(id)
		return (!(TestoUtils.isVuoto(idAttoAnsc)))
	}

	Boolean isFirmatoUscAnsc(Long id) {
		return civUnioneCivileRepository.findFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(Long id) {
		return (civUnioneCivileRepository.findFirmatoCartaceoAnsc(id) > 0)
	}

	Boolean isConformeAnsc(Long id) {
		return (civUnioneCivileRepository.findConformeAnsc(id, ETipoArchivioAnsc.UCI) > 0)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		return list([idAttoAnsc: idAttoAnsc]).size() > 0
	}

	Boolean hasAllegatiInviatiAnsc(Long id) {
		return (civUnioneCivileRepository.hasAllegatiInviatiAnsc(id) > 0)
	}

	CivUnioneCivile get (Long id, Map params){
		return civUnioneCivileRepository.getByParams(id, params)
	}

	CivUnioneCivile getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		return civUnioneCivileRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	@Override
	CivUnioneCivile getByIdAttoAnsc(String idAttoAnsc) {
		return civUnioneCivileRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		log.info ("Parametro serie non gestito per scio: " + (serie?:"") )
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civUnioneCivileRepository.countByUfficioAndAnnoAndAttoAndParteAndSerieIsNull(ufficio, anno, atto, parte)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	Page<CivUnioneCivile> list (Map params) {
		return civUnioneCivileRepository.listByParams(params)
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civUnioneCivileRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civUnioneCivileRepository.updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc){
		civUnioneCivileRepository.updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivUnioneCivile obj, CivDatiProvenienzaAtto datiProvenienza, CivSposiAtto sposi,
							Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc){

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		Boolean checkResidenza1 = Boolean.TRUE
		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi1 = (obj.isCodRec3() && anscOn)
		String sezioneC1 = "'Contraenti' - Generalità Contraente 1 incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, sezioneC1, checkResidenza1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, Boolean.FALSE, checkDatiAggiuntivi1)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome Contraente 1")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale Contraente 1")

		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi2 = (obj.isCodRec3() && anscOn)
        String sezioneC2 = "'Contraenti' - Generalità Contraente 2 incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, sezioneC2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, Boolean.FALSE, checkDatiAggiuntivi2)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Contraente 2")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Contraente 2")

		civValidazioneAttoService.checkSessoContraenti(obj, obj)

		civValidazioneAttoService.checkOrarioEvento(obj.oraMatrimonio, Boolean.FALSE, obj.minutoMatrimonio, Boolean.FALSE, Boolean.FALSE, "( Dati Atto )")

		String sezioneDatiAtto = "'Dati Atto'"  // anche per check giudizio pendente
		civValidazioneAttoService.checkComuneEventoMandatory(obj, sezioneDatiAtto)

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		Boolean checkDich = obj.isCodRec3() && obj.isDichDivScioVisibile() && (!(datiProvenienza?.isMancataConfermaAccordo(obj.tipoAttoEnum))) && anscOn
		Boolean checkComp = obj.isCodRec3() && obj.isCompDivScioVisibile() && anscOn
		Boolean checkFirm = obj.isCodRec3() && obj.isFirmDivScioVisibile() && anscOn
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, checkDich, checkComp, checkFirm)

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.D ) && obj.tipoAttoDomain?.categoriaDomain?.flagAnagrafe && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					//CONTRAENTE 1
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1)

					//CONTRAENTE 2
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2)

					//UNIONE CIVILE
					civAnnotazioneAttoService.validaDatiAttoMatUci(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio)
					break
			}
		}

		// IN FUNZIONE DI PARTE E SERIE / CATEGORIA

		if ( (datiProvenienza.tipoDivorzioAltro == null) && obj.isUfficialeAltro() ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_tipo_divorzio_altro_scioglimento)
		}

	}

	private void aggiornaDataRegistrazioneAtto(CivUnioneCivile obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.isCodRec0() && (datiProvenienza.dataAtto != null) && obj.tipoAttoDomain?.categoriaDomain?.flagIstat){
			obj.dataRegistrazione = datiProvenienza.dataAtto
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivUnioneCivile obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVUCI per id " + obj.id)

		CivUnioneCivile newest = DomainUtils.copyAtto(obj) as CivUnioneCivile
		newest.id = statoCivileService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civUnioneCivileRepository.save(newest)
	}

	CivUnioneCivile save (ETipoOperazione tipoOperazione, CivUnioneCivile obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, CivSposiAtto sposi,
						  Map<String, CivFormulaTestoLibero> mapFormule, Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc, Boolean tipoMargineLateraleMandatory,
						  boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, sposi, mapAnnotazioni, gc)

		if (margine){
			DomainUtils.initFromAtto(margine, obj)

			if (margine.tipoMargineLaterale == null){
				String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
				margine.tipoMargineLaterale = (tm?ETipoMargineLaterale.valueOf(tm):null)
			}

			civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory)
		}

		if (sposi){
			DomainUtils.initFromAtto(sposi, obj)

			Boolean estremiAttoMatUciMandatory = (obj.isCodRec3() && obj.isEstremiAttoMatUciMandatory())
			civSposiAttoService.save(sposi, obj.getTipoAttoEnum(), Boolean.TRUE, estremiAttoMatUciMandatory)
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			// refs #67398
			dvc.tipoAccordoMandatory = ( obj.isUfficialeConferma() || obj.isUfficialeAltro() )

			dvc.avvocatiMandatory  	        = (obj.isCodRec3() &&
					(obj.isUfficialeAccordo() || obj.isUfficialeConferma() ||
					(obj.isUfficialeAltro() && datiProvenienza.isMancataConfermaAccordo(obj.tipoAttoEnum)) ) )
			dvc.avvocato1Mandatory = dvc.avvocatiMandatory && isAvvocato1Presente(datiProvenienza)
			dvc.avvocato2Mandatory = dvc.avvocatiMandatory && isAvvocato2Presente(datiProvenienza)

			dvc.accordoMandatory 			= (obj.isCodRec3() &&
					(obj.isUfficialeConferma() || (obj.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(obj.tipoAttoEnum)) ) )

			dvc.autoritaGiudizialeMandatory = (obj.isCodRec3() && obj.isUfficialeAccordo())
			civDatiProvenienzaAttoService.save(datiProvenienza, dvc)
		}

		//Annotazioni (di appoggio) a seguito di atto
		if (obj.isCodRec3() && mapAnnotazioni){
			for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
				civAnnotazioneTestoLiberoService.save(e.getValue(), obj.getTipoAttoEnum())
			}
		}

		if (tipoOperazione.isUpdate()){
			switch (gc) {
				case EGestioneConsolidamento.BLOCCO:
					obj.setBloccato(Boolean.TRUE)
					break
				case EGestioneConsolidamento.CONSOLIDAMENTO:
					obj.setCodRec0()
					aggiornaDataRegistrazioneAtto(obj, datiProvenienza)
					break
				case EGestioneConsolidamento.ANNULLAMENTO:
					obj.setCodRec0()
					obj.setBloccato(Boolean.TRUE)
					break
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					obj.setCodRec0()
					aggiornaDataRegistrazioneAtto(obj, datiProvenienza)
					obj.setBloccato(Boolean.TRUE)
					break
			}
		}

		//Annnotazioni da apporre solo a seguito di consolidamento: il flag anagrafe condiziona anche l'apposizione delle annotazioni
		//Le annotazioni in caso di consolidamento vanno gestite prima di un eventuale intervento su civana
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.D ) && obj.tipoAttoDomain?.categoriaDomain?.flagAnagrafe && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
						switch (e.getValue().tipoFormula) {
							case ETipoFormulaAnnotazioneDaAtto.NAS_1:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1, e.getValue())
								break
							case ETipoFormulaAnnotazioneDaAtto.NAS_2:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2, e.getValue())
								break
							case ETipoFormulaAnnotazioneDaAtto.MAT:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoMatrimonio(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio, e.getValue())
								break
						}
					}
					break
			}
		}

		//Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
		//Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
		//se il comune di residenza del contraente 1 E quello del contraente 2 NON coincidono con il comune del cliente
		if (anagrafe != null){
			ArcComune c = arcComuneBaseService.getComuneCliente()
			Boolean isComuneUtenteResidenza1 = arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, c)
			Boolean isComuneUtenteResidenza2 = arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, c)
			if ( obj.isCodRec3() ||
					( obj.isCodRec0() && ( isComuneUtenteResidenza1 || isComuneUtenteResidenza2 ) && ( obj.natura == ENaturaAtto.D ) && (obj.tipoAttoDomain?.categoriaDomain?.flagAnagrafe) ) ){

				DomainUtils.initFromAtto(anagrafe, obj)

				if (obj.isCodRec0() && (anagrafe.anagrafe1 == null) && (anagrafe.anagrafe2 == null)){
					civAnagrafeService.selectAndDelete(anagrafe)
				} else {
					civAnagrafeService.save(anagrafe, obj.getTipoAttoEnum())
				}
			} else {
				civAnagrafeService.selectAndDelete(anagrafe)
			}
		}

		List<CivFormulaTestoLibero> formuleToRemove = []
		List<CivFormulaTestoLibero> formuleToInsert = []
		if (mapFormule){
			for ( Map.Entry<String, CivFormulaTestoLibero> e : mapFormule ) {
				CivFormulaTestoLibero f = e.getValue()
				if (f){
					if (FormulaUtils.addFormulaScioglimento(e.key, tipoOperazione, obj)){
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

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVUCI per id " + obj.id)
		CivUnioneCivile savedUci = civUnioneCivileRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedUci
	}

	EMotivoRecupero getMotivoRecuperoAnsc(Long id){
		return civUnioneCivileRepository.findMotivoRecuperoAnsc(id)
	}

	void ripristina(ETipoOperazione tipoOperazione, CivUnioneCivile obj, EGestioneConsolidamento gc){
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

	void delete(CivUnioneCivile obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_cancellazione_entita)
			}
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVUCI (SCIO) per id " + obj.id)
			civUnioneCivileRepository.delete(obj)
		}
	}

	private Boolean isAvvocato1Presente(CivDatiProvenienzaAtto obj) {
		statoCivileService.flagComparente(obj.tipoComparente, 'A1')
	}

	private Boolean isAvvocato2Presente(CivDatiProvenienzaAtto obj) {
		statoCivileService.flagComparente(obj.tipoComparente, 'A2')
	}

}
