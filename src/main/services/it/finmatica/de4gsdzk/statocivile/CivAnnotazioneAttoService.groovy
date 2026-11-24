package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAnnotazioneAttoService {

	private final ArcParametroService arcParametroService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivNascitaRepository civNascitaRepository

	private final CivMatrimonioRepository civMatrimonioRepository

    private final CivUnioneCivileRepository civUnioneCivileRepository

	private final CivFormulaAnnotazioneService civFormulaAnnotazioneService

	private final CivComunicazioneFormulaService civComunicazioneFormulaService

	private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final CivComunicazioneAllegatoService civComunicazioneAllegatoService

	private final GsdService gsdService

	private final CivAnagrafeService civAnagrafeService

	private final GsdValidazioneTestoService gsdValidazioneTestoService

	private final CivAnnotazioneAttoRepository civAnnotazioneAttoRepository

	private final CivNascitaService civNascitaService

	CivAnnotazioneAttoService(ArcParametroService arcParametroService,
                              CivAnnotazioneAttoRepository civAnnotazioneAttoRepository, GsdService gsdService,
                              CivAnagrafeService civAnagrafeService, GsdValidazioneTestoService gsdValidazioneTestoService,
                              CivArchivioComunicazioneService civArchivioComunicazioneService, CivFormulaAnnotazioneService civFormulaAnnotazioneService,
                              CivComunicazioneFormulaService civComunicazioneFormulaService, CivNascitaRepository civNascitaRepository,
                              CivMatrimonioRepository civMatrimonioRepository, CivUnioneCivileRepository civUnioneCivileRepository,
                              ArcComuneBaseService arcComuneBaseService, CivComunicazioneAllegatoService civComunicazioneAllegatoService,
                              CivNascitaService civNascitaService) {

		this.arcParametroService = arcParametroService
		this.civAnnotazioneAttoRepository = civAnnotazioneAttoRepository
		this.gsdService = gsdService
		this.civAnagrafeService = civAnagrafeService
		this.gsdValidazioneTestoService = gsdValidazioneTestoService
		this.civArchivioComunicazioneService = civArchivioComunicazioneService
		this.civFormulaAnnotazioneService = civFormulaAnnotazioneService
		this.civComunicazioneFormulaService = civComunicazioneFormulaService
		this.civNascitaRepository = civNascitaRepository
		this.civMatrimonioRepository = civMatrimonioRepository
        this.civUnioneCivileRepository = civUnioneCivileRepository
		this.arcComuneBaseService = arcComuneBaseService
		this.civComunicazioneAllegatoService = civComunicazioneAllegatoService
		this.civNascitaService = civNascitaService
	}

	CivAnnotazioneAtto get (Long id){
		return civAnnotazioneAttoRepository.findById(id)
	}

	CivAnnotazioneAtto create(EStatoAnnotazione stato, Boolean stampaSuAtto = Boolean.TRUE, stampaSuEstratto = Boolean.TRUE){
		return new CivAnnotazioneAtto(stato: stato, dataRegistrazione: (new Date()).clearTime(), stampaSuAtto: stampaSuAtto, stampaSuEstratto: stampaSuEstratto)
	}

	Page<CivAnnotazioneAtto> list (Map params) {
		if ((params.tipoAtto == null) && (params.tipiAtto == null)){
			return null
		}
		return civAnnotazioneAttoRepository.listByParams(params)
	}

	Page<CivFormulaAnnotazione> listAllDistinctFormulaDfa(Date dal, Date al, String idFormulaDfa, List<EStatoAnnotazione> listaStati, List<Integer> listaTipiatto, PageRequest p) {
		return civAnnotazioneAttoRepository.findAllDistinctFormulaDfa(dal, al, idFormulaDfa, listaStati, listaTipiatto, p)
	}

	List<CivAnnotazioneAtto> listAllByFormulaDfaAndDataRegistrazioneAndStatoAndTipoAttoIn(Date dal, Date al, String idFormulaDfa, List<EStatoAnnotazione> listaStati, List<Integer> listaTipiatto) {
		return civAnnotazioneAttoRepository.findAllByFormulaDfaAndDataRegistrazioneAndStatoAndTipoAttoIn(dal, al, idFormulaDfa, listaStati, listaTipiatto)
	}

    Page<CivAnnotazioneAtto> listAllByUkAttoAndTipoAttoAndTipoIn(String identificativoAtto, Integer tipoAtto, List<ETipoAnnotazione> listaTipi, PageRequest p){
		return civAnnotazioneAttoRepository.findAllByUkAttoAndTipoAttoAndTipoIn(identificativoAtto, tipoAtto, listaTipi, p)
	}

	Boolean existsByUkAttoAndTipoAttoAndTipoIn(String identificativoAtto, Integer tipoAtto, List<ETipoAnnotazione> listaTipi) {
		return civAnnotazioneAttoRepository.countByUkAttoAndTipoAttoAndTipoIn(identificativoAtto, tipoAtto, listaTipi) > 0
	}

	Integer getMaxSequenzaByUkAtto(String identificativoAtto) {
		int i = 1
		CivAnnotazioneAtto ann = civAnnotazioneAttoRepository.findFirstByIdAttoOrderBySequenzaDesc(identificativoAtto)
		if (ann?.sequenza){
			i = (ann?.sequenza?.intValue() + 1)
		}
		return new Integer(i)
	}

	Boolean checkAnnotazioneInUso(String idFormula) {
		Integer n = civAnnotazioneAttoRepository.checkAnnotazioneInUso(idFormula)
		return (n.intValue() > 0)
	}

	List<CivAnnotazioneAtto> listAllByUkAttoAndStatoAndStampaSuAtto(String identificativoAtto, EStatoAnnotazione stato, Boolean stampaSuAtto) {
		return civAnnotazioneAttoRepository.findAllByUkAttoAndStatoAndStampaSuAtto(identificativoAtto, stato, stampaSuAtto)
	}

	Boolean isInviatoAnsc(Long id) {
		if (id != null) {
			String idAttoAnsc = civAnnotazioneAttoRepository.findIdAttoAnsc(id)
			return (!(TestoUtils.isVuoto(idAttoAnsc)))
		}
		return Boolean.FALSE
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		return civAnnotazioneAttoRepository.countByIdAttoAnsc(idAttoAnsc) > 0
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivAnnotazioneAtto obj, CivAttoBaseDomain atto) {
        if (atto.isProvvisorio()){
			throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_inserimento_annotazione_su_provvisorio"))
        }

		if ( ( (obj.formula?:"") == "") || (obj.formulaDfa == null)  || (obj.tipoAtto == null) ) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_formula_e_tipo_atto_annotazione"))
		}
		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (atto.getTipoAttoEnum()) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.MOR:
				//FIXME: check su obbligatorietà serie per atti "normali" e atti pregressi
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
				break
            case ETipoAtto.UCI:
                emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
                break
			case ETipoAtto.CIT:
				// Le cittadinanze non hanno nè parte nè serie
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
		}
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"), "- indicare ufficio, anno, atto e tipo di atto cui l'annotazione è associata")
		}

		// L'inserimento da popup non si porta dietro i dati di provenienza per cui non posso bloccare il salvataggio in insert
		if (obj.flagIstat && (obj.genere == null) && tipoOperazione.isUpdate()){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_genere_annotazione"))
		}
		// I dati sono obbligatori sia per ANSC che per le annotazioni da provvedimento da inviare all'ISTAT
		if (obj.isProvenienzaEnte() && tipoOperazione.isUpdate()){
			String sezioneProvenienza = "'Provenienza'"
			if ( TestoUtils.isVuoto(obj.estremiDocumentoProvenienza) || (obj.comuneProvenienza.codice == null) || (obj.comuneProvenienza.codiceProvincia == null) || (obj.dataProvenienza == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneProvenienza)
			}
		}
	}

	boolean validaDatiAttoNascitaSoggetto1(CivAttoBaseDomain obj, IEstremiAttoNascitaSoggetto1Domain ad, String formulaDfaAnnotazioneNascita1) {
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			String sezione
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					sezione = 'Estremi atto di nascita Sposo'
					break
				case ETipoAtto.UCI:
					sezione = 'Estremi atto di nascita Contraente 1'
					break
				case ETipoAtto.MOR:
					sezione = 'Estremi atto di nascita Deceduto/a'
					break
				case ETipoAtto.CIT:
					sezione = 'Estremi atto di nascita Intestatario'
					break
				default:
					sezione = 'Estremi atto nascita'
					break
			}
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: ad.ufficioAttoNascita1, anno: ad.annoAttoNascita1, atto: ad.attoAttoNascita1, parte: ad.parteAttoNascita1, serie: ad.serieAttoNascita1, idAttoAnsc: ad.idAttoAnscNascita1)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
					estremiAtto,
					false,
					arcComuneBaseService.isComuneClienteAnnotazione(ad.codiceComuneAttoNascita1, ad.codiceProvinciaAttoNascita1))
			DatiValidazioneComune dvc = new DatiValidazioneComune(ad.codiceComuneAttoNascita1, ad.codiceProvinciaAttoNascita1, true)
			DatiValidazioneDataAtto dva = new DatiValidazioneDataAtto(null, false)
			DatiValidazioneAnnotazione dvan = new DatiValidazioneAnnotazione(dve, dvc, dva, formulaDfaAnnotazioneNascita1, false, true)
			try {
				ValidationUtils.validaDatiAnnotazione(dvan, sezione)
				return true
			} catch (ValidazioneEstremiAttoEmptyRuntimeException e) {
				log.error("Estremi atto nascita vuoti", e)
				return false
			}
		} else {
			Integer ufficio1 = ad.ufficioAttoNascita1
			Integer anno1 = ad.annoAttoNascita1
			Integer atto1 = ad.attoAttoNascita1
			Integer parte1 = ad.parteAttoNascita1
			String serie1 = ad.serieAttoNascita1
			Integer codiceComune1 = ad.codiceComuneAttoNascita1
			Integer codiceProvincia1 = ad.codiceProvinciaAttoNascita1
			String formulaDfa1 = formulaDfaAnnotazioneNascita1

			Boolean ufficioObbligatorio = arcComuneBaseService.isComuneClienteAnnotazione(codiceComune1, codiceProvincia1)

			if (((!(ufficioObbligatorio)) || (ufficio1 != null)) && //ufficio
					(anno1 != null) &&
					(atto1 != null) &&
					(parte1 != null) &&
					(parte1.intValue() == 1 || ((serie1?.trim() ?: "") != "")) && // condizione sulla serie
					(codiceComune1 != null) && (codiceProvincia1 != null) &&
					((formulaDfa1?.trim() ?: "") != "")) {
				log.info("Tutti i campi dell'atto di nascita del soggetto 1 sono stati indicati")
				return true
			}
			if ((ufficio1 == null) &&
					(anno1 == null) &&
					(atto1 == null) &&
					(parte1 == null) &&
					((serie1?.trim() ?: "") == "") &&
					(codiceComune1 == null) && (codiceProvincia1 == null) &&
					((formulaDfa1?.trim() ?: "") == "")) {
				log.info("Tutti i campi dell'atto di nascita del soggetto 1 sono vuoti")
				return false
			}
			//Errore bloccante se dati atto nascita parziali (per le annotazioni)
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposo"))
					break
				case ETipoAtto.UCI:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_1"))
					break
				case ETipoAtto.MOR:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_deceduto_a"))
					break
				case ETipoAtto.CIT:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_intestatario"))
					break
				default:
					throw new De4gsdzkRuntimeException("Estremi atto nascita soggetto 1 incompleti")
			}
			return false
		}
	}

	boolean validaDatiAttoNascitaSoggetto2(CivAttoBaseDomain obj, IEstremiAttoNascitaSoggetto2Domain ad, String formulaDfaAnnotazioneNascita2){
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			String sezione
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					sezione = 'Estremi atto di nascita Sposa'
					break
				case ETipoAtto.UCI:
					sezione = 'Estremi atto di nascita Contraente 2'
					break
				default:
					sezione = 'Estremi atto nascita Soggetto 2'
					break
			}
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: ad.ufficioAttoNascita2,
					anno: ad.annoAttoNascita2,
					atto: ad.attoAttoNascita2,
					parte: ad.parteAttoNascita2,
					serie: ad.serieAttoNascita2,
					idAttoAnsc: ad.idAttoAnscNascita2)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
					estremiAtto,
					false,
					arcComuneBaseService.isComuneClienteAnnotazione(ad.codiceComuneAttoNascita2, ad.codiceProvinciaAttoNascita2))
			DatiValidazioneComune dvc = new DatiValidazioneComune(ad.codiceComuneAttoNascita2, ad.codiceProvinciaAttoNascita2, true)
			DatiValidazioneDataAtto dva = new DatiValidazioneDataAtto(null, false)
			DatiValidazioneAnnotazione dvan = new DatiValidazioneAnnotazione(dve, dvc, dva, formulaDfaAnnotazioneNascita2, false, true)
			try {
				ValidationUtils.validaDatiAnnotazione(dvan, sezione)
				return true
			} catch (ValidazioneEstremiAttoEmptyRuntimeException e) {
				log.error("Estremi atto nascita vuoti", e)
				return false
			}
		} else {
			Integer ufficio2 = ad.ufficioAttoNascita2
			Integer anno2 = ad.annoAttoNascita2
			Integer atto2 = ad.attoAttoNascita2
			Integer parte2 = ad.parteAttoNascita2
			String serie2 = ad.serieAttoNascita2
			Integer codiceComune2 = ad.codiceComuneAttoNascita2
			Integer codiceProvincia2 = ad.codiceProvinciaAttoNascita2
			String formulaDfa2 = formulaDfaAnnotazioneNascita2

			Boolean ufficioObbligatorio = arcComuneBaseService.isComuneClienteAnnotazione(codiceComune2, codiceProvincia2)

			if (((!(ufficioObbligatorio)) || (ufficio2 != null)) && //ufficio
					(anno2 != null) &&
					(atto2 != null) &&
					(parte2 != null) &&
					(parte2.intValue() == 1 || ((serie2?.trim() ?: "") != "")) && // condizione sulla serie
					(codiceComune2 != null) && (codiceProvincia2 != null) &&
					((formulaDfa2?.trim() ?: "") != "")) {
				log.info("Tutti i campi dell'atto di nascita del soggetto 2 sono stati indicati")
				return true
			}
			if ((ufficio2 == null) &&
					(anno2 == null) &&
					(atto2 == null) &&
					(parte2 == null) &&
					((serie2?.trim() ?: "") == "") &&
					(codiceComune2 == null) && (codiceProvincia2 == null) &&
					((formulaDfa2?.trim() ?: "") == "")) {
				log.info("Tutti i campi dell'atto di nascita del soggetto 2 sono vuoti")
				return false
			}
			//Errore bloccante se dati atto nascita parziali (per le annotazioni)
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_sposa"))
					break
				case ETipoAtto.UCI:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_nascita_contraente_2"))
					break
				default:
					throw new De4gsdzkRuntimeException("Estremi atto nascita soggetto 2 incompleti")
			}
			return false
		}
	}

	boolean validaDatiAttoMatUci(CivAttoBaseDomain obj, IEstremiAttoMatrimonioDomain ad, String formulaDfaAnnotazioneMatrimonio){
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			String sezione
			ETipoAtto tipoAttoPrimario
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					tipoAttoPrimario = ETipoAtto.MAT
					sezione = 'Estremi atto di matrimonio'
					break
				case ETipoAtto.UCI:
					tipoAttoPrimario = ((IAttoMatUci) obj).divorzio ? ETipoAtto.UCI : ETipoAtto.MAT
					sezione = ((IAttoMatUci) obj).divorzio ? 'Estremi atto di unione civile' : 'Estremi atto di matrimonio'
					break
				default:
					tipoAttoPrimario = ETipoAtto.MAT
					sezione = 'Estremi atto matrimonio/unione civile'
					break
			}
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: ad.ufficioAttoMatrimonio,
					anno: ad.annoAttoMatrimonio,
					atto: ad.attoAttoMatrimonio,
					parte: ad.parteAttoMatrimonio,
					serie: ad.serieAttoMatrimonio,
					idAttoAnsc: ad.idAttoAnscMatrimonio)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(tipoAttoPrimario,
					estremiAtto,
					false,
					arcComuneBaseService.isComuneClienteAnnotazione(ad.codiceComuneAttoMatrimonio, ad.codiceProvinciaAttoMatrimonio))
			DatiValidazioneComune dvc = new DatiValidazioneComune(ad.codiceComuneAttoMatrimonio, ad.codiceProvinciaAttoMatrimonio, true)
			DatiValidazioneDataAtto dva = new DatiValidazioneDataAtto(null, false)
			DatiValidazioneAnnotazione dvan = new DatiValidazioneAnnotazione(dve, dvc, dva, formulaDfaAnnotazioneMatrimonio, false, true)
			try {
				ValidationUtils.validaDatiAnnotazione(dvan, sezione)
				return true
			} catch (ValidazioneEstremiAttoEmptyRuntimeException e) {
				log.error("Estremi atto nascita vuoti", e)
				return false
			}
		} else {
			Integer ufficioM = ad.ufficioAttoMatrimonio
			Integer annoM = ad.annoAttoMatrimonio
			Integer attoM = ad.attoAttoMatrimonio
			Integer parteM = ad.parteAttoMatrimonio
			String serieM = ad.serieAttoMatrimonio
			Integer codiceComuneM = ad.codiceComuneAttoMatrimonio
			Integer codiceProvinciaM = ad.codiceProvinciaAttoMatrimonio
			String formulaDfaM = formulaDfaAnnotazioneMatrimonio

			Boolean ufficioObbligatorio = arcComuneBaseService.isComuneClienteAnnotazione(codiceComuneM, codiceProvinciaM)

			if (((!(ufficioObbligatorio)) || (ufficioM != null)) && //ufficio
					(annoM != null) &&
					(attoM != null) &&
					(parteM != null) &&
					(codiceComuneM != null) && (codiceProvinciaM != null) &&
					((formulaDfaM?.trim() ?: "") != "") &&
					(obj.getTipoAttoEnum() == ETipoAtto.UCI) && obj.divorzio) {
				log.info("Tutti i campi dell'atto di unione civile sono stati indicati")
				return true
			}
			if (((!(ufficioObbligatorio)) || (ufficioM != null)) && //ufficio
					(annoM != null) &&
					(attoM != null) &&
					(parteM != null) &&
					(parteM.intValue() == 1 || ((serieM?.trim() ?: "") != "")) && // condizione sulla serie
					(codiceComuneM != null) && (codiceProvinciaM != null) &&
					((formulaDfaM?.trim() ?: "") != "")) {
				log.info("Tutti i campi dell'atto di matrimonio sono stati indicati")
				return true
			}
			if ((ufficioM == null) &&
					(annoM == null) &&
					(attoM == null) &&
					(parteM == null) &&
					((serieM?.trim() ?: "") == "") &&
					(codiceComuneM == null) && (codiceProvinciaM == null) &&
					((formulaDfaM?.trim() ?: "") == "")) {
				log.info("Tutti i campi dell'atto di matrimonio sono vuoti")
				return false
			}
			//Errore bloccante se dati atto di matrimonio parziali (per le annotazioni)
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_matrimonio"))
					break
				case ETipoAtto.UCI:
					if (((IAttoMatUci) obj).divorzio) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_unione_civile"))
					} else {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto_matrimonio"))
					}
					break
				default:
					throw new De4gsdzkRuntimeException("Estremi atto di matrimonio/unione civile incompleti")
			}
			return false
		}
	}

	void saveAnnotazioneSuAttoNascita1(CivAttoBaseDomain obj, IEstremiAttoNascitaSoggetto1Domain estremiAttoDomain, String idFormulaDfa, CivAnnotazioneTestoLibero atl,
									   ETipoSalvataggioAnnotazioneComuneCliente tipoSalvataggioAnnotazioneComuneCliente = null) {

		boolean val = validaDatiAttoNascitaSoggetto1(obj, estremiAttoDomain, idFormulaDfa)
		if (!val) {
			return
		}

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			// SOGGETTO 1
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita1
			Integer anno = estremiAttoDomain.annoAttoNascita1
			Integer atto = estremiAttoDomain.attoAttoNascita1
			Integer parte = estremiAttoDomain.parteAttoNascita1
			String serie = estremiAttoDomain.serieAttoNascita1
			Integer codiceComune = estremiAttoDomain.codiceComuneAttoNascita1
			Integer codiceProvincia = estremiAttoDomain.codiceProvinciaAttoNascita1
			String idAttoAnsc = estremiAttoDomain.idAttoAnscNascita1

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				// atto di nascita del comune utente
				Boolean esisteNas1 = Boolean.FALSE
				if (idAttoAnsc != null) {
					long n = civNascitaRepository.countByIdAttoAnsc(idAttoAnsc)
					esisteNas1 = (n == 1)
				} else if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
					long n = civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
					esisteNas1 = (n == 1)
				}
				if (esisteNas1) {
					saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoDomain, ann, obj)
				} else {
					switch (obj.getTipoAttoEnum()) {
						case ETipoAtto.MAT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_sposo_non_presente_in_archivio"))
							break
						case ETipoAtto.UCI:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_contraente_1_non_presente_in_archivio"))
							break
						case ETipoAtto.MOR:
							switch (tipoSalvataggioAnnotazioneComuneCliente) {
								case ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE:
									civNascitaService.createPregressoByEstremiAttoNascita1AndSoggetto1(estremiAttoDomain, obj as ISoggettoAtto1)
									saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoDomain, ann, obj)
									break
								case ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE:
									saveAnnotazioneSuAttoNascita1AltroComune(obj, ann)
									break
								default:
									throw new ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException()
							}
							break
						case ETipoAtto.CIT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_intestatario_non_presente_in_archivio"))
							break
						default:
							throw new De4gsdzkRuntimeException("Atto di nascita non presente in archivio")
					}
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoNascita1AltroComune(obj, ann)
			}
		} else {
			// SOGGETTO 1
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita1
			Integer anno = estremiAttoDomain.annoAttoNascita1
			Integer atto = estremiAttoDomain.attoAttoNascita1
			Integer parte = estremiAttoDomain.parteAttoNascita1
			String serie = estremiAttoDomain.serieAttoNascita1
			Integer codiceComune = estremiAttoDomain.codiceComuneAttoNascita1
			Integer codiceProvincia = estremiAttoDomain.codiceProvinciaAttoNascita1

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				// atto di nascita del comune utente
				Boolean esisteNas1 = Boolean.FALSE
				if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
					long n = civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
					esisteNas1 = (n == 1)
				}
				if (esisteNas1) {
					saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoDomain, ann, obj)
				} else {
					switch (obj.getTipoAttoEnum()) {
						case ETipoAtto.MAT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_sposo_non_presente_in_archivio"))
							break
						case ETipoAtto.UCI:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_contraente_1_non_presente_in_archivio"))
							break
						case ETipoAtto.MOR:
							switch (tipoSalvataggioAnnotazioneComuneCliente) {
								case ETipoSalvataggioAnnotazioneComuneCliente.CREA_ATTO_E_SALVA_COMUNE_CLIENTE:
									civNascitaService.createPregressoByEstremiAttoNascita1AndSoggetto1(estremiAttoDomain, obj as ISoggettoAtto1)
									saveAnnotazioneSuAttoNascita1ComuneCliente(estremiAttoDomain, ann, obj)
									break
								case ETipoSalvataggioAnnotazioneComuneCliente.NON_CREARE_ATTO_E_SALVA_ALTRO_COMUNE:
									saveAnnotazioneSuAttoNascita1AltroComune(obj, ann)
									break
								default:
									throw new ErroreAssenzaTipoSalvataggioAnnotazioneComuneClienteSuAttoNascita1RuntimeException()
							}
							break
						case ETipoAtto.CIT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_intestatario_non_presente_in_archivio"))
							break
						default:
							throw new De4gsdzkRuntimeException("Atto di nascita non presente in archivio")
					}
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoNascita1AltroComune(obj, ann)
			}
		}

	}

	private void validaSoggettoAttoPerAttoNascita1(ISoggettoAtto1 soggetto, CivNascita nascita) {
		if (nascita.dataNascita1 == null) {
			return
		}
		if (soggetto.dataNascita1 == nascita.dataNascita1) {
			return
		}
		throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_soggetto_non_compatibile"), "Atto di nascita: ${nascita.getEstremiAttoLista()}")
	}

	void saveAnnotazioneSuAttoNascita1ComuneCliente(IEstremiAttoNascitaSoggetto1Domain estremiAttoDomain, CivAnnotazioneAtto ann, CivAttoBaseDomain obj) {
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita1
			Integer anno = estremiAttoDomain.annoAttoNascita1
			Integer atto = estremiAttoDomain.attoAttoNascita1
			Integer parte = estremiAttoDomain.parteAttoNascita1
			String serie = estremiAttoDomain.serieAttoNascita1
			String idAttoAnsc = estremiAttoDomain.idAttoAnscNascita1

			CivNascita nas
			if (idAttoAnsc != null) {
				nas = civNascitaRepository.findByIdAttoAnsc(idAttoAnsc)
			} else {
				nas = civNascitaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
			}
			validaSoggettoAttoPerAttoNascita1(obj as ISoggettoAtto1, nas)
			ann.sequenza = getMaxSequenzaByUkAtto(nas.idAtto)
			DomainUtils.initFromAtto(ann, nas)

			save(ETipoOperazione.INS, ann, nas, obj)
		} else {
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita1
			Integer anno = estremiAttoDomain.annoAttoNascita1
			Integer atto = estremiAttoDomain.attoAttoNascita1
			Integer parte = estremiAttoDomain.parteAttoNascita1
			String serie = estremiAttoDomain.serieAttoNascita1

			CivNascita nas = civNascitaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
			validaSoggettoAttoPerAttoNascita1(obj as ISoggettoAtto1, nas)
			ann.sequenza = getMaxSequenzaByUkAtto(nas.idAtto)
			DomainUtils.initFromAtto(ann, nas)

			save(ETipoOperazione.INS, ann, nas, obj)
		}
	}

	void saveAnnotazioneSuAttoNascita1AltroComune(CivAttoBaseDomain obj, CivAnnotazioneAtto ann) {
        String idAttoAnnotazione = obj.idAtto + "." + ETipoAtto.NAS.name().toLowerCase()
        ann.sequenza = getMaxSequenzaByUkAtto(idAttoAnnotazione)
        DomainUtils.initFromAtto(ann, obj)
        DomainUtils.cambiaTipoAttoAnnotazioneSuAttoNascita(ann, obj)
        save(ETipoOperazione.INS, ann, obj)
	}

	void saveAnnotazioneSuAttoNascita2(CivAttoBaseDomain obj, IEstremiAttoNascitaSoggetto2Domain estremiAttoDomain, String idFormulaDfa, CivAnnotazioneTestoLibero atl){

		boolean val = validaDatiAttoNascitaSoggetto2(obj, estremiAttoDomain, idFormulaDfa)
		if (!val){
			return
		}

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			// SOGGETTO 2
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita2
			Integer anno = estremiAttoDomain.annoAttoNascita2
			Integer atto = estremiAttoDomain.attoAttoNascita2
			Integer parte = estremiAttoDomain.parteAttoNascita2
			String serie = estremiAttoDomain.serieAttoNascita2
			Integer codiceComune = estremiAttoDomain.codiceComuneAttoNascita2
			Integer codiceProvincia = estremiAttoDomain.codiceProvinciaAttoNascita2
			String idAttoAnsc = estremiAttoDomain.idAttoAnscNascita2

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				// atto di nascita del comune utente
				Boolean esisteNas2 = Boolean.FALSE
				if (idAttoAnsc != null) {
					long n = civNascitaRepository.countByIdAttoAnsc(idAttoAnsc)
					esisteNas2 = (n == 1)
				} else if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
					long n = civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
					esisteNas2 = (n == 1)
				}
				if (esisteNas2) {
					saveAnnotazioneSuAttoNascita2ComuneCliente(estremiAttoDomain, ann, obj)
				} else {
					switch (obj.getTipoAttoEnum()) {
						case ETipoAtto.MAT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_sposa_non_presente_in_archivio"))
							break
						case ETipoAtto.UCI:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_contraente_2_non_presente_in_archivio"))
							break
						default:
							throw new De4gsdzkRuntimeException("Atto di nascita non presente in archivio")
					}
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoNascita2AltroComune(obj, ann, formulaDfa)
			}
		} else {
			// SOGGETTO 2
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita2
			Integer anno = estremiAttoDomain.annoAttoNascita2
			Integer atto = estremiAttoDomain.attoAttoNascita2
			Integer parte = estremiAttoDomain.parteAttoNascita2
			String serie = estremiAttoDomain.serieAttoNascita2
			Integer codiceComune = estremiAttoDomain.codiceComuneAttoNascita2
			Integer codiceProvincia = estremiAttoDomain.codiceProvinciaAttoNascita2

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				// atto di nascita del comune utente
				Boolean esisteNas2 = Boolean.FALSE
				if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
					long n = civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
					esisteNas2 = (n == 1)
				}
				if (esisteNas2) {
					saveAnnotazioneSuAttoNascita2ComuneCliente(estremiAttoDomain, ann, obj)
				} else {
					switch (obj.getTipoAttoEnum()) {
						case ETipoAtto.MAT:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_sposa_non_presente_in_archivio"))
							break
						case ETipoAtto.UCI:
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_contraente_2_non_presente_in_archivio"))
							break
						default:
							throw new De4gsdzkRuntimeException("Atto di nascita non presente in archivio")
					}
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoNascita2AltroComune(obj, ann, formulaDfa)
			}
		}
	}

	private void validaSoggettoAttoPerAttoNascita2(ISoggettoAtto2 soggetto, CivNascita nascita) {
		if (nascita.dataNascita1 == null) {
			return
		}
		if (soggetto.dataNascita2 == nascita.dataNascita1) {
			return
		}
		throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_nascita_soggetto_non_compatibile"), "Atto di nascita: ${nascita.getEstremiAttoLista()}")
	}

	void saveAnnotazioneSuAttoNascita2ComuneCliente(IEstremiAttoNascitaSoggetto2Domain estremiAttoDomain, CivAnnotazioneAtto ann, CivAttoBaseDomain obj) {
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita2
			Integer anno = estremiAttoDomain.annoAttoNascita2
			Integer atto = estremiAttoDomain.attoAttoNascita2
			Integer parte = estremiAttoDomain.parteAttoNascita2
			String serie = estremiAttoDomain.serieAttoNascita2
			String idAttoAnsc = estremiAttoDomain.idAttoAnscNascita2

			CivNascita nas
			if (idAttoAnsc != null) {
				nas = civNascitaRepository.findByIdAttoAnsc(idAttoAnsc)
			} else {
				nas = civNascitaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
			}
			validaSoggettoAttoPerAttoNascita2(obj as ISoggettoAtto2, nas)
			ann.sequenza = getMaxSequenzaByUkAtto(nas.idAtto)
			DomainUtils.initFromAtto(ann, nas)

			save(ETipoOperazione.INS, ann, nas, obj)
		} else {
			Integer ufficio = estremiAttoDomain.ufficioAttoNascita2
			Integer anno = estremiAttoDomain.annoAttoNascita2
			Integer atto = estremiAttoDomain.attoAttoNascita2
			Integer parte = estremiAttoDomain.parteAttoNascita2
			String serie = estremiAttoDomain.serieAttoNascita2

			CivNascita nas = civNascitaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
			validaSoggettoAttoPerAttoNascita2(obj as ISoggettoAtto2, nas)
			ann.sequenza = getMaxSequenzaByUkAtto(nas.idAtto)
			DomainUtils.initFromAtto(ann, nas)

			save(ETipoOperazione.INS, ann, nas, obj)
		}
	}

	void saveAnnotazioneSuAttoNascita2AltroComune(CivAttoBaseDomain obj, CivAnnotazioneAtto ann, CivFormulaAnnotazione formulaDfa) {
        String idAttoAnnotazione = obj.idAtto + "." + ETipoAtto.NAS.name().toLowerCase()
        ann.sequenza = getMaxSequenzaByUkAtto(idAttoAnnotazione)
        DomainUtils.initFromAtto(ann, obj)
        DomainUtils.cambiaTipoAttoAnnotazioneSuAttoNascita(ann, obj)
        DomainUtils.cambiaFormulaAnnotazione(ann, formulaDfa?.id, CivAnnotazioneAtto.tipo_formula_5)
        save(ETipoOperazione.INS, ann, obj)
	}

	void saveAnnotazioneSuAttoMatrimonio(CivAttoBaseDomain obj, IEstremiAttoMatrimonioDomain estremiAttoDomain, String idFormulaDfa, CivAnnotazioneTestoLibero atl){
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			boolean val = validaDatiAttoMatUci(obj, estremiAttoDomain, idFormulaDfa)
			if (!val) {
				return
			}

			Integer ufficio = estremiAttoDomain.getUfficioAttoMatrimonio()
			Integer anno = estremiAttoDomain.getAnnoAttoMatrimonio()
			Integer atto = estremiAttoDomain.getAttoAttoMatrimonio()
			Integer parte = estremiAttoDomain.getParteAttoMatrimonio()
			String serie = estremiAttoDomain.getSerieAttoMatrimonio()
			String idAttoAnsc = estremiAttoDomain.idAttoAnscMatrimonio
			Integer codiceComune = estremiAttoDomain.getCodiceComuneAttoMatrimonio()
			Integer codiceProvincia = estremiAttoDomain.getCodiceProvinciaAttoMatrimonio()

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				Boolean esisteAtto = Boolean.FALSE
				if (idAttoAnsc != null) {
					if (obj.tipoAttoEnum == ETipoAtto.MAT) {
						esisteAtto = civMatrimonioRepository.countByIdAttoAnsc(idAttoAnsc) == 1
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && (((IAttoMatUci) obj).divorzio)) {
						esisteAtto = civUnioneCivileRepository.countByIdAttoAnsc(idAttoAnsc) == 1
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && !(((IAttoMatUci) obj).divorzio)) {
						esisteAtto = civMatrimonioRepository.countByIdAttoAnsc(idAttoAnsc) == 1
					}
				} else if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
					if (obj.tipoAttoEnum == ETipoAtto.MAT) {
						esisteAtto = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie) == 1
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && (((IAttoMatUci) obj).divorzio)) {
						esisteAtto = civUnioneCivileRepository.countByUfficioAndAnnoAndAttoAndParteAndSerieIsNull(ufficio, anno, atto, parte) == 1
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && !(((IAttoMatUci) obj).divorzio)) {
						esisteAtto = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie) == 1
					}
				}
				if (esisteAtto) {
					saveAnnotazioneSuAttoMatUciComuneCliente(estremiAttoDomain, ann, obj)
				} else {
					if (obj.tipoAttoEnum == ETipoAtto.MAT) {
						throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_matrimonio_non_presente_in_archivio"))
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && (((IAttoMatUci) obj).divorzio)) {
						throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_unione_civile_non_presente_in_archivio"))
					} else if (obj.tipoAttoEnum == ETipoAtto.UCI && !(((IAttoMatUci) obj).divorzio)) {
						throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_matrimonio_non_presente_in_archivio"))
					} else {
						throw new De4gsdzkRuntimeException("Atto di matrimonio/unione civile non presente in archivio")
					}
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoMatUciAltroComune(obj, ann)
			}
		} else {
			boolean val = validaDatiAttoMatUci(obj, estremiAttoDomain, idFormulaDfa)
			if (!val) {
				return
			}

			Integer ufficio = estremiAttoDomain.getUfficioAttoMatrimonio()
			Integer anno = estremiAttoDomain.getAnnoAttoMatrimonio()
			Integer atto = estremiAttoDomain.getAttoAttoMatrimonio()
			Integer parte = estremiAttoDomain.getParteAttoMatrimonio()
			String serie = estremiAttoDomain.getSerieAttoMatrimonio()
			Integer codiceComune = estremiAttoDomain.getCodiceComuneAttoMatrimonio()
			Integer codiceProvincia = estremiAttoDomain.getCodiceProvinciaAttoMatrimonio()

			CivFormulaAnnotazione formulaDfa = civFormulaAnnotazioneService.get(idFormulaDfa)

			CivAnnotazioneAtto ann = create(EStatoAnnotazione.E)
			ann.formulaDfa = formulaDfa
			ann.formula = ann.formulaDfa?.id
			ann.testo = atl.testo

			if (arcComuneBaseService.isComuneClienteAnnotazione(codiceComune, codiceProvincia)) {
				switch (obj.getTipoAttoEnum()) {
					case ETipoAtto.MAT:
						Boolean esisteMat = Boolean.FALSE
						if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
							long n = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
							esisteMat = (n == 1)
						}
						if (esisteMat) {
							saveAnnotazioneSuAttoMatUciComuneCliente(estremiAttoDomain, ann, obj)
						} else {
							throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_matrimonio_non_presente_in_archivio"))
						}
						break
					case ETipoAtto.UCI:
						if (((IAttoMatUci) obj).divorzio) {
							Boolean esisteUci = Boolean.FALSE
							if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
								long n = civUnioneCivileRepository.countByUfficioAndAnnoAndAttoAndParteAndSerieIsNull(ufficio, anno, atto, parte)
								esisteUci = (n == 1)
							}
							if (esisteUci) {
								saveAnnotazioneSuAttoMatUciComuneCliente(estremiAttoDomain, ann, obj)
							} else {
								throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_unione_civile_non_presente_in_archivio"))
							}
						} else {
							// Caso UCN
							Boolean esisteUcn = Boolean.FALSE
							if ((ufficio != null) && (anno != null) && (atto != null) && (parte != null)) {
								long n = civMatrimonioRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
								esisteUcn = (n == 1)
							}
							if (esisteUcn) {
								saveAnnotazioneSuAttoMatUciComuneCliente(estremiAttoDomain, ann, obj)
							} else {
								throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_atto_matrimonio_non_presente_in_archivio"))
							}
						}
						break
					default:
						throw new De4gsdzkRuntimeException("Atto di matrimonio/unione civile non presente in archivio")
				}
			} else {
				// atto di altro comune
				saveAnnotazioneSuAttoMatUciAltroComune(obj, ann)
			}
		}
	}

	void saveAnnotazioneSuAttoMatUciComuneCliente(IEstremiAttoMatrimonioDomain estremiAttoDomain, CivAnnotazioneAtto ann, CivAttoBaseDomain obj) {
		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			Integer ufficio = estremiAttoDomain.ufficioAttoMatrimonio
			Integer anno = estremiAttoDomain.annoAttoMatrimonio
			Integer atto = estremiAttoDomain.attoAttoMatrimonio
			Integer parte = estremiAttoDomain.parteAttoMatrimonio
			String serie = estremiAttoDomain.serieAttoMatrimonio
			String idAttoAnsc = estremiAttoDomain.idAttoAnscMatrimonio

			// atto di matrimonio/uci del comune utente
			CivAttoBaseDomain dAtto
			if (idAttoAnsc != null) {
				if (obj.tipoAttoEnum == ETipoAtto.MAT) {
					dAtto = civMatrimonioRepository.findByIdAttoAnsc(idAttoAnsc)
				} else if (obj.tipoAttoEnum == ETipoAtto.UCI && (((IAttoMatUci) obj).divorzio)) {
					dAtto = civUnioneCivileRepository.findByIdAttoAnsc(idAttoAnsc)
				} else if (obj.tipoAttoEnum == ETipoAtto.UCI && !(((IAttoMatUci) obj).divorzio)) {
					dAtto = civMatrimonioRepository.findByIdAttoAnsc(idAttoAnsc)
				} else {
					throw new De4gsdzkRuntimeException("Atto Matrimonio/Uci non presente in archivio")
				}
			} else {
				if (obj.tipoAttoEnum == ETipoAtto.MAT) {
					dAtto = civMatrimonioRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
				} else if (obj.tipoAttoEnum == ETipoAtto.UCI && (((IAttoMatUci) obj).divorzio)) {
					dAtto = civUnioneCivileRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
				} else if (obj.tipoAttoEnum == ETipoAtto.UCI && !(((IAttoMatUci) obj).divorzio)) {
					dAtto = civMatrimonioRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
				} else {
					throw new De4gsdzkRuntimeException("Atto Matrimonio/Uci non presente in archivio")
				}
			}

			ann.sequenza = getMaxSequenzaByUkAtto(dAtto.idAtto)
			DomainUtils.initFromAtto(ann, dAtto)

			save(ETipoOperazione.INS, ann, dAtto, obj)
		} else {
			Integer ufficio = estremiAttoDomain.ufficioAttoMatrimonio
			Integer anno = estremiAttoDomain.annoAttoMatrimonio
			Integer atto = estremiAttoDomain.attoAttoMatrimonio
			Integer parte = estremiAttoDomain.parteAttoMatrimonio
			String serie = estremiAttoDomain.serieAttoMatrimonio

			// atto di matrimonio/uci del comune utente
			CivAttoBaseDomain dAtto
			switch (obj.getTipoAttoEnum()) {
				case ETipoAtto.MAT:
					dAtto = civMatrimonioRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
					break
				case ETipoAtto.UCI:
					if (((IAttoMatUci) obj).divorzio) {
						dAtto = civUnioneCivileRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
					} else {
						dAtto = civMatrimonioRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
					}
					break
				default:
					throw new De4gsdzkRuntimeException("Atto di matrimonio/unione civile non presente in archivio")
			}

			ann.sequenza = getMaxSequenzaByUkAtto(dAtto.idAtto)
			DomainUtils.initFromAtto(ann, dAtto)

			save(ETipoOperazione.INS, ann, dAtto, obj)
		}
	}

	void saveAnnotazioneSuAttoMatUciAltroComune(CivAttoBaseDomain obj, CivAnnotazioneAtto ann) {
        String idAttoAnnotazione = obj.idAtto + "." + obj.getTipoAttoEnum().name().toLowerCase()
        ann.sequenza = getMaxSequenzaByUkAtto(idAttoAnnotazione)
        DomainUtils.initFromAtto(ann, obj)
        DomainUtils.cambiaTipoAttoAnnotazioneSuAttoMatrimonio(ann, obj)
        save(ETipoOperazione.INS, ann, obj)
	}

	String getTestoAnnotazioneSuAttoNascitaSoggetto1(CivAttoBaseDomain atto, IEstremiAttoNascitaSoggetto1Domain estremiAttoDomain, CivDatiProvenienzaAtto datiProvenienza){
		String idFormulaDfa = datiProvenienza.formulaDfaAnnotazioneNascita1

		boolean val = validaDatiAttoNascitaSoggetto1(atto, estremiAttoDomain, idFormulaDfa)
		if (val) {
			String testo = gsdService.decodificaTestoAnnotazione(ETipoAtto.NAS.valore, idFormulaDfa, atto, datiProvenienza, 1)
			return testo
		}
		return ""
	}

	String getTestoAnnotazioneSuAttoNascitaSoggetto2(CivAttoBaseDomain atto, IEstremiAttoNascitaSoggetto2Domain estremiAttoDomain, CivDatiProvenienzaAtto datiProvenienza){
		String idFormulaDfa = datiProvenienza.formulaDfaAnnotazioneNascita2

		boolean val = validaDatiAttoNascitaSoggetto2(atto, estremiAttoDomain, idFormulaDfa)
		if (val){
			String testo = gsdService.decodificaTestoAnnotazione(ETipoAtto.NAS.valore, idFormulaDfa, atto, datiProvenienza, 2)
			return testo
		}
		return ""
	}

	String getTestoAnnotazioneSuAttoMatrimonio(IAttoMatUci atto, IEstremiAttoMatrimonioDomain estremiAttoDomain, CivDatiProvenienzaAtto datiProvenienza){
		String idFormulaDfa = datiProvenienza.formulaDfaAnnotazioneMatrimonio

		boolean val = validaDatiAttoMatUci(atto, estremiAttoDomain, idFormulaDfa)
		if (val){
			int tipoAttoTarget = ETipoAtto.MAT.valore
			if (atto.divorzio && (atto instanceof CivUnioneCivile)){
				tipoAttoTarget = ETipoAtto.UCI.valore
			}
			String testo = gsdService.decodificaTestoAnnotazione(tipoAttoTarget, idFormulaDfa, atto, datiProvenienza, 1)
			return testo
		}
		return ""
	}

	CivAnnotazioneAtto save (ETipoOperazione tipoOperazione, CivAnnotazioneAtto obj, CivAttoBaseDomain atto, CivAttoBaseDomain attoRif=null){
		validaDati(tipoOperazione, obj, atto)

		List<CivArchivioComunicazione> listaComunicazioniAtto = []
		if (tipoOperazione.isInsert()){
			// solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
			String identificativoAttoRif
			// devo ricalcolare perché se numero e consolido nella stessa transazione, il valore del campo id_atto dell'atto di riferimento cambia
			if (attoRif){
				identificativoAttoRif = gsdService.getIdentificativoAtto(attoRif.tipoAtto, attoRif.ufficio, attoRif.anno, attoRif.parte, attoRif.serie, attoRif.atto)
			} else {
				identificativoAttoRif = gsdService.getIdentificativoAtto(atto.tipoAtto, atto.ufficio, atto.anno, atto.parte, atto.serie, atto.atto)
			}
			obj.idAttoRif = identificativoAttoRif

			// Poiché sono in inserimento, idAtto potrebbe non essere stato generato dal trigger
			// sicché mi tocca recuperarlo tramite chiamata ad apposita function di db
			String identificativoAtto = (atto.idAtto?:gsdService.getIdentificativoAtto(atto.tipoAtto, atto.ufficio, atto.anno, atto.parte, atto.serie, atto.atto))
			CivAnagrafe anagrafe = civAnagrafeService.getByUkAttoAndTipoAtto(identificativoAtto, atto.tipoAtto)
			List<CivComunicazioneFormula> listaComunicazioniDefault = civComunicazioneFormulaService.listAllDefaultComunicazioni(obj.formulaDfa.id, atto, anagrafe)
			for (CivComunicazioneFormula c:listaComunicazioniDefault){
				CivArchivioComunicazione ac = civArchivioComunicazioneService.create()
				ac.comunicazione = c.comunicazione
				ac.numeroCopie = c.numeroCopie
				ac.sequenza = obj.sequenza
				ac.dataRegistrazione = obj.dataRegistrazione
				ac.formulaDfa = obj.formulaDfa
				ac.formula = obj.formula
				ac.annotazioneAtto = obj
				DomainUtils.initFromAtto(ac, atto)
				//Forzo con il tipo_atto dell'annotazione perché le annotazioni associate ad atti di altro comune
				//hanno un tipo_atto diverso da quello dell'atto di origine (es. per i matrimoni 7 anziché 4, per i decessi 8 anziché 5)
				ac.tipoAtto = obj.tipoAtto
				ac.tipoAttoRif = atto.tipoAtto
				//Serve per il recupero delle comunicazioni generate dallo stesso tipo di atto su uno stesso atto
				//(esempio annotazioni su atto di nascita di sposo/sposa in caso di seconde nozze)
				ac.idAttoRif = identificativoAttoRif
				listaComunicazioniAtto.add(ac)
			}
		}
		if (tipoOperazione.isUpdate()){
			// Svuoto per non lasciare dati sporchi
			if ( obj.id && (!(obj.isProvenienzaEnte())) ) {
				obj.estremiDocumentoProvenienza = ""
				obj.dataProvenienza = null

				obj.comuneProvenienza.codice = null
				obj.comuneProvenienza.descrizione = null
				obj.comuneProvenienza.codiceProvincia = null
				obj.comuneProvenienza.siglaProvincia = null
			}
		}

		obj.testo = gsdValidazioneTestoService.bonificaTesto(obj.testo)

		log.info("Lancio salvataggio su CIVANN per id " + obj.id)
		CivAnnotazioneAtto aa = civAnnotazioneAttoRepository.save(obj)

		for (CivArchivioComunicazione ac: listaComunicazioniAtto){
			log.info("Salvo comunicazione per annotazione con id: " + obj.id)
			civArchivioComunicazioneService.save(ac)
		}

		return aa
	}

	void delete(CivAnnotazioneAtto obj){
		if (obj.id != null) {

			if (isInviatoAnsc(obj.id)){
				throw new AnscRuntimeException(Etichette.getEtichetta("Errore_ANSC_cancellazione_entita"))
			}

			List<CivArchivioComunicazione> lCom = civArchivioComunicazioneService.listAllComunicazioniDaAnnotazioneByAnnotazione(obj)
			for (CivArchivioComunicazione arcCom: lCom) {
				civComunicazioneAllegatoService.deleteComunicazioneEAllegati(arcCom)
			}

			log.info("Tento cancellazione su CIVANN per id " + obj.id)
			civAnnotazioneAttoRepository.delete(obj)
		}
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civAnnotazioneAttoRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civAnnotazioneAttoRepository.updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateAnnoAnnotazioneAndNumeroUnico(Long id, Integer annoAnnotazione, Long numeroUnico) {
        civAnnotazioneAttoRepository.updateAnnoAnnotazioneAndNumeroUnico(id, annoAnnotazione, numeroUnico)
    }

	void updateStampaEstrattoSuListaAnnotazioni(List<CivAnnotazioneAtto> list) {
		list.each{
			civAnnotazioneAttoRepository.updateStampaSuEstratto(it.id, DomainUtils.convertStampaSuEstrattoToStampaSuEstrattoDb(it.stampaSuEstratto))
		}
	}

}
