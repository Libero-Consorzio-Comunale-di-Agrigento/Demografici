package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IAttoAnscService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.lang.NotImplementedException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivDivorzioService implements IAttoAnscService{

	private final GsdService gsdService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final CivSposiAttoService civSposiAttoService

	private final CivTipoAttoService civTipoAttoService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivAnnotazioneAttoService civAnnotazioneAttoService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService

	private final ArcParametroService arcParametroService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivMatrimonioRepository civMatrimonioRepository

    CivDivorzioService(CivMatrimonioRepository civMatrimonioRepository, GsdService gsdService,
                       CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
                       CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
                       CivComunicazioneAttoService civComunicazioneAttoService, CivSposiAttoService civSposiAttoService,
                       CivAnnotazioneAttoService civAnnotazioneAttoService, ArcComuneBaseService arcComuneBaseService,
                       CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService, ArcParametroService arcParametroService,
                       CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civMatrimonioRepository = civMatrimonioRepository
		this.gsdService = gsdService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civAnagrafeService = civAnagrafeService
		this.civMargineService = civMargineService
		this.civTipoAttoService = civTipoAttoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civSposiAttoService = civSposiAttoService
		this.civAnnotazioneAttoService = civAnnotazioneAttoService
		this.arcComuneBaseService = arcComuneBaseService
		this.civAnnotazioneTestoLiberoService = civAnnotazioneTestoLiberoService
		this.arcParametroService = arcParametroService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civMatrimonioRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civMatrimonioRepository.findBloccato(id)
	}

	Boolean isInviatoAnsc(Long id) {
		String idAttoAnsc = civMatrimonioRepository.findIdAttoAnsc(id)
		return (!(TestoUtils.isVuoto(idAttoAnsc)))
	}

	Boolean isFirmatoUscAnsc(Long id) {
		return civMatrimonioRepository.findFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(Long id) {
		return (civMatrimonioRepository.findFirmatoCartaceoAnsc(id) > 0)
	}

	Boolean isConformeAnsc(Long id) {
		return (civMatrimonioRepository.findConformeAnsc(id, ETipoArchivioAnsc.MAT) > 0)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		throw new NotImplementedException('Should use Matrimonio service')
	}

	Boolean hasAllegatiInviatiAnsc(Long id) {
		return (civMatrimonioRepository.hasAllegatiInviatiAnsc(id) > 0)
	}

	CivMatrimonio get (Long id, Map params){
		return civMatrimonioRepository.getByParams(id, params)
	}

	CivMatrimonio getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
		return civMatrimonioRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	@Override
	CivMatrimonio getByIdAttoAnsc(String idAttoAnsc) {
		return civMatrimonioRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) && ((serie?:"") != "") ) {
			long n = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civMatrimonioRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		throw new NotImplementedException('Should use Matrimonio service')
	}

	void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc){
		civMatrimonioRepository.updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivMatrimonio obj, CivDatiProvenienzaAtto datiProvenienza, CivSposiAtto sposi,
							Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc){

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		Boolean checkResidenza1 = Boolean.TRUE
		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi1 = (obj.isCodRec3() && anscOn)
		String sezioneS1 = "'Sposi' - Generalità sposo incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, sezioneS1, checkResidenza1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, Boolean.FALSE, Boolean.FALSE)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome Sposo")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale Sposo")

		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi2 = (obj.isCodRec3() && anscOn)
		String sezioneS2 = "'Sposi' - Generalità sposa incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, sezioneS2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, Boolean.FALSE, Boolean.FALSE)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Sposa")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Sposa")

		civValidazioneAttoService.checkOrarioEvento(obj.oraMatrimonio, Boolean.FALSE, obj.minutoMatrimonio, Boolean.FALSE, Boolean.FALSE, "( Dati Divorzio )")

		String sezioneDatiAtto = "'Dati Atto'"
		civValidazioneAttoService.checkComuneEventoMandatory(obj, sezioneDatiAtto)

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		Boolean checkDich = obj.isCodRec3() && obj.isDichDivScioVisibile() && (!(datiProvenienza?.isMancataConfermaAccordo(obj.tipoAttoEnum))) && anscOn
		Boolean checkComp = obj.isCodRec3() && obj.isCompDivScioVisibile() && anscOn
		Boolean checkFirm = obj.isCodRec3() && obj.isFirmDivScioVisibile() && anscOn
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, checkDich, checkComp, checkFirm)

		if (obj.isCodRec3() && anscOn && obj.isRiconciliazione() && obj.dataMatrimonio == null) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), 'Dati Atto')
		}

		if (datiProvenienza.tipoDivorzio == null){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_tipo_divorzio"))
		}

		if ( (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) && obj.isTribunale() ) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Errore_tipo_divorzio"))
		}

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.D ) && obj.tipoAttoDomain?.categoriaDomain?.flagAnagrafe && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO:
					for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
						switch (e.getValue().tipoFormula) {
							case ETipoFormulaAnnotazioneDaAtto.NAS_1:
								if ( datiProvenienza.tipoDivorzio == ETipoDivorzio.X ){
									log.info("Annotazione su atto di nascita da non validare")
								} else {
									//SPOSO
									civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1)
								}
								break
							case ETipoFormulaAnnotazioneDaAtto.NAS_2:
								if ( datiProvenienza.tipoDivorzio == ETipoDivorzio.X ){
									log.info("Annotazione su atto di nascita da non validare")
								} else {
									//SPOSA
									civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2)
								}
								break
							case ETipoFormulaAnnotazioneDaAtto.MAT:
								if ( (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) && obj.isTribunale() ){
									log.info("Annotazione su atto di matrimonio da non validare")
								} else {
									//MATRIMONIO
									civAnnotazioneAttoService.validaDatiAttoMatUci(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio)
								}
								break
						}
					}
					break
			}
		}
	}

	private void aggiornaDataRegistrazioneAtto(CivMatrimonio obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.isCodRec0() && (datiProvenienza.dataAtto != null) && obj.tipoAttoDomain?.categoriaDomain?.flagIstat){
			obj.dataRegistrazione = datiProvenienza.dataAtto
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivMatrimonio obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVMAT per id " + obj.id)

		CivMatrimonio newest = DomainUtils.copyAtto(obj) as CivMatrimonio
		newest.id = gsdService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civMatrimonioRepository.save(newest)
	}

	CivMatrimonio save (ETipoOperazione tipoOperazione, CivMatrimonio obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, CivSposiAtto sposi,
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
			Boolean datiMatUciMandatory = (obj.isCodRec3() &&
					(obj.isUfficialeAccordo() ||
					(obj.isUfficialeAltro() && datiProvenienza?.isModificaCondizioniSeparazioneODivorzio()) ) )
			civSposiAttoService.save(sposi, obj.getTipoAttoEnum(), Boolean.TRUE, estremiAttoMatUciMandatory, datiMatUciMandatory )
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			Boolean tipoDivorzioAltroMandatory = (obj.isCodRec3() && obj.isAvvocatiAltro() )

			Boolean negozAssistitaMandatory  	= (obj.isCodRec3() && (obj.isAvvocati() || obj.isAvvocatiAltro()) )

			// Dati avvocati per tutte le cat ad eslcusione di RCN e AVV
			Boolean avvocatiMandatory  	        = (obj.isCodRec3() &&
					(obj.isUfficialeAccordo() || obj.isUfficialeConferma() ||
					(obj.isUfficialeAltro() && datiProvenienza.isMancataConfermaAccordo(obj.tipoAttoEnum)) ||
					(obj.isUfficialeAltro() && datiProvenienza.isModificaCondizioniSeparazioneODivorzio()) ) )

			Boolean accordoMandatory 			= (obj.isCodRec3() &&
					(obj.isUfficialeConferma() ||
					(obj.isRiconciliazione() && datiProvenienza?.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaRCN()) ||
					(obj.isUfficialeAccordo() && datiProvenienza?.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAC()) ||
					(obj.isUfficialeAltro() && datiProvenienza?.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAL()) ||
					(obj.isUfficialeAltro() && datiProvenienza?.isMancataConfermaAccordo(obj.tipoAttoEnum)) ) )

			Boolean tipoProvvedimentoSeparazioneMandatory = (obj.isCodRec3() &&
					(obj.isRiconciliazione() ||
					(obj.isUfficialeAltro() && datiProvenienza.isModificaCondizioniSeparazioneODivorzio() ) ||
					(obj.isUfficialeAccordo() && datiProvenienza.isDivorzio()) ) )

			// refs #72274
			Boolean provvedimentoSeparazioneMandatory = (obj.isCodRec3() &&
					((obj.isRiconciliazione() && datiProvenienza.isSepDaProvvedimentoSeparazioneRCN()) ||
					(obj.isUfficialeAltro() && datiProvenienza.isSepDaProvvedimentoSeparazioneUAL()) ||
					(obj.isUfficialeAccordo() && datiProvenienza.isSepDaProvvedimentoSeparazioneUAC()) ) )

			Boolean confermaAccordoSeparazioneMandatory = (obj.isCodRec3() &&
					((obj.isRiconciliazione() && datiProvenienza.isSepDaAccordoSeparazioneRCN()) ||
					(obj.isUfficialeAccordo() && datiProvenienza.isSepDaAccordoSeparazioneUAC()) ||
					(obj.isUfficialeAltro() && datiProvenienza.isSepDaAccordoSeparazioneUAL()) ) )

			Boolean autoritaGiudizialeMandatory = (obj.isCodRec3() &&
					(obj.isUfficialeAccordo() ||
					(obj.isUfficialeAltro() && datiProvenienza.isModificaCondizioniSeparazioneODivorzio()) ) )

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum(), obj.isUfficialeAccordo(), obj.isUfficialeAltro(), obj.isRiconciliazione())
			dvc.tipoAccordoMandatory = ( obj.isUfficialeConferma() || obj.isUfficialeAltro() )
			dvc.tipoDivorzioAltroMandatory = tipoDivorzioAltroMandatory
			dvc.negozAssistitaMandatory = negozAssistitaMandatory
			dvc.avvocatiMandatory = avvocatiMandatory
			dvc.avvocato1Mandatory = avvocatiMandatory && isAvvocato1Presente(datiProvenienza)
			dvc.avvocato2Mandatory = avvocatiMandatory && isAvvocato2Presente(datiProvenienza)
			dvc.accordoMandatory = accordoMandatory
			dvc.tipoProvvedimentoSeparazioneMandatory = tipoProvvedimentoSeparazioneMandatory
			dvc.provvedimentoSeparazioneMandatory = provvedimentoSeparazioneMandatory
			dvc.confermaAccordoSeparazioneMandatory = confermaAccordoSeparazioneMandatory
			dvc.autoritaGiudizialeMandatory = autoritaGiudizialeMandatory
			dvc.richiedenteTepMandatory = (obj.isCodRec3() && obj.isDivorzioEstero() && datiProvenienza.isRichiestaDaPrivatoDichiarante())
			dvc.attoDaTrascrivereMandatory = (obj.isCodRec3() && obj.isDivorzioEstero())
			dvc.estremiAttoDaTrascrivereMandatory = dvc.attoDaTrascrivereMandatory
			dvc.dataPubblicazioneSentenzaMandatory = (obj.isCodRec3() && obj.isDivorzioEstero())

			civDatiProvenienzaAttoService.save(datiProvenienza, dvc)
		}

		//Annotazioni (di appoggio) a seguito di atto
		if (obj.isCodRec3() && mapAnnotazioni){
			for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
				CivAnnotazioneTestoLibero atl = e.getValue()
				if (atl != null) {
					switch (atl.tipoFormula) {
						case ETipoFormulaAnnotazioneDaAtto.NAS_1:
						case ETipoFormulaAnnotazioneDaAtto.NAS_2:
							if ( datiProvenienza.tipoDivorzio == ETipoDivorzio.X ){
								civAnnotazioneTestoLiberoService.delete(atl)
							} else {
								civAnnotazioneTestoLiberoService.save(atl, obj.tipoAttoEnum)
							}
							break
						case ETipoFormulaAnnotazioneDaAtto.MAT:
							if ( (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) && obj.isTribunale() ){
								civAnnotazioneTestoLiberoService.delete(atl)
							} else {
								civAnnotazioneTestoLiberoService.save(atl, obj.tipoAttoEnum)
							}
							break
					}
				}
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
						CivAnnotazioneTestoLibero civAtl = e.getValue()
						switch (civAtl.tipoFormula) {
							case ETipoFormulaAnnotazioneDaAtto.NAS_1:
								if ( datiProvenienza.tipoDivorzio == ETipoDivorzio.X ){
									civAnnotazioneTestoLiberoService.delete(civAtl)
								} else {
									civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1, civAtl)
								}
								break
							case ETipoFormulaAnnotazioneDaAtto.NAS_2:
								if ( datiProvenienza.tipoDivorzio == ETipoDivorzio.X ){
									civAnnotazioneTestoLiberoService.delete(civAtl)
								} else {
									civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2, civAtl)
								}
								break
							case ETipoFormulaAnnotazioneDaAtto.MAT:
								if ( (datiProvenienza.tipoDivorzio == ETipoDivorzio.X) && obj.isTribunale() ){
									civAnnotazioneTestoLiberoService.delete(civAtl)
								} else {
									civAnnotazioneAttoService.saveAnnotazioneSuAttoMatrimonio(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio, civAtl)
								}
								break
						}
					}
					break
			}
		}

		//Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
		//Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
		//se il comune di residenza dello sposo E quello della sposa NON coincidono con il comune del cliente
		//o il campo FLAG_ANAGRAFE di civcta NON è settato a 'S'
		if (anagrafe != null){
			ArcComune c = arcComuneBaseService.getComuneCliente()
			Boolean isComuneUtenteResidenzaSposo = arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, c)
			Boolean isComuneUtenteResidenzaSposa = arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, c)
            // refs #63873: in caso di separazione (o Altro) non deve aver luogo il passaggio in anagrafe
			if (  obj.isCodRec3() ||
				( obj.isCodRec0() && ( isComuneUtenteResidenzaSposo || isComuneUtenteResidenzaSposa ) && ( obj.natura == ENaturaAtto.D ) && (obj.tipoAttoDomain?.categoriaDomain?.flagAnagrafe) && ([ETipoDivorzio.S, ETipoDivorzio.C].contains(datiProvenienza.tipoDivorzio) ) ) ){

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
					if (FormulaUtils.addFormulaDivorzio(e.key, tipoOperazione, obj)){
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
			obj.id = gsdService.getIdFromSequence(obj)
		}

		// Se è stato storicizzato l'atto devo incrementare la versione prima di salvarlo
		if (isRettificato) {
			obj.versioneRettifica = obj.versioneRettifica + 1
            obj.dataVersioneRettifica = new Date()
		}

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVMAT per id " + obj.id)
		CivMatrimonio savedMat = civMatrimonioRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedMat
	}

	EMotivoRecupero getMotivoRecuperoAnsc(Long id){
		return civMatrimonioRepository.findMotivoRecuperoAnsc(id)
	}

	void ripristina(ETipoOperazione tipoOperazione, CivMatrimonio obj, EGestioneConsolidamento gc){
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

	void delete(CivMatrimonio obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(Etichette.getEtichetta("Errore_ANSC_cancellazione_entita"))
			}
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVMAT (DIV) per id " + obj.id)
			civMatrimonioRepository.delete(obj)
		}
	}

	private Boolean isAvvocato1Presente(CivDatiProvenienzaAtto obj) {
		gsdService.flagComparente(obj.tipoComparente, 'AO')
	}

	private Boolean isAvvocato2Presente(CivDatiProvenienzaAtto obj) {
		gsdService.flagComparente(obj.tipoComparente, 'AA', 'AVV2')
	}

}
