package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IAttoCertificabileService
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
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
class CivMatrimonioService implements IAttoCertificabileService {

	private final GsdService gsdService

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

	private final ArcParametroService arcParametroService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivSoggettoCollegatoService civSoggettoCollegatoService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivMatrimonioRepository civMatrimonioRepository

	CivMatrimonioService(CivMatrimonioRepository civMatrimonioRepository, GsdService gsdService,
                         CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
                         CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
                         CivComunicazioneAttoService civComunicazioneAttoService, ArcComuneBaseService arcComuneBaseService,
                         CivSposiAttoService civSposiAttoService, CivTestimoniAttoService civTestimoniAttoService,
                         CivAnnotazioneAttoService civAnnotazioneAttoService, CivAnnotazioneTestoLiberoService civAnnotazioneTestoLiberoService,
                         ArcParametroService arcParametroService, CivSoggettoCollegatoService civSoggettoCollegatoService,
                         CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civMatrimonioRepository = civMatrimonioRepository
		this.gsdService = gsdService
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
		this.arcParametroService = arcParametroService
		this.civSoggettoCollegatoService = civSoggettoCollegatoService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civMatrimonioRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civMatrimonioRepository.findBloccato(id)
	}

	ETipoSiNo getCertificabile(Long id) {
		return civMatrimonioRepository.findCertificabile(id)
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
		return list([idAttoAnsc: idAttoAnsc]).size() > 0
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

	CivMatrimonio getByIdAttoAnsc(String idAttoAnsc) {
		return civMatrimonioRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		// La serie può essere nulla
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	CivDatiProvenienzaAtto getDatiProvenienzaByUkAtto(String identificativoAtto) {
		return civDatiProvenienzaAttoService.getByUkAtto(identificativoAtto)
	}

	CivMatrimonio getXDatiAnagraficiSposi(String cnSposo, String nSposo, Date dnSposo, String cnSposa, String nSposa, Date dnSposa){
		if (dnSposo && cnSposo?.trim() && nSposo?.trim() && dnSposa && cnSposa?.trim() && nSposa?.trim()){
			List<CivMatrimonio> l = civMatrimonioRepository.listXDatiAnagraficiSposi(cnSposo, nSposo, dnSposo, cnSposa, nSposa, dnSposa, ENaturaAtto.O)
			if (l.size() == 1){
				return l[0]
			}
		}
		return null
	}

	List<CivMatrimonio> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
		List<Long> ids = statoCivileFiltroList.collect { it.id }
		return civMatrimonioRepository.findAllByIdIn(ids)
	}

	CivMatrimonio getAccordoXDatiAnagraficiSposi(String cnSposo, String nSposo, Date dnSposo, String cnSposa, String nSposa, Date dnSposa){
		if (dnSposo && cnSposo?.trim() && nSposo?.trim() && dnSposa && cnSposa?.trim() && nSposa?.trim()){
			List<CivMatrimonio> l = civMatrimonioRepository.listAccordoXDatiAnagraficiSposi(cnSposo, nSposo, dnSposo, cnSposa, nSposa, dnSposa, ENaturaAtto.D, CivCategoriaTipoAtto.UAC)
			if (l.size() == 1){
				return l[0]
			}
		}
		return null
	}

	Page<CivMatrimonio> list (Map params) {
		return civMatrimonioRepository.listByParams(params)
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civMatrimonioRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civMatrimonioRepository.updateIdAttoAnsc(id, idAttoAnsc)
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
		Boolean checkComprensione1 = (obj.isCodRec3() && anscOn && !datiProvenienza.flagInViaggio)
		Boolean checkLuogoNascita1 = (obj.isCodRec3() && anscOn && !((obj.isTrascrizioneEsteroDaAutorita() && !datiProvenienza.flagInViaggio) || obj.isTrascrizioneEsteroDaPrivato()))
		String sezioneS1 = "'Sposi' - Generalità sposo incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, sezioneS1, checkResidenza1, checkLuogoNascita1, checkDatiAggiuntivi1, checkDatiAggiuntivi1, Boolean.FALSE, checkComprensione1)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome Sposo")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale Sposo")

		// Solo per atti in inserimento e integrazione ANSC attiva
		Boolean checkDatiAggiuntivi2 = (obj.isCodRec3() && anscOn)
		Boolean checkComprensione2 = (obj.isCodRec3() && anscOn && !datiProvenienza.flagInViaggio)
		Boolean checkLuogoNascita2 = (obj.isCodRec3() && anscOn && !((obj.isTrascrizioneEsteroDaAutorita() && !datiProvenienza.flagInViaggio) || obj.isTrascrizioneEsteroDaPrivato()))
		String sezioneS2 = "'Sposi' - Generalità sposa incomplete "
		civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto2(obj, sezioneS2, checkLuogoNascita2, checkDatiAggiuntivi2, checkDatiAggiuntivi2, Boolean.FALSE, checkComprensione2)

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto2(obj, "Cognome/Nome Sposa")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto2(obj, "Codice Fiscale Sposa")

		civValidazioneAttoService.checkOrarioEvento(obj.oraMatrimonio, Boolean.FALSE, obj.minutoMatrimonio, Boolean.FALSE, Boolean.FALSE, "( Dati Matrimonio )")

		civValidazioneAttoService.checkComuneEventoMandatory(obj, "'Dati Matrimonio'")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		// Per gli atti da annullare, il flag certificabile verrà settato a N all'atto del consolidamento
		civValidazioneAttoService.checkNaturaVsCertificazioneAlSalvataggio(obj)

		// Solo per atti in inserimento e integrazione ANSC attiva
		if (anscOn && obj.isCodRec3() && obj.isRiconoscimentoFigliVisibile() && !datiProvenienza.flagInViaggio) {
			String sezioneRiconoscimento = "'Riconoscimento Figli'"
			if (obj.riconoscimentoFigli == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneRiconoscimento)
			}
			/*
			if ( (obj.riconoscimentoFigli == ETipoSiNo.SI) && (obj.numeroFigli == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneRiconoscimento)
			}
			*/
		}
		// Solo per atti in inserimento e integrazione ANSC attiva
		if (anscOn && obj.isCodRec3()) {
			if (obj.isDifettoEtaParentelaDivietoTempVisibile()) {
				String sezioneAltriDati = "'Redazione - Altri Dati'"
				if ((obj.difettoEta == null) || (obj.impedimentoParentelaMatrimonio == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
				}
				if ((obj.difettoEta == ETipoDifettoEta.D2) || (obj.difettoEta == ETipoDifettoEta.D4) && (obj.tipoAssistenzaMinore1 == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
				}
				if ((obj.difettoEta == ETipoDifettoEta.D3) || (obj.difettoEta == ETipoDifettoEta.D4) && (obj.tipoAssistenzaMinore2 == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
				}
				if (obj.difettoEta != ETipoDifettoEta.D1) {
					if (!(ValidationUtils.isComuneAndDataFormazioneValid(datiProvenienza.comuneAttoImpedimentoEta, datiProvenienza.dataAttoImpedimentoEta))) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}

					if (TestoUtils.isVuoto(datiProvenienza.enteImpedimentoEta) || TestoUtils.isVuoto(datiProvenienza.estremiDocumentoImpedimentoEta)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}
				}
				if (obj.impedimentoParentelaMatrimonio != ETipoImpedimentoParentelaMatrimonio.I0) {
					if (!(ValidationUtils.isComuneAndDataFormazioneValid(datiProvenienza.comuneAttoImpedimentoParentela, datiProvenienza.dataAttoImpedimentoParentela))) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}

					if (TestoUtils.isVuoto(datiProvenienza.enteImpedimentoParentela) || TestoUtils.isVuoto(datiProvenienza.estremiDocumentoImpedimentoParentela)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}
				}
				if (obj.flagDivietoTemporaneo) {
					if (!(ValidationUtils.isComuneAndDataFormazioneValid(datiProvenienza.comuneAttoDivietoTemporaneo, datiProvenienza.dataAttoDivietoTemporaneo))) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}

					if (TestoUtils.isVuoto(datiProvenienza.enteDivietoTemporaneo) || TestoUtils.isVuoto(datiProvenienza.estremiDocumentoDivietoTemporaneo)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
					}
				}
				if (datiProvenienza.isStranieriNonResidenti()) {
					if (TestoUtils.isVuoto(datiProvenienza.autoritaEnteStraniero) ||
							(datiProvenienza.dataAttoEnteStraniero == null) ||
							(datiProvenienza.comuneEnteStraniero.codice == null) ||
							(datiProvenienza.comuneEnteStraniero.codiceProvincia == null) ||
							TestoUtils.isVuoto(datiProvenienza.autoritaEnteStraniero) ||
							TestoUtils.isVuoto(datiProvenienza.tipoAttoEnteStraniero)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), 'Redazione - Estremi Certificazione')
					}
				}
			}

			civValidazioneAttoService.checkDataOraEvento(obj, 'Dati Matrimonio')

			civValidazioneAttoService.checkUfficialeStatoCivile(obj, datiProvenienza)
		}

		//DICHIARANTE-COMPARENTE-FIRMATARIO
		Boolean checkDich = obj.isCodRec3() && obj.isDichMatUciVisibile() && anscOn
		Boolean checkComp = obj.isCodRec3() && obj.isCompMatUciVisibile() && anscOn
		Boolean checkFirm = obj.isCodRec3() && obj.isFirmMatUciVisibile() && anscOn
		civValidazioneAttoService.checkDichiaranteComparenteFirmatario(datiProvenienza, checkDich, checkComp, checkFirm)

		// Da controllare solo all'atto del consolidamento
		if (tipoOperazione.isUpdate() && ( ( obj.natura == ENaturaAtto.O ) || obj.isTrascrizioneMatrimonioCivileSuDelega() ) && (mapAnnotazioni != null) && (gc != null)) {
			switch (gc) {
				case EGestioneConsolidamento.CONSOLIDAMENTO_CERTIFICAZIONE:
				case EGestioneConsolidamento.CONSOLIDAMENTO_BLOCCO_CERTIFICAZIONE:
					//SPOSO
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto1(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita1)

					//SPOSA
					civAnnotazioneAttoService.validaDatiAttoNascitaSoggetto2(obj, sposi, datiProvenienza.formulaDfaAnnotazioneNascita2)
					break
			}
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
						CivTestimoniAtto testimoni, Map<String, CivFormulaTestoLibero> mapFormule, Map<String, CivAnnotazioneTestoLibero> mapAnnotazioni, EGestioneConsolidamento gc,
						Boolean tipoMargineLateraleMandatory, List<CivSoggettoCollegato> soggettiCollegati,
						boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, sposi, mapAnnotazioni, gc)

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		ArcComune c = arcComuneBaseService.getComuneCliente()

		if (margine){
			DomainUtils.initFromAtto(margine, obj)

			// 1 allineare sempre
			// 2 se comune diverso da comune utente stampare formula del margine
			// Doc in S:\SI4\De4\De4GSDzk\Doc\Nco\Nco.CIV.Margine.docx
			margine.descrizioneComuneTras1 = obj.descrizioneComuneResidenza1
			margine.stampaFormulaMargineTr1 = Boolean.FALSE
			if (FormulaUtils.addFormulaMatrimonio(FormulaUtils.FORMULA_MARGINE_TR1, tipoOperazione, obj, margine, c) &&
					(obj.codiceComuneResidenza1 != null) && (obj.codiceProvinciaResidenza1 != null)) {
				if ( arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, c) ) {
					log.info ("Il comune di residenza dello sposo è valorizzato e coincide con il comune utente")
				} else {
					margine.parteTras1 = "2"
					margine.serieTras1 = (obj.isSecondaA()?CivTipoAtto.SERIE_B:CivTipoAtto.SERIE_C)
					if (!(anscOn)) {
						margine.stampaFormulaMargineTr1 = Boolean.TRUE
					}
				}
			}

			margine.descrizioneComuneTras2 = obj.descrizioneComuneResidenza2
			margine.stampaFormulaMargineTr2 = Boolean.FALSE
			if (FormulaUtils.addFormulaMatrimonio(FormulaUtils.FORMULA_MARGINE_TR2, tipoOperazione, obj, margine, c) &&
					(obj.codiceComuneResidenza2 != null) && (obj.codiceProvinciaResidenza2 != null)) {
				if ( arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, c) ) {
					log.info ("Il comune di residenza della sposa è valorizzato e coincide con il comune utente")
				} else {
					margine.parteTras2 = "2"
					margine.serieTras2 = (obj.isSecondaA()?CivTipoAtto.SERIE_B:CivTipoAtto.SERIE_C)
					if (!(anscOn)) {
						margine.stampaFormulaMargineTr2 = Boolean.TRUE
					}
				}
			}

			if (margine.stampaFormulaLibretto){
				if (!(FormulaUtils.addFormulaMatrimonio(FormulaUtils.FORMULA_MARGINE_LIBRETTO, tipoOperazione, obj, margine))) {
					throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_formula_libretto_internazionale"))
				}
			}

            margine.stampaFormulaMinistro = Boolean.FALSE
            if ( FormulaUtils.addFormulaMatrimonio(FormulaUtils.FORMULA_MARGINE_MINISTRO, tipoOperazione, obj, margine) ) {
				if ( (datiProvenienza?.luogoMatrimonio?.trim()) && (datiProvenienza?.luogoMatrimonio?.length() > 20) ){
					margine.ministro1 = datiProvenienza.luogoMatrimonio.substring(0, 20)
					margine.ministro2 = datiProvenienza.luogoMatrimonio.substring(20)
				} else {
					margine.ministro1 = datiProvenienza?.luogoMatrimonio
					margine.ministro2 = null
				}
				if (!(anscOn)) {
					margine.stampaFormulaMinistro = Boolean.TRUE
				}
            }

			if (margine.tipoMargineLaterale == null){
				String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
				margine.tipoMargineLaterale = (tm?ETipoMargineLaterale.valueOf(tm):null)
			}

			Boolean sceltaConvenzioniMandatory = obj.convenzioni
			Boolean pubblicazioniMandatory = !datiProvenienza.isStranieriNonResidenti()
			civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory, sceltaConvenzioniMandatory, pubblicazioniMandatory)
		}

		if (sposi){
			DomainUtils.initFromAtto(sposi, obj)

			civSposiAttoService.save(sposi, obj.tipoAttoEnum)
		}

		if (testimoni){
			DomainUtils.initFromAtto(testimoni, obj)

			Boolean numTestimoniMandatory = (obj.isCodRec3() && obj.isTestimoniMandatory())
			civTestimoniAttoService.save(testimoni, numTestimoniMandatory)
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			dvc.richiedenteTeaMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())
			dvc.richiedenteTepMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaPrivato())
			dvc.attoDaTrascrivereMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita() || obj.isTrascrizioneEsteroDaPrivato())
			dvc.estremiAttoDaTrascrivereMandatory = dvc.attoDaTrascrivereMandatory
			dvc.fuoriCasaComunaleMandatory  = (obj.isCodRec3() &&
					(obj.isFuoriCasaComunale() || obj.isPericoloVita() || (obj.isCivileXDelega() && (!datiProvenienza.flagCasaComunale) ) ) )
			dvc.provenienzaCpdMandatory      = (obj.isCodRec3() && obj.isCivileXDelega())
			dvc.luogoCelebrazioneMandatory  = (obj.isCodRec3() && obj.isSecondaA())
			dvc.consolatoMandatory = (obj.isCodRec3() && obj.isConsolatoMandatory() && !datiProvenienza.flagInViaggio)
			dvc.firmatarioMandatory = dvc.richiedenteTepMandatory
			dvc.dataTrascrizioneMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita() && datiProvenienza.flagInViaggio)
			dvc.estremiTrascrizioneMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita() && datiProvenienza.flagInViaggio)

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
				civAnnotazioneTestoLiberoService.save(e.getValue(), obj.tipoAttoEnum)
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
		if (tipoOperazione.isUpdate() && ( ( obj.natura == ENaturaAtto.O ) || obj.isTrascrizioneMatrimonioCivileSuDelega() ) && (mapAnnotazioni != null) && (gc != null)) {
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
						}
					}
					break
			}
		}

		//Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
		//Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
		//se il comune di residenza dello sposo E quello della sposa NON coincidono con il comune del cliente
		if (anagrafe != null){
			Integer fasciaSoggetto1 = anagrafe?.anagrafe1?.fascia?.id?:new Integer(0)
			Integer fasciaSoggetto2 = anagrafe?.anagrafe2?.fascia?.id?:new Integer(0)
			Boolean isComuneUtenteResidenzaSposo = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza1, obj.codiceProvinciaResidenza1, c) || (fasciaSoggetto1.intValue() == 3))
			Boolean isComuneUtenteResidenzaSposa = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza2, obj.codiceProvinciaResidenza2, c) || (fasciaSoggetto2.intValue() == 3))
			if ( obj.isCodRec3() ||
					( obj.isCodRec0() && ( isComuneUtenteResidenzaSposo || isComuneUtenteResidenzaSposa ) && ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) ) ){
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
					if (FormulaUtils.addFormulaMatrimonio(e.key, tipoOperazione, obj, margine)){
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

	private void handleCertificabile(CivMatrimonio obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.natura == ENaturaAtto.N){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		// check flag introdotto per ansc use case 336000
		if (obj.isTrascrizioneEsteroDaPrivato() && datiProvenienza.flagExArt19){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		// refs #63527
		if ( (obj.isTrascrizioneEsteroDaAutorita() || obj.isTrascrizioneEsteroDaPrivato()) &&
			 (obj.nazionalita1?.codCi != null) && (obj.nazionalita2?.codCi != null) &&
			 (obj.nazionalita1?.codCi != AnaCittadinanza.ID_ITALIA) && (obj.nazionalita2?.codCi != AnaCittadinanza.ID_ITALIA) ){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		if ((obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T)){
			obj.certificabile = ETipoSiNo.SI
		}
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

			log.info("Tento cancellazione su CIVMAT per id " + obj.id)
			civMatrimonioRepository.delete(obj)
		}
	}

}
