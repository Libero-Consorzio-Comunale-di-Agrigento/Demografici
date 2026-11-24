package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreLunghezzaCampiRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreOrarioRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreValoreParteSerieException
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivDatiProvenienzaAttoService {

	private final GsdService gsdService

	private final CivTipoComprensioneService civTipoComprensioneService

	private final ArcParametroService arcParametroService

	private final CivUfficialeService civUfficialeService

	private final CivDatiProvenienzaAttoRepository civDatiProvenienzaAttoRepository

	CivDatiProvenienzaAttoService(CivDatiProvenienzaAttoRepository civDatiProvenienzaAttoRepository,
                                  CivTipoComprensioneService civTipoComprensioneService, ArcParametroService arcParametroService,
                                  CivUfficialeService civUfficialeService, GsdService gsdService) {

		this.civDatiProvenienzaAttoRepository = civDatiProvenienzaAttoRepository
		this.civTipoComprensioneService = civTipoComprensioneService
		this.arcParametroService = arcParametroService
		this.civUfficialeService = civUfficialeService
		this.gsdService = gsdService
	}

	CivDatiProvenienzaAtto create() {
		CivUfficiale ufficiale = civUfficialeService.getByCognomeNomeUtenteCorrente()
		return (new CivDatiProvenienzaAtto(dataAtto: (new Date()).clearTime(), oraAtto: Calendar.getInstance().get(Calendar.HOUR_OF_DAY),
				minutoAtto: Calendar.getInstance().get(Calendar.MINUTE), ufficialeUtente: ufficiale?.cognomeNome, qualificaUtente: ufficiale?.qualifica,
				attoNotarile: ETipoSiNo.NO))
	}

	CivDatiProvenienzaAtto getByUkAtto(String identificativoAtto) {
		return civDatiProvenienzaAttoRepository.findByUkAtto(identificativoAtto)
	}

	CivDatiProvenienzaAtto getOrCreateByUkAtto(CivAttoBaseDomain a) {
		CivDatiProvenienzaAtto m = getByUkAtto(a.idAtto)
		if (!(m)){
			m = new CivDatiProvenienzaAtto(attoNotarile: ETipoSiNo.NO)
		}
		return m
	}

	List<String> listAllDistinctDocumentoDecessoByDocumentoDecessoLike(String filtro){
		return civDatiProvenienzaAttoRepository.findAllDistinctDocumentoDecessoByDocumentoDecessoLike((filtro?:""))
	}

	private void validaDati(CivDatiProvenienzaAtto obj, DatiProvenienzaValidationCheck dvc){

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		////////////////////////// ESTREMI ATTO /////////////////////////

		Boolean emptyMandatoryFields = TipoAttoUtils.isEstremiAttoEmpty(obj, dvc.tipoAttoEnumSource)
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}

		////////////////////////// ATTO ORIGINALE /////////////////////////

		String sezione = "( Atto originale )"
		// Serie
		Boolean serieOk = TipoAttoUtils.isSerieOk(dvc.tipoAttoEnumSource, obj.serieAttoOriginale)
		if (!(serieOk)) {
			throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), sezione)
		}
		// Parte
		Boolean parteOk = TipoAttoUtils.isParteOk(dvc.tipoAttoEnumSource, obj.parteAttoOriginale)
		if (!(parteOk)) {
			throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezione)
		}
		// Atto
		Boolean isAttoOk = TipoAttoUtils.isAttoOk(obj.attoAttoOriginale)
		if (!(isAttoOk)) {
			throw new ErroreLunghezzaCampiRuntimeException("Atto nella Sezione 'Atto Originale'")
		}
		// Orario
		if ( !(OrarioUtils.isOraValida(obj.oraAttoOriginale)) ){
			throw new ErroreOrarioRuntimeException(Etichette.getEtichetta("Errore_valore_ora"), sezione)
		}

		if ( !(OrarioUtils.isMinutoValido(obj.minutoAttoOriginale)) ){
			throw new ErroreOrarioRuntimeException(Etichette.getEtichetta("Errore_valore_minuti"), sezione)
		}

		////////////////////////// ATTO RICONOSCIMENTO /////////////////////////

		if (anscOn && [ETipoAtto.NAS, ETipoAtto.CIT].contains(dvc.tipoAttoEnumSource)) {
			String sezioneAttoRic
			if (dvc.tipoAttoEnumSource == ETipoAtto.NAS){
				sezioneAttoRic = "'Estremi Atto di Riconoscimento' della sezione 'Filiazione'"
			} else {
				sezioneAttoRic = "'Estremi atto/sentenza di riconoscimento'"
			}
			if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
				EstremiAtto estremiAttoRic1 = new EstremiAtto(ufficio: obj.ufficioAttoRiconoscimento1,
						atto: obj.numeroAttoRiconoscimento1,
						anno: obj.annoAttoRiconoscimento1,
						parte: obj.parteAttoRiconoscimento1,
						serie: obj.serieAttoRiconoscimento1,
						idAttoAnsc: obj.idAttoAnscRiconoscimento1)
				DatiValidazioneEstremi dve1 = new DatiValidazioneEstremi(ETipoAtto.NAS, estremiAttoRic1, dvc.riconoscimento1Mandatory, false)
				DatiValidazioneDataAtto dva1 = new DatiValidazioneDataAtto(obj.dataAttoRiconoscimento1, dvc.riconoscimento1Mandatory)
				DatiValidazioneComune dvce1 = new DatiValidazioneComune(obj.comuneAttoRiconoscimento1, dvc.riconoscimento1Mandatory)
				ValidationUtils.validaEstremiAtto(dve1, sezioneAttoRic)
				ValidationUtils.validaEstremiAttoData(dva1, sezioneAttoRic)
				ValidationUtils.validaEstremiAttoComune(dvce1, sezioneAttoRic)

				EstremiAtto estremiAttoRic2 = new EstremiAtto(ufficio: obj.ufficioAttoRiconoscimento2,
						atto: obj.numeroAttoRiconoscimento2,
						anno: obj.annoAttoRiconoscimento2,
						parte: obj.parteAttoRiconoscimento2,
						serie: obj.serieAttoRiconoscimento2,
						idAttoAnsc: obj.idAttoAnscRiconoscimento2)
				DatiValidazioneEstremi dve2 = new DatiValidazioneEstremi(ETipoAtto.NAS, estremiAttoRic2, dvc.riconoscimento2Mandatory, false)
				DatiValidazioneDataAtto dva2 = new DatiValidazioneDataAtto(obj.dataAttoRiconoscimento2, dvc.riconoscimento2Mandatory)
				DatiValidazioneComune dvce2 = new DatiValidazioneComune(obj.comuneAttoRiconoscimento2, dvc.riconoscimento2Mandatory)
				ValidationUtils.validaEstremiAtto(dve2, sezioneAttoRic)
				ValidationUtils.validaEstremiAttoData(dva2, sezioneAttoRic)
				ValidationUtils.validaEstremiAttoComune(dvce2, sezioneAttoRic)
			} else {
				// Serie
				Boolean serieAttoRic1Ok = TipoAttoUtils.isSerieOk(ETipoAtto.NAS, obj.serieAttoRiconoscimento1)
				if (!(serieAttoRic1Ok)) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), "( " + sezioneAttoRic + " )")
				}
				Boolean serieAttoRic2Ok = TipoAttoUtils.isSerieOk(ETipoAtto.NAS, obj.serieAttoRiconoscimento2)
				if (!(serieAttoRic2Ok)) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), "( " + sezioneAttoRic + " )")
				}
				// Parte
				Boolean parteAttoRic1Ok = TipoAttoUtils.isParteOk(ETipoAtto.NAS, obj.parteAttoRiconoscimento1)
				if (!(parteAttoRic1Ok)) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), "( " + sezioneAttoRic + " )")
				}
				Boolean parteAttoRic2Ok = TipoAttoUtils.isParteOk(ETipoAtto.NAS, obj.parteAttoRiconoscimento2)
				if (!(parteAttoRic2Ok)) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), "( " + sezioneAttoRic + " )")
				}
				// Atto
				Boolean isAttoRic1Ok = TipoAttoUtils.isAttoOk(obj.numeroAttoRiconoscimento1)
				if (!(isAttoRic1Ok)) {
					throw new ErroreLunghezzaCampiRuntimeException("Atto in " + sezioneAttoRic)
				}
				Boolean isAttoRic2Ok = TipoAttoUtils.isAttoOk(obj.numeroAttoRiconoscimento2)
				if (!(isAttoRic2Ok)) {
					throw new ErroreLunghezzaCampiRuntimeException("Atto in " + sezioneAttoRic)
				}
				if (dvc.riconoscimento1Mandatory) {
					if ((obj.dataAttoRiconoscimento1 == null) || (obj.comuneAttoRiconoscimento1.codice == null) || (obj.comuneAttoRiconoscimento1.codiceProvincia == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoRic)
					}
					if (TestoUtils.isVuoto(obj.idAttoAnscRiconoscimento1)) {
						if ((obj.numeroAttoRiconoscimento1 == null) || (obj.annoAttoRiconoscimento1 == null)) {
							throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoRic)
						}
					}
				}
				if (dvc.riconoscimento2Mandatory) {
					if ((obj.dataAttoRiconoscimento2 == null) || (obj.comuneAttoRiconoscimento2.codice == null) || (obj.comuneAttoRiconoscimento2.codiceProvincia == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoRic)
					}
					if (TestoUtils.isVuoto(obj.idAttoAnscRiconoscimento2)) {
						if ((obj.numeroAttoRiconoscimento2 == null) || (obj.annoAttoRiconoscimento2 == null)) {
							throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoRic)
						}
					}
				}
			}
		}

		//////////////////////////// PROCURA ///////////////////////////

		if (anscOn && dvc.procuraMandatory){
			if (TestoUtils.isVuoto(obj.datiProcura)) {
				throw new CampoMandatoryRuntimeException("- Compilare i dati essenziali della procura")
			}
		}

		////////////////////////// ATTO ASSENSO /////////////////////////

		if (anscOn && [ETipoAtto.NAS].contains(dvc.tipoAttoEnumSource)) {
			String sezioneAttoAssenso = "'Estremi Atto assenso figlio'"

			if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
				EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAttoAssenso,
						atto: obj.numeroAttoAssenso,
						anno: obj.annoAttoAssenso,
						parte: obj.parteAttoAssenso,
						serie: obj.serieAttoAssenso,
						idAttoAnsc: obj.idAttoAnscAssenso)
				DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
						estremiAtto,
						dvc.assensoMandatory,
						false)
				DatiValidazioneComune dvce = new DatiValidazioneComune(obj.comuneAttoAssenso, dvc.assensoMandatory)
				DatiValidazioneDataAtto dvda = new DatiValidazioneDataAtto(obj.dataAttoAssenso, dvc.assensoMandatory)
				ValidationUtils.validaEstremiAtto(dve, sezioneAttoAssenso)
				ValidationUtils.validaEstremiAttoComune(dvce, sezioneAttoAssenso)
				ValidationUtils.validaEstremiAttoData(dvda, sezioneAttoAssenso)
			} else {
				// Atto
				Boolean isAttoAssOk = TipoAttoUtils.isAttoOk(obj.numeroAttoAssenso)
				if (!(isAttoAssOk)) {
					throw new ErroreLunghezzaCampiRuntimeException("Atto in " + sezioneAttoAssenso)
				}
				// Anno
				Boolean isAnnoAssOk = TipoAttoUtils.isAnnoOk(obj.annoAttoAssenso)
				if (!(isAnnoAssOk)) {
					throw new ErroreLunghezzaCampiRuntimeException("Anno in " + sezioneAttoAssenso)
				}
				if (dvc.assensoMandatory) {
					if (TestoUtils.isVuoto(obj.idAttoAnscAssenso)) {
						if ((obj.numeroAttoAssenso == null) || (obj.annoAttoAssenso == null)) {
							throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoAssenso)
						}
					}
					if (!(ValidationUtils.isComuneAndDataFormazioneValid(obj.comuneAttoAssenso, obj.dataAttoAssenso))) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoAssenso)
					}
				}
			}
		}

		//////////////////////////// TIPO ACCORDO C/O UFF o AVV //////////////////////////

		if (dvc.tipoAccordoMandatory) {
			if (obj.tipoAccordo == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_tipo_accordo"))
			}
		}

		////////////////////////////// TIPO DIVORZIO ALTRO ////////////////////////////

		if (dvc.tipoDivorzioAltroMandatory && anscOn) {
			if (obj.tipoDivorzioAltro == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_tipo_divorzio_altro_divorzio"))
			}
		}

		////////////////////////////// TIPO SEPARAZIONE //////////////////////////////

		if (dvc.tipoProvvedimentoSeparazioneMandatory && anscOn){
			if (obj.tipoProvvedimentoSeparazione == null){
				throw new CampoMandatoryRuntimeException("- Indicare il tipo di separazione nella sezione 'Sposi'")
			}
		}

		////////////////////////// PROVVEDIMENTO SEPARAZIONE /////////////////////////

		// refs #72274
		if (dvc.provvedimentoSeparazioneMandatory && anscOn){
			String sezioneProvvSeparazione = "'Dati Atto' - 'Estremi separazione'"

			if (TestoUtils.isVuoto(obj.enteSeparazione) || TestoUtils.isVuoto(obj.estremiSeparazione)){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneProvvSeparazione)
			}

			if (!(ValidationUtils.isComuneAndDataFormazioneValid(obj.comuneAttoSeparazione, obj.dataAttoSeparazione)) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneProvvSeparazione)
			}
		}

		///////////////////// CONFERMA ACCORDO SEPARAZIONE //////////////////////

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			String sezioneConfermaSeparazione = "'Dati Atto' - 'Estremi Conferma Accordo Separazione'"
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioConfermaAccordoSeparazione,
					atto: obj.attoConfermaAccordoSeparazione,
					anno: obj.annoConfermaAccordoSeparazione,
					parte: obj.parteConfermaAccordoSeparazione,
					serie: obj.serieConfermaAccordoSeparazione,
					idAttoAnsc: obj.idAttoAnscConfermaAccordoSeparazione)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.MAT, estremiAtto, dvc.confermaAccordoSeparazioneMandatory && anscOn, false)
			DatiValidazioneDataAtto dvda = new DatiValidazioneDataAtto(obj.dataConfermaAccordoSeparazione, dvc.confermaAccordoSeparazioneMandatory && anscOn)
			DatiValidazioneComune dvce = new DatiValidazioneComune(obj.comuneConfermaAccordoSeparazione, dvc.confermaAccordoSeparazioneMandatory && anscOn)
			ValidationUtils.validaEstremiAtto(dve, sezioneConfermaSeparazione)
			ValidationUtils.validaEstremiAttoData(dvda, sezioneConfermaSeparazione)
			ValidationUtils.validaEstremiAttoComune(dvce, sezioneConfermaSeparazione)
		} else {
			if (dvc.confermaAccordoSeparazioneMandatory && anscOn) {
				String sezioneConfermaSeparazione = "'Dati Atto' - 'Estremi Conferma Accordo Separazione'"

				if ((obj.attoConfermaAccordoSeparazione == null) || (obj.annoConfermaAccordoSeparazione == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneConfermaSeparazione)
				}

				if (!(ValidationUtils.isComuneAndDataFormazioneValid(obj.comuneConfermaAccordoSeparazione, obj.dataConfermaAccordoSeparazione))) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneConfermaSeparazione)
				}
			}
		}

		////////////////////////// DATI ACCORDO /////////////////////////

		String sezioneDatiAccordo = "'Estremi accordo'" // anche in negoziazione assistita

		if (dvc.accordoMandatory && anscOn){
			if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
				EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAccordo,
						anno: obj.annoAccordo,
						atto: obj.attoAccordo,
						parte: obj.parteAccordo,
						serie: obj.serieAccordo,
						idAttoAnsc: obj.idAttoAnscAccordo)
				DatiValidazioneEstremi eve = new DatiValidazioneEstremi(dvc.tipoAttoEnumSource, // L'accordo di separazione/divorzio ha lo stesso tipo atto dell'atto da salvare
						estremiAtto,
						true,
						false)
				DatiValidazioneComune evc = new DatiValidazioneComune(obj.comuneAccordo, true)
				ValidationUtils.validaEstremiAtto(eve, sezioneDatiAccordo)
				ValidationUtils.validaEstremiAttoComune(evc, sezioneDatiAccordo)
			} else {
				if ((obj.comuneAccordo.codice == null) || (obj.comuneAccordo.codiceProvincia == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAccordo)
				}

				if (TestoUtils.isVuoto(obj.idAttoAnscAccordo)) {
					if ((obj.attoAccordo == null) || (obj.annoAccordo == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAccordo)
					}
				}
			}
		}

		////////////////////////// AVVOCATI /////////////////////////

		String sezioneAvvocati = "'Avvocati'" // anche per check negoziazione assistita

		// Dati avvocati per tutte le cat ad eslcusione di RCN e AVV
		if (dvc.avvocatiMandatory && anscOn){
			if ( ( obj.cognomeAvvocato1?.trim() || obj.nomeAvvocato1?.trim() ) && TestoUtils.isVuoto(obj.foroAvvocato1) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " (foro di appartenenza) ")
			}

			if ( ( obj.cognomeAvvocato2?.trim() || obj.nomeAvvocato2?.trim() ) && TestoUtils.isVuoto(obj.foroAvvocato2) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " (foro di appartenenza) ")
			}
		}

		if (dvc.avvocato1Mandatory) {
			if (TestoUtils.isVuoto(obj.cognomeAvvocato1) || TestoUtils.isVuoto(obj.nomeAvvocato1) || TestoUtils.isVuoto(obj.foroAvvocato1)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " (Avvocato Marito) ")
			}
		}

		if (dvc.avvocato2Mandatory) {
			if (TestoUtils.isVuoto(obj.cognomeAvvocato2) || TestoUtils.isVuoto(obj.nomeAvvocato2) || TestoUtils.isVuoto(obj.foroAvvocato2)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " (Avvocato Moglie) ")
			}
		}

        ////////////////////////// REDAZIONE /////////////////////////

		String sezioneRedazione = "'Redazione' - 'Dati per Redazione'"

		if ( !(OrarioUtils.isOraValida(obj.oraAtto)) ){
			throw new ErroreOrarioRuntimeException(Etichette.getEtichetta("Errore_valore_ora"), sezioneRedazione)
		}

		if ( !(OrarioUtils.isMinutoValido(obj.minutoAtto)) ){
			throw new ErroreOrarioRuntimeException(Etichette.getEtichetta("Errore_valore_minuti"), sezioneRedazione)
		}

		if (dvc.negozAssistitaMandatory && anscOn){
			if ( TestoUtils.isVuoto(obj.nomeAvvocato1) && TestoUtils.isVuoto(obj.cognomeAvvocato1) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati)
			}

			if ( TestoUtils.isVuoto(obj.nomeAvvocato2) && TestoUtils.isVuoto(obj.cognomeAvvocato2) ) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati)
			}

			if ( [ETipoAtto.MAT].contains(dvc.tipoAttoEnumSource) ){
				if (obj.ricezioneAttoAvvocati == null) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati)
				}
				// ansc103
				Boolean avv1Mandatory = ( (obj.ricezioneAttoAvvocati.compareTo(new Integer(1)) == 0) || (obj.ricezioneAttoAvvocati.compareTo(new Integer(3)) == 0) )
				if (avv1Mandatory && ( (obj.dataComunicazioneAvvocato1Accordo == null) || (obj.protocolloAvvocato1Accordo == null) ) ) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " - indicare i valori noti del protocollo e della data comunicazione")
				}
				// ansc103
				Boolean avv2Mandatory = ( (obj.ricezioneAttoAvvocati.compareTo(new Integer(2)) == 0) || (obj.ricezioneAttoAvvocati.compareTo(new Integer(3)) == 0) )
				if (avv2Mandatory && ( (obj.dataComunicazioneAvvocato2Accordo == null) || (obj.protocolloAvvocato2Accordo == null) ) ) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAvvocati + " - indicare i valori noti del protocollo e della data comunicazione")
				}
			}

			// https://github.com/italia/ansc/issues/377 (eliminato ente accordo)
			// https://github.com/italia/ansc/issues/150 (eliminata obbligatorietà numero/comune accordo)
			if ( (obj.dataAccordo == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAccordo)
			}

			// Solo divorzi (no scioglimenti)
			if ( [ETipoAtto.MAT].contains(dvc.tipoAttoEnumSource) ) {
				String sezioneAutoritaGiudiziaria = "'Redazione' - 'Provvedimento Autorità Giudiziaria'"

				if ((obj.tipoProvvedimentoAutoritaGiudiziaria == null) || (obj.dataAttoAutoritaGiudiziaria == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAutoritaGiudiziaria)
				}

				if ( (obj.comuneAutoritaGiudiziaria.codice == null) || (obj.comuneAutoritaGiudiziaria.codiceProvincia == null) ||
					 (obj.dataDepositoAutoritaGiudiziaria == null) || (obj.dataComunicazioneAvvocatiAutoritaGiudiziaria == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAutoritaGiudiziaria)
				}
			}

		}

		//////////////////////////// LUOGO CELEBRAZIONE ///////////////////////////

		String sezioneLuogoCelebrazione = "'Redazione' - 'Luogo Celebrazione'"

		if (dvc.luogoCelebrazioneMandatory && anscOn){
			if (TestoUtils.isVuoto(obj.luogoMatrimonio)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if (TestoUtils.isVuoto(obj.rito) || TestoUtils.isVuoto(obj.celebrante)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}
			/*
			//https://github.com/italia/ansc/issues/245
			if ( ( (obj.indirizzo?:"") == "") || ( (obj.civico?:"") == "") ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}
			*/
		}

		//////////////////////////// FCC MAT - UCI ///////////////////////////

		if (dvc.fuoriCasaComunaleMandatory && anscOn) {
			if (obj.flagCasaComunale == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if (TestoUtils.isVuoto(obj.luogoPvuUci) || TestoUtils.isVuoto(obj.indirizzo) || TestoUtils.isVuoto(obj.civico) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if (TestoUtils.isVuoto(obj.segretario) || TestoUtils.isVuoto(obj.impossibilitato) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if (TestoUtils.isVuoto(obj.certificato) || (obj.dataCertificato == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if ((obj.estremiCertificato == null)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}

			if ((obj.comuneCertificato.codice == null) || (obj.comuneCertificato.codiceProvincia == null)){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneLuogoCelebrazione)
			}
		}

		//////////////////////////// DATI ACCERTAMENTO ///////////////////////////

		String sezioneDatiAccertamento = "'Redazione' - 'Dati accertamento'"

		if (dvc.accertamentoMandatory && anscOn) {
			if (TestoUtils.isVuoto(obj.enteAccertamento) || TestoUtils.isVuoto(obj.estremiDocumentoAccertamento)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAccertamento)
			}
			if (!(ValidationUtils.isComuneAndDataFormazioneValid(obj.comuneAccertamento, obj.dataDocumentoAccertamento)) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAccertamento)
			}
		}

		//////////////////////////// RIASSUNTO DICHIARAZINE ///////////////////////////

		String sezioneAltriDati = "'Redazione' - 'Altri dati'"

		if (dvc.riassuntoMandatory && anscOn){
			if (TestoUtils.isVuoto(obj.testoRiassunto)){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAltriDati)
			}
		}

		//////////////////////////// AUTORITA GIUDIZIALE /////////////////////////////

		String sezioneDatiAtto = "'Dati Atto'"

		if (dvc.autoritaGiudizialeMandatory && anscOn){
			if (obj.flagGiudizioPendente && TestoUtils.isVuoto(obj.enteAutoritaGiudiziaria)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiAtto)
			}
		}

		//////////////////////////// OPPOSIZIONE MAT - UCI ///////////////////////////

		String sezioneOpposizione = "'Redazione' - 'Opposizione'"

		if ((obj.tipoDocumentoFineOpposizione != null) && anscOn) {
			if (TestoUtils.isVuoto(obj.enteFineOpposizione) || TestoUtils.isVuoto(obj.estremiDocumentoFineOpposizione)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneOpposizione)
			}
			if (!(ValidationUtils.isComuneAndDataFormazioneValid(obj.comuneFineOpposizione, obj.dataDocumentoFineOpposizione)) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneOpposizione)
			}
		}

		////////////////////////// RICHIESTA COSTITUZIONE UCI /////////////////////////

		if (dvc.certificatoRichiestaUciMandatory && anscOn) {
			String sezioneRichCost = "'Redazione' - 'Richiesta'"

			if ( (obj.comuneRichiestaCostituzione1.codice == null) || (obj.comuneRichiestaCostituzione1.codiceProvincia == null) || (obj.dataRichiestaCostituzione1 == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneRichCost)
			}
		}

		////////////////////////////////// CPD-UPD ////////////////////////////////

		if (dvc.provenienzaCpdMandatory && anscOn){
			String sezioneCpdProvenienza = "'Provenienza - Comune delegante'"

			if ( (obj.comuneProvenienza.codice == null) || (obj.comuneProvenienza.codiceProvincia == null) || (obj.dataNotaRif == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneCpdProvenienza)
			}
		}

        ////////////////////////////////// TEA ////////////////////////////////

        String sezioneTeaRichedente = "'Redazione - Autorita mittente'"

		if (dvc.richiedenteTeaMandatory && anscOn){
			if ( [ETipoAtto.NAS].contains(dvc.tipoAttoEnumSource) && !obj.flagInViaggio && (obj.dichiarazioneGiudiziale == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
			}
            if ( TestoUtils.isVuoto(obj.autorita) || (obj.comuneProvenienza.codice == null) || (obj.comuneProvenienza.codiceProvincia == null) ){
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
            }
			if ( dvc.consolatoMandatory && (obj.consolato == null) ){
				// refs #71624: nel caso delle cittadinanze, consolato obbligatorio solo per comuni prov esteri
				if ( [ETipoAtto.CIT].contains(dvc.tipoAttoEnumSource)){
					Boolean comuneProvEstero = gsdService.checkComuneEstero(obj.comuneProvenienza.codiceProvincia, obj.comuneProvenienza.codice)
					if (comuneProvEstero){
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
					}
				} else {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
				}
			}
			if (dvc.dataTrascrizioneMandatory && (obj.dataNotaRif == null)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
			}
			if (dvc.estremiTrascrizioneMandatory && (TestoUtils.isVuoto(obj.notaRif)) && (TestoUtils.isVuoto(obj.annoNotaRif))) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
			}
			// Per il momento solo UCI, se serve estendiamo controllo ad altri tipi di atto
			if ( [ETipoAtto.UCI].contains(dvc.tipoAttoEnumSource) &&  (obj.tipoRichiestaTrascrizione == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTeaRichedente)
			}
        }

		////////////////////////////////// TEP ////////////////////////////////

		String sezioneTepRichedente = "'Redazione - Dati Richiedente'"

		if (dvc.richiedenteTepMandatory && anscOn){
			if ( [ETipoAtto.NAS].contains(dvc.tipoAttoEnumSource) && ( (obj.dichiarazioneGiudiziale == null) || (TestoUtils.isVuoto(obj.tipoDichiarante)) ) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTepRichedente)
			}
			if ( [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI].contains(dvc.tipoAttoEnumSource)){
				if ( (obj.tipoRichiestaTrascrizione == null)){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTepRichedente)
				}
				if (dvc.firmatarioMandatory && TestoUtils.isVuoto(obj.tipoFirmatario)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTepRichedente)
				}
			}
			if (obj.dataRichiestaTrascrizione == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTepRichedente)
			}
		}


		////////////////////////////////// ENTE ESTERO ////////////////////////////////

		String sezioneAttoDaTrascrivere = "'Redazione - Atto da trascrivere'"

		if (dvc.attoDaTrascrivereMandatory && anscOn) {
			if (TestoUtils.isVuoto(obj.autoritaEnteStraniero) || (obj.dataAttoEnteStraniero == null) ||
					(obj.comuneEnteStraniero.codice == null) || (obj.comuneEnteStraniero.codiceProvincia == null)) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoDaTrascrivere)
			}
		}

		if (dvc.estremiAttoDaTrascrivereMandatory && anscOn) {
			if(TestoUtils.isVuoto(obj.estremiAttoEnteStraniero)){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAttoDaTrascrivere)
			}
		}

		////////////////////////////////// SENTENZA DIVORZIO ESTERO ////////////////////////////////

		String sezioneSentenza = "'Redazione - Sentenza'"
		if(dvc.dataPubblicazioneSentenzaMandatory && anscOn){
			if(obj.dataPubblicazioneSentenza == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneSentenza)
			}
		}

		//////////////////////////// ATTO NOTARILE ///////////////////////////

		//if ( attoNotarileMandatory && anscOn && [ETipoAtto.NAS].contains(dvc.tipoAttoEnumSource) && (obj.attoNotarile == ETipoSiNo.SI) ) {
		if ( ( dvc.attoNotarileMandatory || (obj.attoNotarile == ETipoSiNo.SI) ) && anscOn && [ETipoAtto.NAS].contains(dvc.tipoAttoEnumSource) ){
			String sezioneAN = "'Dati Atto Notarile'"
			if ( (obj.dataAttoNotarile == null) || (obj.comuneAttoNotarile.codice == null) || (obj.comuneAttoNotarile.codiceProvincia == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAN)
			}

			if( (!(obj.nomeEnteNotarile?.trim())) || (!(obj.estremiAttoNotarile?.trim())) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneAN)
			}
		}

		//////////////////////////// DICHIARANTE ///////////////////////////

		if ((dvc.tipoAttoEnumSource == ETipoAtto.NAS && dvc.dichiaranteMandatory) || (dvc.tipoAttoEnumSource == ETipoAtto.CIT && dvc.dichiaranteMandatory && anscOn)) {
			String sezioneDatiDichiarazione = "'Redazione - 'Dati Dichiarazione'"
			if (obj.comprensioneDichiarante == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
			} else {
				CivTipoComprensione tc = civTipoComprensioneService.get(obj.comprensioneDichiarante.id)
				if ( (tc.flagMotivazioneImpedimento) && ((obj.motivoImpedimentoDichiarante?:"") == "") ){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
				}
			}
		}

		//////////////////////////// TIPO LUOGO NASCITA ///////////////////////////

		if(dvc.tipoLuogoNascitaMandatory) {
			String sezioneDatiDichiarazione = "'Redazione - 'Altri dati' - 'Tipo luogo nascita'"
			if (obj.tipoLuogoNascita == null){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDatiDichiarazione)
			}
		}


		if ((dvc.tipoAttoEnumSource == ETipoAtto.MOR) && dvc.dichiaranteMandatory){
			String sezioneDichiaranteDecesso = "'Redazione' - 'Dati Dichiarante'"
			// Parte prima o parte seconda
			if ( (obj.parte.intValue() == 1) || ( (obj.parte.intValue() == 2) && ((obj.serie?:"") == CivTipoAtto.SERIE_A) ) ){
				if ( (!(obj.cognomeDichiarante?.trim())) && (!(obj.nomeDichiarante?.trim())) ){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
				}

				if ( (!(obj.cognomeDichiarante?.trim())) && (!(obj.senzaCognomeDichiarante)) ){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
				}

				if ( (!(obj.nomeDichiarante?.trim())) && (!(obj.senzaNomeDichiarante)) ){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
				}
				// Per Ansc refs #60743
				if (anscOn) {
					if (obj.sessoDichiarante == null) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}

					if (obj.dataNascitaDichiarante == null) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}

					if ((obj.comuneNascitaDichiarante.codice == null) || (obj.comuneNascitaDichiarante.codiceProvincia == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}

					if ((obj.comuneResidenzaDichiarante.codice == null) || (obj.comuneResidenzaDichiarante.codiceProvincia == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}

					if (obj.nazionalitaDichiarante == null) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}
				}

				if (obj.comprensioneDichiarante == null){
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
				} else {
					CivTipoComprensione tc = civTipoComprensioneService.get(obj.comprensioneDichiarante.id)
					if ( (tc.flagMotivazioneImpedimento) && ((obj.motivoImpedimentoDichiarante?:"") == "") ){
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneDichiaranteDecesso)
					}
				}
			}
		}
	}

	CivDatiProvenienzaAtto save (CivDatiProvenienzaAtto obj, DatiProvenienzaValidationCheck dvc){

		validaDati(obj, dvc)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj)
		}
		// refs #60743
		if (!(obj.comprensioneDichiarante?.flagMotivazioneImpedimento)) {
			obj.motivoImpedimentoDichiarante = null
		}
		// refs #61946
		if ( obj.attoNotarile == ETipoSiNo.NO ){
			obj.nomeEnteNotarile = null
			obj.comuneAttoNotarile.codice = null
			obj.comuneAttoNotarile.descrizione = null
			obj.comuneAttoNotarile.codiceProvincia = null
			obj.comuneAttoNotarile.siglaProvincia = null
			obj.estremiAttoNotarile = null
			obj.dataAttoNotarile = null
		}
		if (dvc.tipoAttoEnumSource.isMatrimonio()){
			// Ripulisco i campi in gioco
			// Se ho una separazione devo resettare gli estremi di provvedimento/accordo di separazione
			if (dvc.isUfficialeAccordo() && (obj.tipoDivorzio == ETipoDivorzio.X) && (obj.tipoProvvedimentoSeparazione == null) ){
				// cancello Estremi Provvedimento Separazione
				DomainUtils.cancellaEstremiProvvedimentoSeparazione(obj)
				// cancello Estremi Accordo Separazione
				if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
					DomainUtils.initDatiAccordoDivScioFromDivScioNuovaGestioneAnnotazione(obj, null)
				} else {
					DomainUtils.initDatiAccordoDivScioFromDivScio(obj, null)
				}
				obj.comuneAccordo = null
			}
			if ( (dvc.isUfficialeAltro() && obj.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAL()) ||
				 (dvc.isRiconciliazione() && obj.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaRCN()) ||
				 (dvc.isUfficialeAccordo() && obj.isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAC())){
				// cancello Estremi Provvedimento Separazione
				DomainUtils.cancellaEstremiProvvedimentoSeparazione(obj)
			}
			if ( (dvc.isUfficialeAltro() && obj.isSepDaProvvedimentoSeparazioneUAL()) ||
				 (dvc.isRiconciliazione() && obj.isSepDaProvvedimentoSeparazioneRCN()) ||
				 (dvc.isUfficialeAccordo() && obj.isSepDaProvvedimentoSeparazioneUAC())){
				// cancello Estremi Accordo Separazione
				if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
					DomainUtils.initDatiAccordoDivScioFromDivScioNuovaGestioneAnnotazione(obj, null)
				} else {
					DomainUtils.initDatiAccordoDivScioFromDivScio(obj, null)
				}
				obj.comuneAccordo = null
			}
		}
		if (dvc.tipoAttoEnumSource == ETipoAtto.CIT){
			if ( dvc.riconoscimento1Mandatory && (!(dvc.riconoscimento2Mandatory)) ){
				DomainUtils.cancellaEstremiAttoRiconoscimento2(obj)
			}
			if ( dvc.riconoscimento2Mandatory && (!(dvc.riconoscimento1Mandatory)) ){
				DomainUtils.cancellaEstremiAttoRiconoscimento1(obj)
			}
		}

		log.info("Lancio salvataggio su CIVDPA per id " + obj.id)
		return  civDatiProvenienzaAttoRepository.save(obj)
	}

}
