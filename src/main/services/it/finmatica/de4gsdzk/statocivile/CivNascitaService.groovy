package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.EFascia
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivNascitaService implements IAttoCertificabileService {

	private final GsdService gsdService

	private final CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivAnagrafeService civAnagrafeService

	private final CivMargineService civMargineService

	private final CivTipoAttoService civTipoAttoService

	private final ArcComuneBaseService arcComuneBaseService

	private final CivComunicazioneAttoService civComunicazioneAttoService

	private final CivValidazioneAttoService civValidazioneAttoService

	private final CivSoggettoCollegatoService civSoggettoCollegatoService

	private final ArcParametroService arcParametroService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final CivNascitaRepository civNascitaRepository

    CivNascitaService(CivNascitaRepository civNascitaRepository, GsdService gsdService,
                      CivDatiProvenienzaAttoService civDatiProvenienzaAttoService, CivFormulaTestoLiberoService civFormulaTestoLiberoService,
                      CivAnagrafeService civAnagrafeService, CivMargineService civMargineService, CivTipoAttoService civTipoAttoService,
                      ArcComuneBaseService arcComuneBaseService, CivComunicazioneAttoService civComunicazioneAttoService,
                      ArcParametroService arcParametroService, CivSoggettoCollegatoService civSoggettoCollegatoService,
                      CivValidazioneAttoService civValidazioneAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civNascitaRepository = civNascitaRepository
		this.gsdService = gsdService
		this.civDatiProvenienzaAttoService = civDatiProvenienzaAttoService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civAnagrafeService = civAnagrafeService
		this.civMargineService = civMargineService
		this.civTipoAttoService = civTipoAttoService
		this.arcComuneBaseService = arcComuneBaseService
		this.civComunicazioneAttoService = civComunicazioneAttoService
		this.arcParametroService = arcParametroService
		this.civSoggettoCollegatoService = civSoggettoCollegatoService
		this.civValidazioneAttoService = civValidazioneAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
	}

	Integer getCodiceRecord(Long id) {
		return civNascitaRepository.findCodiceRecord(id)
	}

	Boolean getBloccato(Long id) {
		return civNascitaRepository.findBloccato(id)
	}

	ETipoSiNo getCertificabile(Long id) {
		return civNascitaRepository.findCertificabile(id)
	}

    Boolean isInviatoAnsc(Long id) {
        String idAttoAnsc = civNascitaRepository.findIdAttoAnsc(id)
        return (!(TestoUtils.isVuoto(idAttoAnsc)))
    }

	Boolean isFirmatoUscAnsc(Long id) {
		return civNascitaRepository.findFirmatoUscAnsc(id)
	}

	Boolean isFirmatoCartaceoAnsc(Long id) {
		return (civNascitaRepository.findFirmatoCartaceoAnsc(id) > 0)
	}

	Boolean isConformeAnsc(Long id) {
		return (civNascitaRepository.findConformeAnsc(id, ETipoArchivioAnsc.NAS) > 0)
	}

	Boolean existsIdAttoAnsc(String idAttoAnsc) {
		return list([idAttoAnsc: idAttoAnsc]).size() > 0
	}

	Boolean hasAllegatiInviatiAnsc(Long id) {
		return (civNascitaRepository.hasAllegatiInviatiAnsc(id) > 0)
	}

	Boolean shouldInheritCognome(CivNascita atto) {
		return arcParametroService.isGestioneCognomeAutomaticoAttiva() && !atto.isAdozione() && atto.isCodRec3()
	}

	Boolean shouldInheritNazionalita(CivNascita atto) {
		return !atto.isAdozione()
	}

	Boolean shouldInheritResidenza(CivNascita atto) {
		return !atto.isAdozione()
	}

	Boolean shouldWarnIfResidenzaDiversaMadreComuneUtente(CivNascita atto) {
		if (atto.isAdozione()) {
			return Boolean.FALSE
		}
		if (ComuneUtils.stessiCodici(atto.codiceComuneResidenza, atto.codiceProvinciaResidenza, atto.codiceComuneResidenzaMadre, atto.codiceProvinciaResidenzaMadre)) {
			ArcComune c = gsdService.getComuneCliente()
			if (!(ComuneUtils.stessiCodici(atto.codiceComuneResidenza, atto.codiceProvinciaResidenza, c))) {
				return Boolean.TRUE
			}
		}
		return Boolean.FALSE
	}

	CivNascita get (Long id, Map params){
		return civNascitaRepository.getByParams(id, params)
	}

	CivNascita getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
		return civNascitaRepository.findByUkAtto(ufficio, anno, atto, parte, serie)
	}

	@Override
	CivNascita getByIdAttoAnsc(String idAttoAnsc) {
		return civNascitaRepository.findByIdAttoAnsc(idAttoAnsc)
	}

	Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie){
		// La serie può essere nulla
		if ( (ufficio != null) && (anno != null) && (atto != null) && (parte != null) ) {
			long n = civNascitaRepository.countByUfficioAndAnnoAndAttoAndParteAndSerie(ufficio, anno, atto, parte, serie)
			return (n == 1)
		}
		return  Boolean.FALSE
	}

	CivNascita getXDatiAnagraficiSoggetto1(ISoggettoAtto1 atto){
		return getXDatiAnagrafici(atto.getCognome1(), atto.getNome1(), atto.getDataNascita1(), atto.getSesso1())
	}

	CivNascita getXDatiAnagraficiSoggetto2(ISoggettoAtto2 atto){
		return getXDatiAnagrafici(atto.getCognome2(), atto.getNome2(), atto.getDataNascita2(), atto.getSesso2())
	}

	CivNascita getXDatiAnagrafici(String cognome, String nome, Date dataNascita, ESesso sesso){
		if (dataNascita && sesso && cognome?.trim() && nome?.trim() ){
			//Poiché tutti i parametri sono valorizzati posso usare i dynamic finders
			List<CivNascita> l = civNascitaRepository.findAllByCognomeAndNomeAndDataNascitaAndSessoAndNatura(cognome, nome, dataNascita, sesso, ENaturaAtto.O)
			if (l.size() == 1){
				return l.get(0)
			}
		}
		return null
	}

	List<CivNascita> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
		List<Long> ids = statoCivileFiltroList.collect { it.id }
		return civNascitaRepository.findAllByIdIn(ids)
	}

	Page<CivNascita> list (Map params) {
		return civNascitaRepository.listByParams(params)
	}

	void updateIdAnscUseCase(Long id, Long idAnscUseCase){
		civNascitaRepository.updateIdAnscUseCase(id, idAnscUseCase)
	}

	void updateIdAttoAnsc(Long id, String idAttoAnsc) {
		civNascitaRepository.updateIdAttoAnsc(id, idAttoAnsc)
	}

	void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc){
		civNascitaRepository.updateMotivoRecuperoAnsc(id, motivoRecuperoAnsc)
	}

	void createPregressoByEstremiAttoNascita1AndSoggetto1(IEstremiAttoNascitaSoggetto1Domain estremi, ISoggettoAtto1 soggettoAtto1) {
		CivNascita attoNascita = new CivNascita(partoPlurimo: Boolean.FALSE, natoMorto: EStatoNascita.Nato_vivo, codiceRecord: new Integer(0))
		attoNascita.ufficio = estremi.ufficioAttoNascita1
		attoNascita.atto = estremi.attoAttoNascita1
		attoNascita.anno = estremi.annoAttoNascita1

		CivTipoAtto tipoAtto = civTipoAttoService.getPregressoOriginaleByTipoAttoAndParteAndSerie(new Integer(ETipoAtto.NAS.valore), estremi.parteAttoNascita1, estremi.serieAttoNascita1)
		if (tipoAtto == null) {
			throw new De4gsdzkRuntimeException("Tipo di Atto non trovato per estremi nascita")
		}
		attoNascita.tipoAttoDomain = tipoAtto
		attoNascita.parte = tipoAtto?.parte
		attoNascita.serie = tipoAtto?.serie
		attoNascita.natura = tipoAtto?.natura

		attoNascita.cognome1 = soggettoAtto1.cognome1
		attoNascita.nome1 = soggettoAtto1.nome1
		attoNascita.senzaCognome1 = soggettoAtto1.senzaCognome1
		attoNascita.senzaNome1 = soggettoAtto1.senzaNome1
		attoNascita.sesso1 = soggettoAtto1.sesso1
		attoNascita.dataNascita = soggettoAtto1.dataNascita1
		attoNascita.codiceComuneNascita = soggettoAtto1.codiceComuneNascita1
		attoNascita.codiceProvinciaNascita = soggettoAtto1.codiceProvinciaNascita1
		attoNascita.descrizioneComuneNascita = soggettoAtto1.descrizioneComuneNascita1
		attoNascita.siglaProvinciaNascita = soggettoAtto1.siglaProvinciaNascita1

		CivMargine margineNascita = new CivMargine()
		CivDatiProvenienzaAtto datiProvenienzaNascita = new CivDatiProvenienzaAtto()
		Boolean ignoreCheckResidenza1 = Boolean.TRUE
		CivNascita attoNascitaPregresso = save(ETipoOperazione.INS, attoNascita, null, datiProvenienzaNascita, margineNascita, [:], Boolean.FALSE, null, Boolean.FALSE, [], ignoreCheckResidenza1, false)
		if (attoNascitaPregresso == null) {
			throw new De4gsdzkRuntimeException("Atto nascita pregresso non creato")
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivNascita obj, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine, Boolean composizioneTestoAttiva, EGestioneConsolidamento gc, Boolean ignoreCheckResidenza1) {

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		civValidazioneAttoService.checkEstremiAtto(tipoOperazione, obj)

		if (obj.tipoAttoDomain?.categoriaDomain?.flagPregresso || obj.tipoAttoDomain?.flagPregresso){
			log.info("Sto salvando un pregresso: non occorre il controllo sulla serie")
		} else {
			if (obj.isCodRec3() && ( (obj.serie?:"") == "")){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
			}
		}

		civValidazioneAttoService.checkConsolidamentoProvvisorio(obj, gc)

		//Dipende da parte e serie, ma logicamente viene prima degli altri per la disposizione delle sezioni
		if ( (obj.tipoFiliazione == null) && composizioneTestoAttiva ) {
			if ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita() ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), "'Filiazione'")
			}
		}

		if (obj.isRiconoscimentoPrenatale() ){
            // refs #46581
			log.info("Riconoscimento prenatale: cognome, nome, sesso nascituro e comune di residenza non obbligatori")
		} else {
			Boolean checkResidenza1 = (ignoreCheckResidenza1 ? Boolean.FALSE : Boolean.TRUE) && !datiProvenienza.flagInViaggio
			// Solo per atti in inserimento e integrazione ANSC attiva
			Boolean checkComuneNascita = obj.isCodRec3() && anscOn && (obj.isComuneNascitaMandatory() || datiProvenienza.flagInViaggio)
			Boolean checkNazionalita = obj.isCodRec3() && anscOn && obj.isNazionalitaMandatory()
			Boolean checkDataNascita =  obj.isCodRec3() && anscOn && !obj.isRiconoscimentoPrenatale()
			String sezioneNato = "'Dati Nascita'"
			civValidazioneAttoService.checkDatiObbligatoriIncompletiSoggetto1(obj, sezioneNato, checkResidenza1, checkComuneNascita, checkDataNascita, checkNazionalita)
		}

		civValidazioneAttoService.checkCognomeNomeTroppoLunghiSoggetto1(obj, "Cognome/Nome nato")

		civValidazioneAttoService.checkCfTroppoLungoSoggetto1(obj, "Codice Fiscale nato")

		civValidazioneAttoService.checkTipoAttoAndParteAndSerieAndNatura(obj)

		//Controllo obbligatorietà dati genitori solo in caso di Adozione o se ho FlagInViaggio a true
		if (obj.isCodRec3() && anscOn && (obj.isAdozione() || datiProvenienza.flagInViaggio)) {
			if (obj.isPadreMandatory() || datiProvenienza.flagInViaggio) {
				civValidazioneAttoService.checkAnagraficaPadre(obj)
				if (obj.dataNascitaPadre == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_padre"))
				}
				if ((obj.comuneNascitaPadre.codice == null) || (obj.comuneNascitaPadre.codiceProvincia == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_padre"))
				}
				if ((obj.codiceComuneResidenzaPadre == null) || (obj.codiceProvinciaResidenzaPadre == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_padre"))
				}
				if ((obj.isNazionalitaPadreMadreMandatory() || datiProvenienza.flagInViaggio) && obj.nazionalitaPadre == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_padre"))
				}
			}
			if (obj.isMadreMandatory() || datiProvenienza.flagInViaggio) {
				civValidazioneAttoService.checkAnagraficaMadre(obj)
				if (obj.dataNascitaMadre == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_madre"))
				}
				if ((obj.comuneNascitaMadre.codice == null) || (obj.comuneNascitaMadre.codiceProvincia == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_madre"))
				}
				if ((obj.codiceComuneResidenzaMadre == null) || (obj.codiceProvinciaResidenzaMadre == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_madre"))
				}
				if ((obj.isNazionalitaPadreMadreMandatory() || datiProvenienza.flagInViaggio) && obj.nazionalitaMadre == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_madre"))
				}
			}
		}

		//Controllo dati per Adozione
		if (obj.isCodRec3() && anscOn && obj.isAdozione()) {

			String sezioneDatiAtto = "'Dati Nascita'"
			if ((obj.tipoRichiesta == null) || (obj.motivoNascita == null)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
			}
			if (obj.tipoRichiesta != obj.motivoNascita?.tipoRichiesta) {
				throw new AnscRuntimeException("Il motivo richiesta selezionato nella sezione $sezioneDatiAtto non risulta coerente con il tipo di richiesta indicato")
			}

			if(arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()){
				EstremiAtto estremiAtto = new EstremiAtto(ufficio: margine.ufficioAttoNascita1,
						atto: margine.attoAttoNascita1,
						anno: margine.annoAttoNascita1,
						parte: margine.parteAttoNascita1,
						serie: margine.serieAttoNascita1,
						idAttoAnsc: margine.idAttoAnscNascita1)
				DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
						estremiAtto,
						(obj.isAdozioneEstremiAttoNascitaMandatory() || obj.isRiconoscimentoPostNascita()),
						false)
				DatiValidazioneComune dvc = new DatiValidazioneComune(margine.codiceComuneAttoNascita1,
						margine.codiceProvinciaAttoNascita1,
						(obj.isAdozioneEstremiAttoNascitaMandatory() || obj.isRiconoscimentoPostNascita()))
				DatiValidazioneDataAtto dvd = new DatiValidazioneDataAtto(margine.dataAttoNascita,
						(obj.isAdozioneEstremiAttoNascitaMandatory() || obj.isRiconoscimentoPostNascita()))
				ValidationUtils.validaEstremiAtto(dve, sezioneDatiAtto)
				ValidationUtils.validaEstremiAttoComune(dvc, sezioneDatiAtto)
				ValidationUtils.validaEstremiAttoData(dvd, sezioneDatiAtto)
			} else {
				if ((obj.isAdozioneEstremiAttoNascitaMandatory() || obj.isRiconoscimentoPostNascita())) {
					if ((margine.codiceComuneAttoNascita1 == null) || (margine.descrizioneComuneAttoNascita1 == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
					}

					if (TestoUtils.isVuoto(margine.idAttoAnscNascita1)) {
						if ((margine.attoAttoNascita1 == null) || (margine.annoAttoNascita1 == null)) {
							throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
						}
					}

					if (margine.dataAttoNascita == null) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
					}
				}
			}

			if (obj.motivoNascita.flagAutorita) {
				String sezioneAutoritaMittente = "Redazione - Autorità mittente'"
				if (TestoUtils.isVuoto(datiProvenienza.autorita) || (datiProvenienza.comuneProvenienza.codice == null) || (datiProvenienza.comuneProvenienza.codiceProvincia == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAutoritaMittente)
				}
				if (obj.motivoNascita.flagAutoritaEstremi) {
					if (datiProvenienza.dataNotaRif == null || TestoUtils.isVuoto(datiProvenienza.notaRif)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAutoritaMittente)
					}
				}
			}

			String sezioneAttoDaTrascrivere = "'Redazione - Atto da trascrivere'"
			if (datiProvenienza.dataAttoEnteStraniero == null ||
					TestoUtils.isVuoto(datiProvenienza.estremiAttoEnteStraniero) ||
					TestoUtils.isVuoto(datiProvenienza.autoritaEnteStraniero) ||
					((datiProvenienza.comuneEnteStraniero.codice == null) || (datiProvenienza.comuneEnteStraniero.codiceProvincia == null))) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoDaTrascrivere)
			}

			String sezioneDatiDellaTrascrizione = "'Redazione - Dati della trascrizione'"
			if (datiProvenienza.dataRichiestaTrascrizione == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDellaTrascrizione)
			}
			if (obj.isTipoRichiestaTrascrizioneMandatory() && datiProvenienza.tipoRichiestaTrascrizione == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDellaTrascrizione)
			}
			if (obj.isCambioGeneralitaTrascrizioneMandatory() && TestoUtils.isVuoto(obj.nuovoCognome)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDellaTrascrizione)
			}
		}

		//Controllo Estremi atto per categoria RIC
		if(obj.isRiconoscimentoPostNascita()) {
			String sezioneDatiAtto = "'Dati Nascita'"
			if(arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()){
				EstremiAtto estremiAtto = new EstremiAtto(ufficio: margine.ufficioAttoNascita1,
						atto: margine.attoAttoNascita1,
						anno: margine.annoAttoNascita1,
						parte: margine.parteAttoNascita1,
						serie: margine.serieAttoNascita1,
						idAttoAnsc: margine.idAttoAnscNascita1)
				DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
						estremiAtto,
						true,
						false)
				DatiValidazioneComune dvc = new DatiValidazioneComune(margine.codiceComuneAttoNascita1,
						margine.codiceProvinciaAttoNascita1,
						true)
				DatiValidazioneDataAtto dvd = new DatiValidazioneDataAtto(margine.dataAttoNascita,
						true)
				ValidationUtils.validaEstremiAtto(dve, sezioneDatiAtto)
				ValidationUtils.validaEstremiAttoComune(dvc, sezioneDatiAtto)
				ValidationUtils.validaEstremiAttoData(dvd, sezioneDatiAtto)
			} else {

				if ((margine.codiceComuneAttoNascita1 == null) || (margine.descrizioneComuneAttoNascita1 == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
				}

				if (TestoUtils.isVuoto(margine.idAttoAnscNascita1)) {
					if ((margine.attoAttoNascita1 == null) || (margine.annoAttoNascita1 == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
					}
				}

				if (margine.dataAttoNascita == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
				}
			}

		}

		// Per gli atti da annullare, il flag certificabile verrà settato a N contestualmente al consolidamento
		civValidazioneAttoService.checkNaturaVsCertificazioneAlSalvataggio(obj)

		if (DataUtils.isDataFutura(obj.dataNascita)){
			throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_data_futura"))
		}

		civValidazioneAttoService.checkOrarioEvento(obj.oraNascita, obj.oraNascitaImprecisata, obj.minutoNascita, obj.minutoNascitaImprecisato, Boolean.FALSE, "( Dati Nascita )")

		if (obj.partoPlurimo){
			if ( (obj.numeroGemello == null) || (obj.totaleGemelli == null) ){
				throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_dati_parto_plurimo"))
			}
		} else {
			obj.numeroGemello = null
			obj.totaleGemelli = null
		}

		if (obj.isSecondaA() && arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneNascita, obj.codiceProvinciaNascita)){
			throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_comune_nascita_vs_parte_serie"))
		}

		if (obj.isSecondaA() && (!(arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza))) ){
			throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_comune_residenza_vs_parte_serie"))
		}

		if ( (datiProvenienza.tipoDichiarante?:"") == ""){
			if ( obj.isDicCompFirmNasVisibile() || obj.isDicCompFirmRicVisibile() ) {
				if (obj.isCodRec3()){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campo_dichiarante"))
				} else {
					if (obj.isCodRec0() && composizioneTestoAttiva ){
						datiProvenienza.tipoDichiarante = ETipoDichiaranteNascita.AL.name()
					}
				}
			}
		}

		if ( (datiProvenienza.tipoComparente?:"") == ""){
			if ( obj.isDicCompFirmNasVisibile() || obj.isDicCompFirmRicVisibile() ) {
				if (obj.isCodRec3()){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campo_comparente"))
				} else {
					if (obj.isCodRec0() && composizioneTestoAttiva ){
						datiProvenienza.tipoComparente = datiProvenienza.tipoDichiarante
					}
				}
			}
		}

		if ( (datiProvenienza.tipoFirmatario?:"") == ""){
			if ( obj.isDicCompFirmNasVisibile() || obj.isDicCompFirmRicVisibile() ) {
				if (obj.isCodRec3()){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campo_firmatario"))
				} else {
					if (obj.isCodRec0() && composizioneTestoAttiva ){
						datiProvenienza.tipoFirmatario = datiProvenienza.tipoDichiarante
					}
				}
			}
		}

		if (obj.isCodRec3() &&
				anscOn &&
				obj.isDicCompFirmNasVisibile() &&
				obj.isTipoConsensoEnabled() &&
				!(datiProvenienza?.tipoDichiarante?.equals(ETipoDichiaranteNascita.MD.name()) && datiProvenienza?.tipoComparente?.equals(ETipoDichiaranteNascita.MD.name()))) {
			if (datiProvenienza.tipoComparente in [ETipoDichiaranteNascita.PD.name(),
												   ETipoDichiaranteNascita.MD.name(),
												   ETipoDichiaranteNascita.PP.name(),
												   ETipoDichiaranteNascita.PM.name(),
												   ETipoDichiaranteNascita.PDIT.name(),
												   ETipoDichiaranteNascita.MDIT.name()]
					&& obj.tipoConsenso == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), "'Redazione - 'Dati Dichiarazione'")
			}
		}

		// riconoscimento pre-nascita
		String sezioneDatiDichiarazione = "'Redazione - 'Dati Dichiarazione'"
		if (anscOn && obj.isCodRec3() && obj.isRiconoscimentoPrenatale() ){
			if ( ((datiProvenienza.autoritaAttoOriginale?:"") == "") || (datiProvenienza.dataAttoOriginale == null) || (obj.mesiDalConcepimento == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
			}
		}
		// riconoscimento post-nascita
		if (anscOn && obj.isCodRec3() && obj.isRiconoscimentoPostNascita() ){
			//if (datiProvenienza.isDichiaranteRiconoscimentoPadre() && (obj.tipoSceltaCognome == null) ){
				//FIXME: valutare condizione su fascia età figlio
				//throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
			//}
		}
		// Parte 1 Serie B
		if (anscOn && obj.isCodRec3() && obj.isPrimaB()) {
            if (TestoUtils.isVuoto(obj.motivoRitardo)) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
            }
			if (datiProvenienza?.isComparenteSanitario() && (obj.tipoFiliazione == ETipoFiliazione.C) && (obj.tipoMancatoConsensoMadre == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
			}
		}
		// Centro nascita
		String sezioneCentroNascita = "'Centro Nascita'"
		if ( ( TestoUtils.isVuoto(datiProvenienza.autorita) || TestoUtils.isVuoto(datiProvenienza.ufficiale) || (datiProvenienza.tipoAddettoDichiarazione == null) || (datiProvenienza.dataAttoOriginale == null)) && obj.isCentroNascita() ){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneCentroNascita)
		}
		// Centro nascita - Data richiesta
		if ( ( (datiProvenienza.dataNotaRif == null) || (TestoUtils.isVuoto(datiProvenienza.notaRif)) ) && obj.isCentroNascita() ){
			if (obj.isCodRec3() && anscOn){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneCentroNascita)
			}
		}

		if ( datiProvenienza.autorita?.length() > 100 && obj.isCentroNascita() ){
			throw new ErroreLunghezzaCampiRuntimeException(" Estremi Centro Nascita ")
		}

		if ( ((obj.codiceComuneNascita == null) || (obj.codiceProvinciaNascita == null)) && obj.isCentroNascita() ){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), "'Dati Nascita'")
		}
		// Tutte le tipologie principali
        if ( obj.isPrimaA() || obj.isPrimaB() || obj.isSecondaA() || obj.isCentroNascita()){
			civValidazioneAttoService.checkAnagraficaPadre(obj)

			if ( anscOn && datiProvenienza?.tipoDichiarante?.contains(ETipoDichiaranteNascita.PD.name()) && (obj.nazionalitaPadre == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_padre"))
			}

			civValidazioneAttoService.checkAnagraficaMadre(obj)

			if ( anscOn && datiProvenienza?.tipoDichiarante?.contains(ETipoDichiaranteNascita.MD.name()) && (obj.nazionalitaMadre == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_madre"))
			}
        }
		// refs #73616
		if ( anscOn && obj.isTrascrizioneEsteroDaPrivato() &&
			(datiProvenienza?.isRichiedentePadre() || datiProvenienza?.isRichiedenteMadre()) ){
			if (datiProvenienza?.isRichiedentePadre()){
				civValidazioneAttoService.checkAnagraficaPadre(obj)
			}
			if (datiProvenienza?.isRichiedenteMadre()){
				civValidazioneAttoService.checkAnagraficaMadre(obj)
			}
		}
		// Tipo accertamento
		if ( obj.isTipoAccertamentoVisibile() && obj.isCodRec3()){
			if (datiProvenienza.tipoAccertamento == null){
				String sezioneAltriDati = "'Redazione - Altri Dati'"
				throw new CampoMandatoryRuntimeException("- Selezionare il tipo accertamento nella sezione ${sezioneAltriDati}")
			}
		}

		if (anscOn && obj.isCodRec3()) {
			if (obj.isSedePartoMandatory() && datiProvenienza.luogoNascita == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), "'Redazione - Altri Dati'")
			}
		}
	}

	void storicizza(long id) {
		civValidazioneAttoService.checkCompetenzaModifica()

		CivNascita obj = get(id, [:])
		log.info("Lancio salvataggio dello storico su CIVNAS per id " + obj.id)

		CivNascita newest = DomainUtils.copyAtto(obj) as CivNascita
		newest.id = gsdService.getIdFromSequence(newest) // genero una nuova pk
		newest.setCodRec1()

		civNascitaRepository.save(newest)
	}

	CivNascita save (ETipoOperazione tipoOperazione, CivNascita obj, CivAnagrafe anagrafe, CivDatiProvenienzaAtto datiProvenienza, CivMargine margine,
					 Map<String, CivFormulaTestoLibero> mapFormule, Boolean composizioneTestoAttiva, EGestioneConsolidamento gc, Boolean tipoMargineLateraleMandatory,
					 List<CivSoggettoCollegato> soggettiCollegati, Boolean ignoreCheckResidenza1 = Boolean.FALSE,
					 boolean isRettificato = false) {

		civValidazioneAttoService.checkCompetenzaModifica()

		validaDati(tipoOperazione, obj, datiProvenienza, margine, composizioneTestoAttiva, gc, ignoreCheckResidenza1)

		ArcComune c = arcComuneBaseService.getComuneCliente()

		if (margine){
			Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

			DomainUtils.initFromAtto(margine, obj)
			// 1 allineare sempre
			// 2 se comune residenza diverso da comune utente stampare formula del margine
			// Doc in S:\SI4\De4\De4GSDzk\Doc\Nco\Nco.CIV.Margine.docx
			margine.descrizioneComuneTras1 = obj.descrizioneComuneResidenza
			margine.stampaFormulaMargineTr1 = Boolean.FALSE
			if (FormulaUtils.addFormulaNascita(FormulaUtils.FORMULA_MARGINE_TR1, tipoOperazione, obj, datiProvenienza, c) &&
					(obj.codiceComuneResidenza != null) && (obj.codiceProvinciaResidenza != null)) {
				if (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, c) ) {
					log.info ("Il comune di residenza del nato è valorizzato e coincide con il comune utente")
				} else {
					if (!(anscOn)) {
						margine.stampaFormulaMargineTr1 = Boolean.TRUE
					}
				}
			}

			margine.stampaFormulaSentenza = Boolean.FALSE
			// refs #73234
			if ((!(anscOn)) && FormulaUtils.addFormulaNascita(FormulaUtils.FORMULA_MARGINE_SENTENZA, tipoOperazione, obj, datiProvenienza) ) {
				margine.stampaFormulaSentenza = Boolean.TRUE
			}

			if (margine.tipoMargineLaterale == null){
				String tm = civMargineService.getMargineDefault(obj, CivMargine.tipoMagineDS)
				margine.tipoMargineLaterale = (tm?ETipoMargineLaterale.valueOf(tm):null)
			}

			civMargineService.save(margine, obj.getTipoAttoEnum(), tipoMargineLateraleMandatory)
		}

		if (datiProvenienza){
			DomainUtils.initFromAtto(datiProvenienza, obj)

            Boolean attoNotarileMatMandatory = (obj.isCodRec3() && obj.tipoFiliazione.equals(ETipoFiliazione.C) && datiProvenienza.isComparenteProcuratorePadre() && obj.tipoConsenso.equals(ETipoConsenso.CM))
            Boolean attoNotarilePatMandatory = (obj.isCodRec3() && obj.tipoFiliazione.equals(ETipoFiliazione.C) && datiProvenienza.isComparenteProcuratoreMadre() && obj.tipoConsenso.equals(ETipoConsenso.CP))
			Boolean dataTrascrizioneMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())

			DatiProvenienzaValidationCheck dvc = new DatiProvenienzaValidationCheck(obj.getTipoAttoEnum())
			dvc.dichiaranteMandatory 	= (obj.isCodRec3() && (obj.isDicCompFirmNasVisibile() || obj.isDicCompFirmRicVisibile()) )
			dvc.richiedenteTeaMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita())
			dvc.richiedenteTepMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaPrivato())
			dvc.attoDaTrascrivereMandatory = (obj.isCodRec3() && (obj.isTrascrizioneEsteroDaPrivato() || obj.isTrascrizioneEsteroDaAutorita() || obj.isOmessaDichiarazioneNascita()))
			dvc.estremiAttoDaTrascrivereMandatory = obj.isCodRec3() && obj.isOmessaDichiarazioneNascita()
			dvc.attoNotarileMandatory = (attoNotarileMatMandatory || attoNotarilePatMandatory)
			dvc.consolatoMandatory = (obj.isCodRec3() && obj.isConsolatoMandatory() && !datiProvenienza.flagInViaggio)
			dvc.firmatarioMandatory = dvc.richiedenteTepMandatory
			dvc.procuraMandatory = (obj.isCodRec3() && datiProvenienza.isComparenteProcuratore())
			dvc.dataTrascrizioneMandatory = dataTrascrizioneMandatory
			dvc.tipoLuogoNascitaMandatory = (obj.isCodRec3() && obj.isTrascrizioneEsteroDaAutorita() && datiProvenienza.flagInViaggio)

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
					case ETipoSoggettoCollegato.OS:
						saveSoggetto = datiProvenienza?.isComparenteSanitario()
						break
					case ETipoSoggettoCollegato.PP:
						saveSoggetto = datiProvenienza?.isComparenteProcuratorePadre()
						break
					case ETipoSoggettoCollegato.PM:
						saveSoggetto = datiProvenienza?.isComparenteProcuratoreMadre()
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

		//Per un pregresso e per un consolidato NON devo salvare su CIVANA; salvo sempre SOLO per cod_rec 3
		//Per un atto che viene consolidato devo cancellare da CIVANA il record eventualmente salvato in fase di inserimento dell'atto
		//se il comune di residenza del nato NON coincide con quello del cliente
		if (anagrafe != null){
			// refs #62858
            EFascia fasciaMadre = anagrafe?.anagrafe2?.fascia
            EFascia fasciaPadre = anagrafe?.anagrafe1?.fascia ?: null
            EFascia fasciaConfronto = ((fasciaMadre != null && fasciaMadre != EFascia.NON_RESIDENTE)?fasciaMadre:fasciaPadre)
            Boolean isComuneUtenteResidenzaNato = (arcComuneBaseService.isComuneClienteOggi(obj.codiceComuneResidenza, obj.codiceProvinciaResidenza, c) ||
                    (fasciaConfronto == EFascia.ISCRITTO_AIRE))
            if ( obj.isCodRec3() ||
					( obj.isCodRec0() && isComuneUtenteResidenzaNato && ( (obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T) ) ) ){
				DomainUtils.initFromAtto(anagrafe, obj)

				if (obj.natura == ENaturaAtto.T ){
					DomainUtils.initAttoOriginaleAnagrafeFromDatiProvenienzaAtto(anagrafe, datiProvenienza)
				}

				civAnagrafeService.save(anagrafe, obj.tipoAttoEnum)
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
					if (FormulaUtils.addFormulaNascita(e.key, tipoOperazione, obj, datiProvenienza)){
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

		if (obj.tipoFiliazione == ETipoFiliazione.L){
			obj.tipoConsenso = null
		}

		// Se è stato storicizzato l'atto devo incrementare la versione prima di salvarlo
		if (isRettificato) {
			obj.versioneRettifica = obj.versioneRettifica + 1
            obj.dataVersioneRettifica = new Date()
		}

		log.info("Lancio salvataggio (${tipoOperazione.name()}) su CIVNAS per id " + obj.id)
		CivNascita savedNas = civNascitaRepository.save(obj)
		//refs #46107
		//Comunicazioni (da non inviare in caso di inserimento di un atto pregresso)
		if (tipoOperazione.isInsert() && obj.isCodRec3() ){
			civComunicazioneAttoService.sendAllDefaultComunicazioni(tipoOperazione, obj, anagrafe)
		}
		return savedNas
	}

	private void handleCertificabile(CivNascita obj, CivDatiProvenienzaAtto datiProvenienza){
		if (obj.natura == ENaturaAtto.N){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		// check flag introdotto per ansc use case 1315
		if (obj.isTrascrizioneEsteroDaPrivato() && datiProvenienza.flagExArt19){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		if (obj.isRiconoscimento() || obj.isAdozione() || obj.isCambioGeneralita() ){
			obj.certificabile = ETipoSiNo.NO
			return
		}
		if ((obj.natura == ENaturaAtto.O) || (obj.natura == ENaturaAtto.T)){
			obj.certificabile = ETipoSiNo.SI
		}
	}

	EMotivoRecupero getMotivoRecuperoAnsc(Long id){
		return civNascitaRepository.findMotivoRecuperoAnsc(id)
	}

	void ripristina(ETipoOperazione tipoOperazione, CivNascita obj, EGestioneConsolidamento gc){
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

	void delete(CivNascita obj){

		civValidazioneAttoService.checkCompetenzaCancellazione()

		if (obj.id != null) {
            if (isInviatoAnsc(obj.id)){
                throw new AnscRuntimeException(Etichette.getEtichetta("Errore_ANSC_cancellazione_entita"))
            }
			// refs #70786
			// Per il fascicolo NON è stata gestita la cascade delete da trigger, sicché cancello da java
			// sollevando eccezione se il fascicolo contiene allegati
			civFascicoloAttoAllegatoService.deleteFascicoloEAllegatiXAtto(obj)

			log.info("Tento cancellazione su CIVNAS per id " + obj.id)
			civNascitaRepository.delete(obj)
		}
	}

}
