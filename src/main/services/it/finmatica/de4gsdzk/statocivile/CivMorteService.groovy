package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IAttoCertificabileService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
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
class CivMorteService implements IAttoCertificabileService {

	private final StatoCivileService statoCivileService

	private final CivTipoAttoService civTipoAttoService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivAnnotazioneAttoService civAnnotazioneAttoService

	private final CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService

	private final CivTrasportoESeppellimentoService civTrasportoESeppellimentoService

	private final CivSoggettoCollegatoService civSoggettoCollegatoService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final ArcParametroService arcParametroService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivMorteRepository civMorteRepository

	CivMorteService(CivMorteRepository civMorteRepository, StatoCivileService statoCivileService,
					CivMargineService civMargineService, CivAnagrafeService civAnagrafeService,
					CivTipoAttoService civTipoAttoService, ArcComuneBaseService arcComuneBaseService,
					CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
					CivComunicazioneAttoService civComunicazioneAttoService, CivTrasportoESeppellimentoService civTrasportoESeppellimentoService,
					CivAnnotazioneAttoService civAnnotazioneAttoService, CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService,
					ArcParametroService arcParametroService, CivSoggettoCollegatoService civSoggettoCollegatoService,
					CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civMorteRepository = civMorteRepository
		this.statoCivileService = statoCivileService
		this.civMargineService = civMargineService
		this.civAnagrafeService = civAnagrafeService
		this.civTipoAttoService = civTipoAttoService
		this.arcComuneBaseService = arcComuneBaseService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civTrasportoESeppellimentoService = civTrasportoESeppellimentoService
		this.civAnnotazioneAttoService = civAnnotazioneAttoService
		this.civAnnotazioneTestoLiberoService = civAnnotazioneTestoLiberoService
		this.arcParametroService = arcParametroService
		this.civSoggettoCollegatoService = civSoggettoCollegatoService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civMorteRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civMorteRepository.findBloccato(id)
	}

	ETipoSiNo getCertificabile(Long id) {
		return civMorteRepository.findCertificabile(id)
	}

	Boolean isInviatoAnsc(Long id) {
		String idAttoAnsc = civMorteRepository.findIdAttoAnsc(id)
		return (!(TestoUtils.isVuoto(idAttoAnsc)))
	}

	Boolean isFirmatoUscAnsc(Long id) {
		return civMorteRepository.findFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(Long id) {
		return (civMorteRepository.findFirmatoCartaceoAnsc(id) > 0)
	}

	Boolean isConformeAnsc(Long id) {
		return (civMorteRepository.findConformeAnsc(id, ETipoArchivioAnsc.MOR) > 0)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		return list([idAttoAnsc: idAttoAnsc]).size() > 0
	}

	Boolean hasAllegatiInviatiAnsc(Long id) {
		return (civMorteRepository.hasAllegatiInviatiAnsc(id) > 0)
	}

	CivMorte get (Long id, Map params){
		return civMorteRepository.getByParams(id, params)
	}

	CivMorte getByIdentificativoAtto(String identificativoAtto) {
		return civMorteRepository.findByIdentificativoAtto(identificativoAtto)
	}

	CivMorte getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
		return civMorteRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	@Override
	CivMorte getByIdAttoAnsc(String idAttoAnsc) {
		return civMorteRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civMorteRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	List<CivMorte> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
		List<Long> ids = statoCivileFiltroList.collect { it.id }
		return civMorteRepository.findAllByIdIn(ids)
	}

	Page<CivMorte> list (Map params) {
		return civMorteRepository.listByParams(params)
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civMorteRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civMorteRepository.updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc){
		civMorteRepository.updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivMorte obj, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine,
							Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, Boolean composizioneTestoAttiva, EGestioneConsolidamento gc){

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		civValidazioneAttoService.checkOrarioEvento(obj.oraMorte, obj.oraMorteImprecisata, obj.minutoMorte, obj.minutoMorteImprecisato, !datiProvenienza.flagInViaggio, "( Dati Decesso )")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		// Per gli atti da annullare, il flag certificabile verrà settato a N all'atto del consolidamento
		civValidazioneAttoService.checkNaturaVsCertificazioneAlSalvataggio(obj)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale")

		if (DataUtils.isDataFutura(obj.dataMorte)){
			throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_data_futura)
		}

		// IN FUNZIONE DI PARTE E SERIE / CATEGORIA
		// refs #63197
		if ((obj.isEstremiDecessoDecisionVisible()) && obj.estremiDecessoNoti.equals(ETipoSiNo.NO)) {
			log.info ("Non è obbligatorio indicare le generalità del deceduto; es: è stato rinvenuto un cadavere tra la via xxx e la via yyyy")
			if ( ((obj.descrizioneEventoMorte?:"") == "") && ((obj.descrizioneDataMorte?:"") == "") && ((obj.descrizioneOrarioMorte?:"") == "") ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_salvataggio, ": non è stato compilato alcun campo della sezione 'Dati Decesso'")
			}
		} else {
			Boolean checkResidenza1 = Boolean.TRUE
			// Solo per atti in inserimento e integrazione ANSC attiva
			Boolean checkDatiAggiuntivi = (obj.isCodRec3() && anscOn)
			civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, "'Dati Deceduto/a'", checkResidenza1, checkDatiAggiuntivi, checkDatiAggiuntivi, checkDatiAggiuntivi, checkDatiAggiuntivi)

			String sezioneDatiDecesso = "'Dati Decesso'"
            if (!datiProvenienza.flagInViaggio && (obj.dataMorte == null) && (!(obj.giornoMorteImprecisato || obj.meseMorteImprecisato || obj.annoMorteImprecisato ) ) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiDecesso)
            }

			if ((obj.comuneMorte?.codice == null) || (obj.comuneMorte?.codiceProvincia == null)){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiDecesso)
			}
		}

		// refs #51365
		// Per Ansc refs #60743
		if (anscOn && obj.isConiugeMandatory() && obj.isCodRec3()) {
			if ( (!(obj.cognomeConiuge?.trim())) && (!(obj.nomeConiuge?.trim())) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if ( (!(obj.cognomeConiuge?.trim())) && (!(obj.senzaCognomeConiuge)) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if ( (!(obj.cognomeConiuge?.trim())) && (!(obj.senzaNomeConiuge)) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}
			/*
			Non più obbligatori dalla relesae 1.8.1 di ANSC
			if (obj.sessoConiuge == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if (obj.dataNascitaConiuge == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if ((obj.comuneNascitaConiuge.codice == null) || (obj.comuneNascitaConiuge.codiceProvincia == null)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if ((obj.comuneResidenzaConiuge.codice == null) || (obj.comuneResidenzaConiuge.codiceProvincia == null)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}

			if (obj.nazionalitaConiuge == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_coniuge)
			}
			*/
		}

		if ( (datiProvenienza.tipoComparente?:"") == ""){
			if ( obj.isPartePrima() || obj.isSecondaA() ) {
				if (obj.isCodRec3()){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campo_comparente)
				} else {
					if (obj.isCodRec0() && composizioneTestoAttiva ){
						datiProvenienza.tipoComparente = ETipoDichiaranteMorte.C1
					}
				}
			}
		}

		if ( (datiProvenienza.tipoFirmatario?:"") == ""){
			if ( obj.isPartePrima() || obj.isSecondaA() ) {
				if (obj.isCodRec3()){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campo_firmatario)
				} else {
					if (obj.isCodRec0() && composizioneTestoAttiva ){
						datiProvenienza.tipoFirmatario = datiProvenienza.tipoComparente
					}
				}
			}
		}

		// IN FUNZIONE DI PARTE E SERIE / CATEGORIA
		// 2B
		if (anscOn && obj.isSecondaB() && obj.isCodRec3()) {
			if ( ((datiProvenienza.documentoDecesso ?: "") == "" ) || (datiProvenienza.dataDocumentoDecesso == null) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, "'Dati per Redazione'")
			}
		}

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.O ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
                    // DECEDUTO
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, margine, datiProvenienza.formulaDfaAnnotazioneNascita1)
					break
			}
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivMorte obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVMOR per id " + obj.id)

		CivMorte newest = DomainUtils.copyAtto(obj) as CivMorte
		newest.id = statoCivileService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civMorteRepository.save(newest)
	}

	CivMorte save (ETipoOperazione tipoOperazione, CivMorte obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine,
				   CivTrasportoESeppellimento trasporto, Map<String, CivNumerazioneDocumentiUscita> numerazioneDocumenti,
				   Map<String, CivFormulaTestoLibero> mapFormule, Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni,
				   Boolean composizioneTestoAttiva, EGestioneConsolidamento gc,
				   Boolean tipoMargineLateraleMandatory, List<CivSoggettoCollegato> soggettiCollegati,
				   Map<ETipoFormulaAnnotazioneDaAtto, ETipoSalvataggioAnnotazioneComuneCliente> tipoSalvataggioAnnotazioneComuneCliente = [:],
				   boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

        validaDati(tipoOperazione, obj, datiProvenienza, margine, mapAnnotazioni, composizioneTestoAttiva, gc)

		ArcComune c = arcComuneBaseService.getComuneCliente()

        if (margine){
            DomainUtils.initFromAtto(margine, obj)
			// 1 allineare sempre
			// 2 se comune diverso da comune utente stampare formula del margine
			// Doc in S:\SI4\De4\De4GSDzk\Doc\Nco\Nco.CIV.Margine.docx
			margine.descrizioneComuneTras1 = obj.descrizioneComuneResidenza
			margine.stampaFormulaMargineTr1 = Boolean.FALSE
			if (FormulaUtils.addFormulaDecesso(FormulaUtils.FORMULA_MARGINE_TR1, tipoOperazione, obj, c) &&
					(obj.codiceComuneResidenza != null) && (obj.codiceProvinciaResidenza != null)) {
				if ( arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, c) ) {
					log.info ("Il comune di residenza del deceduto è valorizzato e coincide con il comune utente")
				} else {
					Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()
					if (!(anscOn)) {
						margine.stampaFormulaMargineTr1 = Boolean.TRUE
					}
				}
			}

            margine.stampaFormulaNascita = Boolean.FALSE
			if ( FormulaUtils.addFormulaDecesso(FormulaUtils.FORMULA_MARGINE_NASCITA, tipoOperazione, obj, c) ){
				margine.stampaFormulaNascita = Boolean.TRUE
                if ( (margine.codiceComuneAttoNascita != null) || (margine.descrizioneComuneAttoNascita != null) ){
					margine.dataFirmaAttoNascita = (obj.natura == ENaturaAtto.O?datiProvenienza.dataAtto:datiProvenienza.dataAttoOriginale)
				} else {
                    margine.dataFirmaAttoNascita = null
                }
			}

            if (margine.tipoMargineLaterale == null){
                String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
                margine.tipoMargineLaterale = (tm?(ETipoMargineLaterale.valueOf(tm)?:null):null)
            }
            /*
            Da gestire solo in caso di formato A3
            if (margine.tipoMargineIntestazione == null){
                String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineAB)
                margine.tipoMargineIntestazione = (tm?(ETipoMargineIntestazione.valueOf(tm)?:null):null)
            }
            */
            civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory)
        }

        if (datiProvenienza) {
            DomainUtils.initFromAtto(datiProvenienza, obj)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			dvc.dichiaranteMandatory = (obj.isCodRec3() && obj.isComprensioneDichiaranteVisibile())
			dvc.richiedenteTeaMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())
			dvc.richiedenteTepMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaPrivato())
			dvc.attoDaTrascrivereMandatory = (obj.isCodRec3() && (obj.isTrascrizioneEsteroDaAutorita() || obj.isTrascrizioneEsteroDaPrivato()))
			dvc.estremiAttoDaTrascrivereMandatory = dvc.attoDaTrascrivereMandatory
			dvc.consolatoMandatory = (obj.isCodRec3() && obj.isConsolatoMandatory() && !datiProvenienza.flagInViaggio)
			dvc.dataTrascrizioneMandatory = (obj.isCodRec3() && datiProvenienza.flagInViaggio)

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
				}
				Boolean soggettoCollegatoMandatory = (obj.isCodRec3() && saveSoggetto)
				if (saveSoggetto){
					civSoggettoCollegatoService.save(sc, obj.getTipoAttoEnum(), soggettoCollegatoMandatory)
				} else {
					civSoggettoCollegatoService.delete(sc)
				}
			}
		}

		//Trasporto&Seppellimento
		if (trasporto) {
			DomainUtils.initFromAtto(trasporto, obj)
			civTrasportoESeppellimentoService.save(trasporto, numerazioneDocumenti, obj.isCodRec0())
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
                case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
					obj.setCodRec0()
                    handleCertificabile(obj, datiProvenienza)
                    break
				case EGestioneConsolidamento.ANNULLAMENTO:
                case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
					obj.setCodRec0()
					obj.setBloccato(Boolean.TRUE)
                    handleCertificabile(obj, datiProvenienza)
                    break
            }
        }

		//Annnotazioni da apporre solo a seguito di consolidamento
		//Le annotazioni in caso di consolidamento vanno gestite prima di un eventuale intervento su civana
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.O ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
					for ( Map.Entry<String, CivAnnotazioneTestoLibero> e : mapAnnotazioni ) {
						switch (e.getValue().tipoFormula) {
							case ETipoFormulaAnnotazioneDaAtto.NAS_1:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(obj, margine, datiProvenienza.formulaDfaAnnotazioneNascita1, e.getValue(), tipoSalvataggioAnnotazioneComuneCliente[ETipoFormulaAnnotazioneDaAtto.NAS_1])
								break
						}
					}
					break
			}
		}

        //Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
        //Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
        //se il comune di residenza del deceduto non coincide con quello del cliente
        if (anagrafe != null){
			Integer fasciaSoggetto1 = anagrafe?.anagrafe1?.fascia?.id?:(new Integer(0))
			Boolean isComuneUtenteResidenzaDeceduto = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, c) || (fasciaSoggetto1.intValue() == 3))
			if ( obj.isCodRec3() ||
                    ( obj.isCodRec0() && isComuneUtenteResidenzaDeceduto && ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) ) ){
                DomainUtils.initFromAtto(anagrafe, obj)

                if (obj.natura == ENaturaAtto.T ){
					DomainUtils.initAttoOriginaleAnagrafeFromDatiProvenienzaAtto(anagrafe, datiProvenienza)
                }

				if (obj.isCodRec0() && (anagrafe.anagrafe1 == null) ){
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
                    if (FormulaUtils.addFormulaDecesso(e.key, tipoOperazione, obj)){
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

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVMOR per id " + obj.id)
        CivMorte saved = civMorteRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
        return saved
	}

	private void handleCertificabile(CivMorte obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.natura == ENaturaAtto.N){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		// check flag introdotto per ansc use case 2214
		if (obj.isTrascrizioneEsteroDaPrivato() && datiProvenienza.flagExArt19){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		if ((obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T)){
			obj.certificabile = ETipoSiNo.SI
		}
	}

	EMotivoRecupero getMotivoRecuperoAnsc(Long id){
		return civMorteRepository.findMotivoRecuperoAnsc(id)
	}

	void ripristina(ETipoOperazione tipoOperazione, CivMorte obj, EGestioneConsolidamento gc){
		if (tipoOperazione.isUpdate()){
			switch (gc) {
				case EGestioneConsolidamento.BLOCCO:
					obj.bloccato = getBloccato(obj.id)
					break
				case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
					obj.codiceRecord = getCodiceRecord(obj.id)
					obj.certificabile = getCertificabile(obj.id)
					break
				case EGestioneConsolidamento.ANNULLAMENTO:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
					obj.codiceRecord = getCodiceRecord(obj.id)
					obj.bloccato = getBloccato(obj.id)
					obj.certificabile = getCertificabile(obj.id)
					break
			}
		}
	}

	void delete(CivMorte obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_cancellazione_entita)
			}
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVMOR per id " + obj.id)
			civMorteRepository.delete(obj)
		}
	}
}
