package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.utils.*
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivValidazioneAttoService {

	private final CivTipoAttoService civTipoAttoService

	private final StatoCivileService statoCivileService

	private final CompetenzaService competenzaService

	private final CivTipoComprensioneService civTipoComprensioneService

	CivValidazioneAttoService(CivTipoAttoService civTipoAttoService, StatoCivileService statoCivileService,
							  CompetenzaService competenzaService, CivTipoComprensioneService civTipoComprensioneService) {
		this.civTipoAttoService = civTipoAttoService
		this.statoCivileService = statoCivileService
		this.competenzaService = competenzaService
		this.civTipoComprensioneService = civTipoComprensioneService
	}

	void checkEstremiAtto(ETipoOperazione tipoOperazione, CivAttoBaseDomain atto){
		Boolean emptyMandatoryFields = Boolean.TRUE

		ETipoAtto tipoAttoEnumSource = atto.getTipoAttoEnum()
		switch (tipoAttoEnumSource) {
			case ETipoAtto.NAS:
			case ETipoAtto.PUB:
			case ETipoAtto.MAT:
			case ETipoAtto.UCI:
            case ETipoAtto.MOR:
				emptyMandatoryFields = ((atto.ufficio == null) || (atto.anno == null) || (atto.atto == null) || (atto.parte == null) || (atto.natura == null))
				break
			case ETipoAtto.PVU:
			case ETipoAtto.CIT:
				emptyMandatoryFields = ((atto.ufficio == null) || (atto.anno == null) || (atto.atto == null) || (atto.natura == null))
				break
		}

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_atto)
		}

		if (tipoOperazione.isInsert()) {
			String s = statoCivileService.checkEstremiAtto(atto)
			if ((s?.trim() ?: "") != "") {
				throw new De4gsdzkRuntimeException(s)
			}
		}
	}

	void checkConsolidamentoProvvisorio(CivAttoBaseDomain atto, EGestioneConsolidamento gc){
		if ( (gc != null) && atto.isProvvisorio() ){
			throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_consolidamento_atto_provvisorio)
		}
	}

	void checkNaturaVsCertificazioneAlSalvataggio(CivAttoBaseDomain a){
		if (a instanceof ICertificabile){
			// Per gli atti da annullare, il flag certificabile verrà settato a N contestualmente al consolidamento
			boolean err = ( (a.natura != ENaturaAtto.O) && (a.natura != ENaturaAtto.T) && (a.natura != ENaturaAtto.N) && (a.certificabile == ETipoSiNo.SI) )
			if (err) {
				throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_natura_vs_certificazione)
			}
		}
	}

	void checkTipoAttoAndParteAndSerieAndNatura(CivAttoBaseDomain atto){
		Boolean tipoOk = civTipoAttoService.checkTipoAttoAndParteAndSerieAndNatura(atto, atto.tipoAttoDomain?.categoriaDomain)
		if (!tipoOk){
			throw new ErroreTipoAttoRuntimeException(EtichetteMessaggi.Errore_natura_vs_tipo_atto)
		}
	}

	void checkOrarioEvento(String oraEvento, Boolean oraEventoImprecisata, String minutoEvento, Boolean minutoEventoImprecisato, Boolean strictOrarioEventoCheck, String sezione){
		if ( !(OrarioUtils.isOraValida(oraEvento)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_ora, sezione)
		}

		if ( !(OrarioUtils.isMinutoValido(minutoEvento)) ){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_valore_minuti, sezione)
		}

		if ( ( (oraEvento?:"") != "" ) && oraEventoImprecisata){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_ora_imprecisata, sezione)
		}

		if ( ( (minutoEvento?:"") != "" ) && minutoEventoImprecisato){
			throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_minuti_imprecisati, sezione)
		}

		if (strictOrarioEventoCheck){
			if (TestoUtils.isVuoto(oraEvento) && (!(oraEventoImprecisata)) ){
				throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_ora_imprecisata, sezione)
			}
			if (TestoUtils.isVuoto(minutoEvento) && (!(minutoEventoImprecisato)) ){
				throw new ErroreOrarioRuntimeException(EtichetteMessaggi.Errore_minuti_imprecisati, sezione)
			}
		}
	}

	void checkComuneEventoMandatory(IAttoMatPubUciPvuBase atto, String sezione){
		if ( (atto.codiceComuneMatrimonio == null) || (atto.codiceProvinciaMatrimonio == null) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}
	}

	void checkCognomeNomeTroppoLunghiSoggetto1(ISoggettoAtto1 atto, String campoSoggetto){
		if ( ( (atto.cognome1?.length()?:0) + (atto.nome1?.length()?:0) ) >= 100 ){
			throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
		}
	}

	void checkCognomeNomeTroppoLunghiSoggetto2(ISoggettoAtto2 atto, String campoSoggetto){
		if ( ( (atto.cognome2?.length()?:0) + (atto.nome2?.length()?:0) ) >= 100 ){
			throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
		}
	}

	void checkCfTroppoLungoSoggetto1(ISoggettoAtto1 atto, String campoSoggetto){
		if ( (atto.getCodiceFiscale1()?.length()?:0) > 16 ){
			throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
		}
	}

	void checkCfTroppoLungoSoggetto2(ISoggettoAtto2 atto, String campoSoggetto){
		if ( (atto.getCodiceFiscale2()?.length()?:0) > 16 ){
			throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
		}
	}

	void checkDatiObbligatoriIncompletiSoggetto1(ISoggettoAtto1 atto, String sezione,
												 Boolean checkDatiResidenza = Boolean.TRUE, Boolean checkLuogoNascita = Boolean.FALSE, Boolean checkDataNascita = Boolean.FALSE, Boolean checkNazionalita = Boolean.FALSE, Boolean checkStatoCivile = Boolean.FALSE, Boolean checkComprensione = Boolean.FALSE) {
		if ( (!(atto.cognome1?.trim())) && (!(atto.nome1?.trim())) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if ( (!(atto.cognome1?.trim())) && (!(atto.senzaCognome1)) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if ( (!(atto.nome1?.trim())) && (!(atto.senzaNome1)) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (atto.sesso1 == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (checkDatiResidenza) {
			if ((atto.codiceComuneResidenza1 == null) || (atto.codiceProvinciaResidenza1 == null)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

		if (checkLuogoNascita){
			if ( (atto.codiceComuneNascita1 == null) || (atto.codiceProvinciaNascita1 == null) ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

		if (checkDataNascita && atto.dataNascita1 == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (checkNazionalita){
			if ( atto.nazionalita1 == null ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

        if (checkStatoCivile){
            if ( atto.statoCivile1 == null ){
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
            }
        }

		if (checkComprensione){
			if ( (atto instanceof IAttoMatUci) && ((IAttoMatUci)atto).comprensione1 == null ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			} else {
				CivTipoComprensione tc = civTipoComprensioneService.get( ((IAttoMatUci)atto).comprensione1.id)
				if ( (tc.flagMotivazioneImpedimento) && (( ((IAttoMatUci)atto).motivoImpedimento1?:"") == "") ){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
				}
			}
		}
	}

	void checkDatiObbligatoriIncompletiSoggetto2(ISoggettoAtto2 atto, String sezione,
												 Boolean checkLuogoNascita=Boolean.FALSE, Boolean checkDataNascita=Boolean.FALSE, Boolean checkNazionalita=Boolean.FALSE, Boolean checkStatoCivile=Boolean.FALSE, Boolean checkComprensione=Boolean.FALSE){
		if ( (!(atto.cognome2?.trim())) && (!(atto.nome2?.trim())) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if ( (!(atto.cognome2?.trim())) && (!(atto.senzaCognome2)) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if ( (!(atto.nome2?.trim())) && (!(atto.senzaNome2)) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (atto.sesso2 == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if ( (atto.codiceComuneResidenza2 == null) || (atto.codiceProvinciaResidenza2 == null) ){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (checkLuogoNascita){
			if ( (atto.codiceComuneNascita2 == null) || (atto.codiceProvinciaNascita2 == null)){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

		if (checkDataNascita && atto.dataNascita2 == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}

		if (checkNazionalita){
			if ( atto.nazionalita2 == null ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

		if (checkStatoCivile){
			if ( atto.statoCivile2 == null ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}

		if (checkComprensione){
			if ( (atto instanceof IAttoMatUci) && ((IAttoMatUci)atto).comprensione2 == null ){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			} else {
				CivTipoComprensione tc = civTipoComprensioneService.get( ((IAttoMatUci)atto).comprensione2.id)
				if ( (tc.flagMotivazioneImpedimento) && (( ((IAttoMatUci)atto).motivoImpedimento2?:"") == "") ){
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
				}
			}
		}
	}

	void checkSessoContraenti(ISoggettoAtto1 atto1, ISoggettoAtto2 atto2){
		if (atto1.sesso1 != atto2.sesso2){
			throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_sesso_contraenti)
		}
	}

	void checkAnagraficaPadre(ISoggettoAtto1Genitori atto){
		if ( atto.cognomePadre?.trim() && ((atto.nomePadre?.trim()?:"") == "") && (!(atto.senzaNomePadre)) ) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_padre)
		}

		if ( atto.nomePadre?.trim() && ((atto.cognomePadre?.trim()?:"") == "") && (!(atto.senzaCognomePadre)) ) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_padre)
		}
	}

	void checkAnagraficaMadre(ISoggettoAtto1Genitori atto){
		if ( atto.cognomeMadre?.trim() && ((atto.nomeMadre?.trim()?:"") == "") && (!(atto.senzaNomeMadre)) ) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_madre)
		}

		if ( atto.nomeMadre?.trim() && ((atto.cognomeMadre?.trim()?:"") == "") && (!(atto.senzaCognomeMadre)) ) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_madre)
		}
	}

	void checkDichiaranteComparenteFirmatario(CivDatiProvenienzaAtto datiProvenienza, Boolean checkDich, Boolean checkComp, Boolean checkFirm){
		if ( checkDich && (datiProvenienza.tipoDichiarante?:"") == ""){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campo_dichiarante)
		}

		if ( checkComp && (datiProvenienza.tipoComparente?:"") == ""){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campo_comparente)
		}

		if ( checkFirm && (datiProvenienza.tipoFirmatario?:"") == ""){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campo_firmatario)
		}
	}

	void checkCompetenzaModifica(){
		if (!(competenzaService.isCivSuperUser())){
			throw new CompetenzeRuntimeException(EtichetteMessaggi.Errore_Competenze_Modifica_Atto)
		}
	}

	void checkCompetenzaCancellazione(){
		if (!(competenzaService.isCivSuperUser())){
			throw new CompetenzeRuntimeException(EtichetteMessaggi.Errore_Competenze_Cancellazione_Atto)
		}
	}

	void checkDataOraEvento(IAttoMatUci atto, String sezione) {
		if (!atto.isDataOraMatrimonioMandatory()) {
			return
		}
		if (atto.dataMatrimonio == null ||
				!(atto.oraMatrimonio?.trim()) ||
				!(atto.minutoMatrimonio?.trim())) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
		}
	}


	void checkUfficialeStatoCivile(CivAttoBaseDomain atto, CivDatiProvenienzaAtto datiProvenienza) {
		if (!atto.isUfficialeStatoCivileMandatory()) {
			return
		}
		if (datiProvenienza.ufficialeUtente == null) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, "Redazione - Dati per Redazione")
		}
	}

}
