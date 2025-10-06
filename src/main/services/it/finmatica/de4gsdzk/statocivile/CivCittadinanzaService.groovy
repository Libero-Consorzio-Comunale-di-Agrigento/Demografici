package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoAnscService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiAttoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivCittadinanzaService implements IAttoAnscService{

	private final StatoCivileService statoCivileService

	private final CivTipoAttoService civTipoAttoService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final AnaAnagrafeService anaAnagrafeService

	private final CivMargineService civMargineService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivAnnotazioneAttoService civAnnotazioneAttoService

	private final CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivSoggettoCollegatoService civSoggettoCollegatoService

	private final ArcParametroService arcParametroService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivCittadinanzaRepository civCittadinanzaRepository

	CivCittadinanzaService(CivCittadinanzaRepository civCittadinanzaRepository, StatoCivileService statoCivileService,
						   CivMargineService civMargineService, CivAnagrafeService civAnagrafeService,
						   CivFormulaTestoLiberoService civFormulaTestoLiberoService, AnaAnagrafeService anaAnagrafeService,
						   CivTipoAttoService civTipoAttoService, ArcComuneBaseService arcComuneBaseService,
						   CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivComunicazioneAttoService civComunicazioneAttoService,
						   CivAnnotazioneAttoService civAnnotazioneAttoService, CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService,
						   CivValidazioneAttoService civValidazioneAttoService,
						   CivSoggettoCollegatoService civSoggettoCollegatoService, ArcParametroService arcParametroService,
						   CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civCittadinanzaRepository = civCittadinanzaRepository
		this.statoCivileService = statoCivileService
		this.civMargineService = civMargineService
		this.civAnagrafeService = civAnagrafeService
		this.anaAnagrafeService = anaAnagrafeService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civTipoAttoService = civTipoAttoService
		this.arcComuneBaseService = arcComuneBaseService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civAnnotazioneAttoService = civAnnotazioneAttoService
		this.civAnnotazioneTestoLiberoService = civAnnotazioneTestoLiberoService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civSoggettoCollegatoService = civSoggettoCollegatoService
		this.arcParametroService = arcParametroService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civCittadinanzaRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civCittadinanzaRepository.findBloccato(id)
	}

	Boolean isInviatoAnsc(Long id) {
		String idAttoAnsc = civCittadinanzaRepository.findIdAttoAnsc(id)
		return (!(TestoUtils.isVuoto(idAttoAnsc)))
	}

	Boolean isFirmatoUscAnsc(Long id) {
		return civCittadinanzaRepository.findFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(Long id) {
		return (civCittadinanzaRepository.findFirmatoCartaceoAnsc(id) > 0)
	}

	Boolean isConformeAnsc(Long id) {
		return (civCittadinanzaRepository.findConformeAnsc(id, ETipoArchivioAnsc.CIT) > 0)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		return list([idAttoAnsc:idAttoAnsc]).size() > 0
	}

	Boolean hasAllegatiInviatiAnsc(Long id) {
		return (civCittadinanzaRepository.hasAllegatiInviatiAnsc(id) > 0)
	}

	CivCittadinanza get (Long id, Map params){
		return civCittadinanzaRepository.getByParams(id, params)
	}

	CivCittadinanza getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		return civCittadinanzaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	@Override
	CivCittadinanza getByIdAttoAnsc(String idAttoAnsc) {
		return civCittadinanzaRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		if ( (ufficio != null) && (anno != null) && (atto != null) && ((serie?:"") == "") && (parte == null) ) {
			long n = civCittadinanzaRepository.countByUfficioAndAnnoAndAttoAndParteIsNullAndSerieIsNull(ufficio, anno, atto)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	Page<CivCittadinanza> list (Map params) {
		return civCittadinanzaRepository.listByParams(params)
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civCittadinanzaRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civCittadinanzaRepository.updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc){
		civCittadinanzaRepository.updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivCittadinanza obj, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine,
							Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc){

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		Boolean checkResidenza1 = Boolean.TRUE
		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi1 = (obj.isCodRec3() && anscOn)
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, "'Dati Intestatario'", checkResidenza1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, checkDatiAggiuntivi1)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		if (obj.isCodRec3() && anscOn && obj.isAcquisto()){
			String sezioneDatiAtto = "'Dati Atto'"
			if ( (obj.tipoRichiesta == null) || (obj.motivoCittadinanza == null) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiAtto)
			}
			if (obj.isTrascrizione()){
				if (obj.dataRichiesta == null){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiAtto)
				}
			}
			if (obj.tipoRichiesta != obj.motivoCittadinanza?.tipoRichiesta) {
				throw new AnscRuntimeException("Il motivo richiesta selezionato nella sezione 'Dati Atto' non risulta coerente con il tipo di richiesta indicato")
			}
		}

		if (obj.isCodRec3() && anscOn && obj.isEstremiGiuramentoMandatory()) {
			if (obj.dataGiuramento == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, "'Dati Atto'")
			}

			if (datiProvenienza.comuneGiuramento.codice == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, "'Dati Atto'")
			}

			if (TestoUtils.isVuoto(datiProvenienza.idAttoAnscGiuramento)) {
				if ((datiProvenienza.attoGiuramento == null) || (datiProvenienza.annoGiuramento == null)) {
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, "'Dati Atto'")
				}
			}
		}

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		Boolean checkDCF = obj.isCodRec3() && obj.isDicCompFirmCitVisibile() && anscOn
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, checkDCF, checkDCF, checkDCF)

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( (obj.natura == ENaturaAtto.A) || (obj.natura == ENaturaAtto.P) ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					//RICHIEDENTE
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, margine, datiProvenienza.formulaDfaAnnotazioneNascita1)
					break
			}
		}

		// IN FUNZIONE DI PARTE E SERIE / CATEGORIA
		// cdu 52153
		if  (obj.isCodRec3() && anscOn && obj.motivoCittadinanza?.flagAutorita && !(obj.motivoCittadinanza?.flagConsolato) ){
			if  (datiProvenienza.tipoRichiestaTrascrizione == null){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori, "- indicare il tipo di richiesta della trascrizione")
			}
		}

		if  (obj.isCodRec3() && anscOn && obj.motivoCittadinanza?.flagMinore){
			if  (obj.tipoTrasmissioneCittadinanza == null){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori, "- indicare il genitore che ha acquistato la cittadinanza nella sezione 'Redazione' ")
			}
			if (obj.motivoCittadinanza?.flagRiconoscimento && (obj.tipoTrasmissioneCittadinanza == ETipoTrasmissioneCittadinanza.EN) ){
				throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_salvataggio, "- indicare se il genitore che ha effettuato il riconoscimento è il padre o la madre nella sezione 'Redazione' ")
			}
		}

		String sezioneDatiRiconoscimento = "'Redazione - Estremi atto/sentenza di riconoscimento'"
		if (obj.isCodRec3() && anscOn && obj.motivoCittadinanza?.flagEstremiRiconoscimento){
			if ( obj.tipoRiconoscimento == null){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiRiconoscimento)
			}
		}

		String sezioneDatiDocumentoRiconoscimento = "'Redazione - Documento di riconoscimento'"
		if (obj.isCodRec3() && anscOn && obj.motivoCittadinanza?.flagDocumentoIdentita){
			if ( (datiProvenienza.tipoDocumentoDichiarante == null) || ( (datiProvenienza.numeroDocumentoDichiarante?:"") == "") ||
					(datiProvenienza.dataEmissioneDocumentoDichiarante == null) || (datiProvenienza.dataScadenzaDocumentoDichiarante == null) ||
					(datiProvenienza.enteDocumentoDichiarante == null) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiDocumentoRiconoscimento)
			}
		}

		String sezioneDatiPubblicoImpiego = "'Redazione - Documentazione pubblico impiego'"
		if (obj.isCodRec3() && anscOn && obj.motivoCittadinanza?.flagPubblicoImpiego){
			if ( (datiProvenienza.tempisticaAssunzionePubblicoImpiego == null) || ( (datiProvenienza.estremiDocumentoPubblicoImpiego?:"") == "") ||
					(datiProvenienza.comunePubblicoImpiego.codice == null) || (datiProvenienza.comunePubblicoImpiego.codiceProvincia == null) ||
					(datiProvenienza.dataDocumentoPubblicoImpiego == null) || ( (datiProvenienza.entePubblicoImpiego?:"") == "") ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiPubblicoImpiego)
			}
		}

		String sezioneDatiDecreto = "'Redazione - Dati Decreto/Attestazione'"
		if (obj.isCodRec3() && anscOn && obj.isGiuramento()){
			if ( ( (datiProvenienza.numeroSentenza?:"") == "") || (datiProvenienza.dataSentenza == null) || (datiProvenienza.dataNotificaSentenza == null)){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiDecreto)
			}
		}

		String sezioneAltriDati = "'Redazione - Altri dati'"
		if (obj.isCodRec3() && anscOn) {
			if (obj.isDataProvvedimentoSindacoMandatory() && obj.dataAccertamento == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneAltriDati)
			}
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivCittadinanza obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVCIT per id " + obj.id)

		CivCittadinanza newest = DomainUtils.copyAtto(obj) as CivCittadinanza
		newest.id = statoCivileService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civCittadinanzaRepository.save(newest)
	}

	CivCittadinanza save (ETipoOperazione tipoOperazione, CivCittadinanza obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine,
						  Map<String, CivFormulaTestoLibero> mapFormule, Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc,
						  Boolean tipoMargineLateraleMandatory, List<CivSoggettoCollegato> soggettiCollegati,
						  boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, margine, mapAnnotazioni, gc)

		if (margine){
			DomainUtils.initFromAtto(margine, obj)

			if (margine.tipoMargineLaterale == null){
				String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
				margine.tipoMargineLaterale = (tm?(ETipoMargineLaterale.valueOf(tm)?:null):null)
			}

			civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory)
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			Boolean riconoscimento1Mandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagEstremiRiconoscimento &&
					                           (obj.tipoRiconoscimento == ETipoRiconoscimentoCittadinanza.MD) )
			Boolean riconoscimento2Mandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagEstremiRiconoscimento &&
					                           (obj.tipoRiconoscimento == ETipoRiconoscimentoCittadinanza.PD) )
			Boolean dichiaranteMandatory = (obj.isCodRec3() && obj.isComprensioneDichiaranteVisibile())
			Boolean richiedenteTeaMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())
			Boolean consolatoMandatory = (obj.isCodRec3() && obj.isConsolatoMandatory())
			Boolean accertamentoMandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagAccertamento)
			Boolean riassuntoMandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagAnnotazione)
			Boolean dataTrascrizioneMandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagAutoritaEstremi && obj.motivoCittadinanza?.flagDataTrascrizioneMandatory)
			Boolean estremiTrascrizioneMandatory = (obj.isCodRec3() && obj.motivoCittadinanza?.flagAutoritaEstremi)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			dvc.dichiaranteMandatory = dichiaranteMandatory
			dvc.richiedenteTeaMandatory = richiedenteTeaMandatory
			// Escludo il controllo della sezione 'Atto Da Trascrivere' per le cittadinanze nonostante cdu 52111 (ius soli)
			dvc.consolatoMandatory = consolatoMandatory
			dvc.riconoscimento1Mandatory = riconoscimento1Mandatory
			dvc.riconoscimento2Mandatory = riconoscimento2Mandatory
			dvc.accertamentoMandatory = accertamentoMandatory
			dvc.riassuntoMandatory = riassuntoMandatory
			dvc.dataTrascrizioneMandatory = dataTrascrizioneMandatory
			dvc.estremiTrascrizioneMandatory = estremiTrascrizioneMandatory
			civDatiProvenienzaAttoService.save(datiProvenienza, dvc)
		}

		if (soggettiCollegati?.size() > 0){
			for (CivSoggettoCollegato sc: soggettiCollegati){
				DomainUtils.initFromAtto(sc, obj)
				Boolean saveSoggetto = Boolean.FALSE
				switch (sc.tipoSoggettoCollegato) {
					case ETipoSoggettoCollegato.IT:
						saveSoggetto = datiProvenienza?.isComparenteInterprete()
						break
					case ETipoSoggettoCollegato.AS:
						saveSoggetto = obj.motivoCittadinanza?.flagAscendente
						break
					case ETipoSoggettoCollegato.PD:
						saveSoggetto = ( (obj.motivoCittadinanza?.flagEstremiRiconoscimento && [ETipoRiconoscimentoCittadinanza.PD, ETipoRiconoscimentoCittadinanza.SP].contains(obj.tipoRiconoscimento) ) ||
										 (obj.motivoCittadinanza?.flagMinore && [ETipoTrasmissioneCittadinanza.PD, ETipoTrasmissioneCittadinanza.EN].contains(obj.tipoTrasmissioneCittadinanza) ) ||
								          obj?.motivoCittadinanza?.flagPadre )
						break
					case ETipoSoggettoCollegato.MD:
						saveSoggetto = ( (obj.motivoCittadinanza?.flagEstremiRiconoscimento && [ETipoRiconoscimentoCittadinanza.MD, ETipoRiconoscimentoCittadinanza.SM].contains(obj.tipoRiconoscimento) ) ||
										 (obj.motivoCittadinanza?.flagMinore && [ETipoTrasmissioneCittadinanza.MD, ETipoTrasmissioneCittadinanza.EN].contains(obj.tipoTrasmissioneCittadinanza) ) ||
										  obj.motivoCittadinanza?.flagMadre )
						break
					case ETipoSoggettoCollegato.CG:
						saveSoggetto = ( obj.motivoCittadinanza?.flagCambioGeneralita && (sc.cambioGeneralita == ETipoSiNo.SI) )
						break
				}
				Boolean soggettoCollegatoMandatory = (obj.isCodRec3() && saveSoggetto)
				if (saveSoggetto){
					civSoggettoCollegatoService.save(sc, obj.getTipoAttoEnum(), soggettoCollegatoMandatory)
				} else {
					civSoggettoCollegatoService.delete(sc)
				}
			}
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
					break
				case EGestioneConsolidamento.ANNULLAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					obj.setCodRec0()
					obj.setBloccato(Boolean.TRUE)
					break
			}
		}

		//Annnotazioni da apporre solo a seguito di consolidamento
		//Le annotazioni in caso di consolidamento vanno gestite prima di un eventuale intervento su civana
		if (tipoOperazione.isUpdate() && ( (obj.natura == ENaturaAtto.A) || (obj.natura == ENaturaAtto.P) ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
						switch (e.getValue().tipoFormula) {
							case ETipoFormulaAnnotazioneDaAtto.NAS_1:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(obj, margine, datiProvenienza.formulaDfaAnnotazioneNascita1, e.getValue())
								break
						}
					}
					break
			}
		}

		//Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
		//Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
		if (anagrafe != null){
			if ( obj.isCodRec3() ){
					//se il comune di residenza del richiedente non coincide con quello del cliente: controllo sospeso fino a quando non gestiremo il passaggio in anagrafe dal  modulo zk
					// ||( obj.isCodRec0() && arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza) && ( (obj.natura == ENaturaAtto.A) || (obj.natura == ENaturaAtto.P) ) ) ){
				DomainUtils.initFromAtto(anagrafe, obj)

				civAnagrafeService.save(anagrafe, obj.getTipoAttoEnum())
				/*if (obj.isCodRec0() && (anagrafe.anagrafe1 == null) ){
					civAnagrafeService.selectAndDelete(anagrafe)
				} else {
					civAnagrafeService.save(anagrafe, obj.getTipoAttoEnum())
				}*/
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
					if (FormulaUtils.addFormulaCittadinanza(e.key, tipoOperazione, obj)){
						log.info("inserisco ${e.key} fra le formule da registrare ")
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

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVCIT per id " + obj.id)
		CivCittadinanza savedCit = civCittadinanzaRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedCit
	}

	CivCittadinanza saveCittadinanzaMinorenne(CivCittadinanza attoPadre, Integer matricolaFiglio, Long idCivdta, Boolean provvisori){
		AnaAnagrafe anaAnagrafe = anaAnagrafeService.get(matricolaFiglio)

		CivDatiProvenienzaAtto dpa = new CivDatiProvenienzaAtto(cognomeDichiarante: attoPadre.cognome, nomeDichiarante: attoPadre.nome,
				senzaCognomeDichiarante: attoPadre.senzaCognome, senzaNomeDichiarante: attoPadre.senzaNome,
				dataNascitaDichiarante: attoPadre.dataNascita, sessoDichiarante: attoPadre.sesso)
		dpa.comuneNascitaDichiarante.codice = attoPadre.codiceComuneNascita
		dpa.comuneNascitaDichiarante.codiceProvincia = attoPadre.codiceProvinciaNascita
		dpa.comuneResidenzaDichiarante.codice = attoPadre.codiceComuneResidenza
		dpa.comuneResidenzaDichiarante.codiceProvincia = attoPadre.codiceProvinciaResidenza

		CivMargine margine = new CivMargine()

		CivAnagrafe civAnagrafe = new CivAnagrafe(tipoAtto: attoPadre.tipoAtto, anagrafe1: anaAnagrafe)
		
		CivTipoAtto ta = null
		if (idCivdta){
			ta = civTipoAttoService.get(idCivdta)
		}

		CivCittadinanza cf = new CivCittadinanza(anno: Calendar.getInstance().get(Calendar.YEAR), codiceRecord: new Integer(3),
				ufficio: attoPadre.ufficio, natura: attoPadre.natura, tipoAttoDomain: ta,
				dataGiuramento: attoPadre.dataGiuramento, dataDecorrenza: attoPadre.dataDecorrenza)
		DomainUtils.initSoggetto1FromAnagrafe(cf, anaAnagrafe)

		if(arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()){
			DomainUtils.initEstremiAttoNascita1FromAnagrafeNuovaGestioneAnnotazioni(margine, anaAnagrafe)
		} else {
			DomainUtils.initEstremiAttoNascita1FromAnagrafe(margine, anaAnagrafe)
		}

		cf.atto = statoCivileService.getNumeroAtto(cf, (provvisori?ETipoSiNo.NO:ETipoSiNo.SI))

		//Inizializzo civAnagrafe, margine e datiProvenienza nel metodo di save

		save(ETipoOperazione.INS, cf, civAnagrafe, dpa, margine, null, [:], null, Boolean.FALSE, [])
	}

	EMotivoRecupero getMotivoRecuperoAnsc(Long id){
		return civCittadinanzaRepository.findMotivoRecuperoAnsc(id)
	}

	void ripristina(ETipoOperazione tipoOperazione, CivCittadinanza obj, EGestioneConsolidamento gc){
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

	void delete(CivCittadinanza obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_cancellazione_entita)
			}
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVCIT per id " + obj.id)
			civCittadinanzaRepository.delete(obj)
		}
	}

}
