package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IAttoCertificabileService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivUnioneCivileService implements IAttoCertificabileService {

	private final GsdService gsdService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final CivSposiAttoService civSposiAttoService

	private final CivTestimoniAttoService civTestimoniAttoService

	private final CivDocumentoPubblicazioneService civDocumentoPubblicazioneService

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

	CivUnioneCivileService(CivUnioneCivileRepository civUnioneCivileRepository, GsdService gsdService,
                           CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
                           CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
                           CivComunicazioneAttoService civComunicazioneAttoService, CivSposiAttoService civSposiAttoService,
                           CivTestimoniAttoService civTestimoniAttoService, CivDocumentoPubblicazioneService civDocumentoPubblicazioneService,
                           CivAnnotazioneAttoService civAnnotazioneAttoService, ArcComuneBaseService arcComuneBaseService,
                           CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService,
                           CivSoggettoCollegatoService civSoggettoCollegatoService, ArcParametroService arcParametroService,
                           CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civUnioneCivileRepository = civUnioneCivileRepository
		this.gsdService = gsdService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civAnagrafeService = civAnagrafeService
		this.civMargineService = civMargineService
		this.civTipoAttoService = civTipoAttoService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.civSposiAttoService = civSposiAttoService
		this.civTestimoniAttoService = civTestimoniAttoService
		this.civDocumentoPubblicazioneService = civDocumentoPubblicazioneService
		this.civAnnotazioneAttoService = civAnnotazioneAttoService
		this.arcComuneBaseService = arcComuneBaseService
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

	ETipoSiNo getCertificabile(Long id) {
		return civUnioneCivileRepository.findCertificabile(id)
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
	CivAttoBaseDomain getByIdAttoAnsc(String idAttoAnsc) {
		return civUnioneCivileRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		log.info ("Parametro serie non gestito per uci: " + (serie?:"") )
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civUnioneCivileRepository.countByUfficioAndAnnoAndAttoAndParteAndSerieIsNull(ufficio, anno, atto, parte)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	CivDatiProvenienzaAtto getDatiProvenienzaByUkAtto(String identificativoAtto) {
		return civDatiProvenienzaAttoService.getByUkAtto(identificativoAtto)
	}

	CivUnioneCivile getXDatiAnagraficiSposi(String cognome1, String nome1, Date dn1, String cognome2, String nome2, Date dn2){
		if (dn1 && cognome1?.trim() && nome1?.trim() && dn2 && cognome2?.trim() && nome2?.trim()){
			List<CivUnioneCivile> l = civUnioneCivileRepository.listXDatiAnagraficiSposi(cognome1, nome1, dn1, cognome2, nome2, dn2, ENaturaAtto.O)
			if (l.size() == 1){
				return l[0]
			}
		}
		return null
	}

	List<CivUnioneCivile> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
		List<Long> ids = statoCivileFiltroList.collect { it.id }
		return civUnioneCivileRepository.findAllByIdIn(ids)
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
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, sezioneC2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, Boolean.FALSE, checkDatiAggiuntivi2)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Contraente 2")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Contraente 2")

		civValidazioneAttoService.checkSessoContraenti(obj, obj)

		civValidazioneAttoService.checkOrarioEvento(obj.oraMatrimonio, Boolean.FALSE, obj.minutoMatrimonio, Boolean.FALSE, Boolean.FALSE, "( Dati Unione Civile )")

		civValidazioneAttoService.checkComuneEventoMandatory(obj, "'Dati Unione Civile'")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		// Per gli atti da annullare, il flag certificabile verrà settato a N all'atto del consolidamento
		civValidazioneAttoService.checkNaturaVsCertificazioneAlSalvataggio(obj)

		// Solo per atti in inserimento e integrazione ANSC attiva
		if (anscOn && obj.isCodRec3()) {
			if (obj.isImpedimentoGenericoVisibile()) {
				String sezioneAltriDati = "'Redazione - Altri Dati'"
				if (datiProvenienza.impedimentoGenericoUci == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
				}
			}

			civValidazioneAttoService.checkDataOraEvento(obj, "'Dati Unione Civile'")

			civValidazioneAttoService.checkUfficialeStatoCivile(obj, datiProvenienza)
		}

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		Boolean checkDich = obj.isCodRec3() && obj.isDichMatUciVisibile() && anscOn
		Boolean checkComp = obj.isCodRec3() && obj.isCompMatUciVisibile() && anscOn
		Boolean checkFirm = obj.isCodRec3() && obj.isFirmMatUciVisibile() && anscOn
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, checkDich, checkComp, checkFirm)

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( obj.natura == ENaturaAtto.O ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
					//CONTRAENTE 1
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1)

					//CONTRAENTE 2
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2)

					//MATRIMONIO (caso UCN)
					civAnnotazioneAttoService.validaDatiAttoMatUci(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio)
					break
			}
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivUnioneCivile obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVUCI per id " + obj.id)

		CivUnioneCivile newest = DomainUtils.copyAtto(obj) as CivUnioneCivile
		newest.id = gsdService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civUnioneCivileRepository.save(newest)
	}

	CivUnioneCivile save (ETipoOperazione tipoOperazione, CivUnioneCivile obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, CivSposiAtto sposi,
						  CivTestimoniAtto testimoni, CivDocumentoPubblicazione documentoPubblicazione,
						  Map<String, CivFormulaTestoLibero> mapFormule, Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc,
						  Boolean tipoMargineLateraleMandatory, List<CivSoggettoCollegato> soggettiCollegati,
						  boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, sposi, mapAnnotazioni, gc)

		if (margine){
			DomainUtils.initFromAtto(margine, obj)

			if ((margine.descrizioneComuneTras1?:"") == ""){
				margine.descrizioneComuneTras1 = obj.descrizioneComuneResidenza1
			}
			if ((margine.descrizioneComuneTras2?:"") == ""){
				margine.descrizioneComuneTras2 = obj.descrizioneComuneResidenza2
			}
			if (margine.tipoMargineLaterale == null){
				String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
				margine.tipoMargineLaterale = (tm?ETipoMargineLaterale.valueOf(tm):null)
			}

			Boolean sceltaConvenzioniMandatory = obj.convenzioni
			civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory, sceltaConvenzioniMandatory)
		}

		if (sposi){
			DomainUtils.initFromAtto(sposi, obj)

			civSposiAttoService.save(sposi, obj.getTipoAttoEnum())
		}

		if (documentoPubblicazione){
			DomainUtils.initFromAtto(documentoPubblicazione, obj)

			Boolean documentoPresentatoPubblicazioneMandatory = Boolean.TRUE
			if ( obj.isTrascrizioneEsteroDaPrivato() || obj.isTrascrizioneEsteroDaAutorita() || obj.isUnioneCivileConiugi() ){
				documentoPresentatoPubblicazioneMandatory = Boolean.FALSE
			}
			civDocumentoPubblicazioneService.save(documentoPubblicazione, obj.getTipoAttoEnum(), documentoPresentatoPubblicazioneMandatory)
		}

		if (testimoni){
			DomainUtils.initFromAtto(testimoni, obj)
			//refs #66156
			Boolean numTestimoniMandatory = (obj.isCodRec3() && obj.isTestimoniMandatory())
			civTestimoniAttoService.save(testimoni, numTestimoniMandatory)
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			dvc.richiedenteTeaMandatory	= (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())
			dvc.richiedenteTepMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaPrivato())
			dvc.attoDaTrascrivereMandatory = (obj.isCodRec3() && (obj.isTrascrizioneEsteroDaPrivato() || obj.isTrascrizioneEsteroDaAutorita()))
			dvc.estremiAttoDaTrascrivereMandatory = dvc.attoDaTrascrivereMandatory
			dvc.provenienzaCpdMandatory = (obj.isCodRec3() && obj.isCivileXDelega())
			dvc.fuoriCasaComunaleMandatory  = (obj.isCodRec3() &&
					(obj.isFuoriCasaComunale() || obj.isPericoloVita() || (obj.isCivileXDelega() && (!datiProvenienza.flagCasaComunale) ) ) )
			dvc.consolatoMandatory = (obj.isCodRec3() && obj.isConsolatoMandatory())
			dvc.firmatarioMandatory = dvc.richiedenteTepMandatory
			dvc.certificatoRichiestaUciMandatory = (obj.isCodRec3() && obj.isRichiestaCostituzioneVisibile())

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
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1, e.getValue())
								break
							case ETipoFormulaAnnotazioneDaAtto.NAS_2:
								civAnnotazioneAttoService.saveAnnotazioneSuAttoNascita2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2, e.getValue())
								break
							case ETipoFormulaAnnotazioneDaAtto.MAT:
								if (obj.isUnioneCivileConiugi()) {
									civAnnotazioneAttoService.saveAnnotazioneSuAttoMatrimonio(obj, sposi, datiProvenienza.formulaDfaAnnotazioneMatrimonio, e.getValue())
								}
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
			Integer fasciaSoggetto1 = anagrafe?.anagrafe1?.fascia?.id?:new Integer(0)
			Integer fasciaSoggetto2 = anagrafe?.anagrafe2?.fascia?.id?:new Integer(0)
			ArcComune c = arcComuneBaseService.getComuneCliente()
			Boolean isComuneUtenteResidenza1 = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, c) || (fasciaSoggetto1.intValue() == 3))
			Boolean isComuneUtenteResidenza2 = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, c) || (fasciaSoggetto2.intValue() == 3))
			if ( obj.isCodRec3() ||
					( obj.isCodRec0() && ( isComuneUtenteResidenza1 || isComuneUtenteResidenza2 ) && ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) ) ){
				DomainUtils.initFromAtto(anagrafe, obj)

				if (obj.natura == ENaturaAtto.T ){
					DomainUtils.initAttoOriginaleAnagrafeFromDatiProvenienzaAtto(anagrafe, datiProvenienza)
				}

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
					if (FormulaUtils.addFormulaUnioneCivile(e.key, tipoOperazione, obj, documentoPubblicazione)){
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
			obj.id = gsdService.getIdFromSequence(obj)
		}

		// Se è stato storicizzato l'atto devo incrementare la versione prima di salvarlo
		if (isRettificato) {
			obj.versioneRettifica = obj.versioneRettifica + 1
            obj.dataVersioneRettifica = new Date()
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

	private void handleCertificabile(CivUnioneCivile obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.natura == ENaturaAtto.N){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		// check flag introdotto per ansc use case 436000
		if (obj.isTrascrizioneEsteroDaPrivato() && datiProvenienza.flagExArt19){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		if ((obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T)){
			obj.certificabile = ETipoSiNo.SI
		}
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

	void delete(CivUnioneCivile obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(Etichette.getEtichetta("Errore_ANSC_cancellazione_entita"))
			}
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVUCI per id " + obj.id)
			civUnioneCivileRepository.delete(obj)
		}
	}

}
