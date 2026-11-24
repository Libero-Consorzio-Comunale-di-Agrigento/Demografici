package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreLunghezzaCampiRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreValoreParteSerieException
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivSposiAttoService {

	private final GsdService gsdService

	private final ArcParametroService arcParametroService

	private final CivSposiAttoRepository civSposiAttoRepository

    CivSposiAttoService(CivSposiAttoRepository civSposiAttoRepository,
                        GsdService gsdService, ArcParametroService arcParametroService) {

		this.civSposiAttoRepository = civSposiAttoRepository
		this.gsdService = gsdService
		this.arcParametroService = arcParametroService
	}

	CivSposiAtto getByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		return civSposiAttoRepository.findByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
	}

	CivSposiAtto getOrCreateByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		CivSposiAtto m = getByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
		if (!(m)){
			m = new CivSposiAtto(tipoAtto: tipoAtto)
		}
		return m
	}

	private void validaDati(CivSposiAtto obj, ETipoAtto tipoAttoEnumSource, Boolean divorzio,
							Boolean estremiAttoMatUciMandatory, Boolean datiMatUciMandatory){
		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		////////////////////////// ESTREMI ATTO /////////////////////////

		Boolean emptyMandatoryFields = Boolean.TRUE
		if ([ETipoAtto.PUB, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.PVU].contains(tipoAttoEnumSource)){
			emptyMandatoryFields = TipoAttoUtils.isEstremiAttoEmpty(obj, tipoAttoEnumSource)
		}
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}

		String sezione1 = ( ( (tipoAttoEnumSource == ETipoAtto.UCI) || (tipoAttoEnumSource == ETipoAtto.PVU) )?"( Estremi Atto di nascita contraente 1 )":"( Estremi Atto di nascita sposo )" )

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAttoNascita1,
					atto: obj.attoAttoNascita1,
					anno: obj.annoAttoNascita1,
					parte: obj.parteAttoNascita1,
					serie: obj.serieAttoNascita1,
					idAttoAnsc: obj.idAttoAnscNascita1)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS, estremiAtto, false, false)
			ValidationUtils.validaEstremiAtto(dve, sezione1)
		} else {
			Boolean serie1Ok = TipoAttoUtils.isSerieOk(ETipoAtto.NAS, obj.serieAttoNascita1)
			if (!(serie1Ok)) {
				throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), sezione1)
			}

			if ((obj.parteAttoNascita1String ?: "") != "") {
				try {
					Integer p1 = obj.parteAttoNascita1
					Boolean p1Ok = TipoAttoUtils.isParteOk(ETipoAtto.NAS, p1)
					if (!(p1Ok)) {
						throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezione1)
					}
				} catch (NumberFormatException nfe) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezione1)
				}
			}

			Boolean isAtto1Ok = ((obj.getAttoAttoNascita1() == null) || (obj.getAttoAttoNascita1().compareTo(new Integer(10000)) < 0))
			if (!(isAtto1Ok)) {
				throw new ErroreLunghezzaCampiRuntimeException("Atto nella sezione " + sezione1)
			}
		}

        String sezione2 = ( ( (tipoAttoEnumSource == ETipoAtto.UCI) || (tipoAttoEnumSource == ETipoAtto.PVU) )?"( Estremi Atto di nascita contraente 2 )":"( Estremi Atto di nascita sposa )" )

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAttoNascita2,
					atto: obj.attoAttoNascita2,
					anno: obj.annoAttoNascita2,
					parte: obj.parteAttoNascita2,
					serie: obj.serieAttoNascita2,
					idAttoAnsc: obj.idAttoAnscNascita2)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS, estremiAtto, false, false)
			ValidationUtils.validaEstremiAtto(dve, sezione2)
		} else {
			Boolean serie2Ok = TipoAttoUtils.isSerieOk(ETipoAtto.NAS, obj.serieAttoNascita2)
			if (!(serie2Ok)) {
				throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), sezione2)
			}

			if ( (obj.parteAttoNascita2String?:"") != "") {
				try {
					Integer p2 = obj.parteAttoNascita2
					Boolean p2Ok = TipoAttoUtils.isParteOk(ETipoAtto.NAS, p2)
					if (!(p2Ok)) {
						throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezione2)
					}
				} catch (NumberFormatException nfe) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezione2)
				}
			}

			Boolean isAtto2Ok = ( (obj.getAttoAttoNascita2() == null) || (obj.getAttoAttoNascita2().compareTo(new Integer (10000)) <  0) )
			if (!(isAtto2Ok)) {
				throw new ErroreLunghezzaCampiRuntimeException("Atto nella sezione " + sezione2)
			}
		}

		if (divorzio && ( (tipoAttoEnumSource == ETipoAtto.MAT) || (tipoAttoEnumSource == ETipoAtto.UCI) ) ) {
			String sezioneM = ((tipoAttoEnumSource == ETipoAtto.UCI) ? "( Estremi Atto di unione civile )" : "( Estremi Atto di matrimonio )")
			if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
				EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAttoMatrimonio,
						anno: obj.annoAttoMatrimonio,
						atto: obj.attoAttoMatrimonio,
						parte: obj.parteAttoMatrimonio,
						serie: obj.serieAttoMatrimonio,
						idAttoAnsc: obj.idAttoAnscMatrimonio)
				DatiValidazioneEstremi datiValidazioneEstremi = new DatiValidazioneEstremi(tipoAttoEnumSource, estremiAtto, estremiAttoMatUciMandatory && anscOn, false)
				DatiValidazioneComune datiValidazioneComune = new DatiValidazioneComune(obj.codiceComuneAttoMatrimonio, obj.codiceProvinciaAttoMatrimonio, estremiAttoMatUciMandatory && anscOn)
				DatiValidazioneDataAtto datiValidazioneDataAtto = new DatiValidazioneDataAtto(obj.dataAttoMatrimonio, estremiAttoMatUciMandatory && anscOn)
				ValidationUtils.validaEstremiAtto(datiValidazioneEstremi, sezioneM)
				ValidationUtils.validaEstremiAttoComune(datiValidazioneComune, sezioneM)
				ValidationUtils.validaEstremiAttoData(datiValidazioneDataAtto, sezioneM)
			} else {
				if ((tipoAttoEnumSource == ETipoAtto.MAT)) {
					Boolean serieMOk = TipoAttoUtils.isSerieOk(ETipoAtto.MAT, obj.serieAttoMatrimonio)
					if (!(serieMOk)) {
						throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_serie"), sezioneM)
					}
				}
				try {
					Integer pM = obj.parteAttoMatrimonio
					Boolean pMOk = TipoAttoUtils.isParteOk(tipoAttoEnumSource, pM)
					if (!(pMOk)) {
						throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezioneM)
					}
				} catch (NumberFormatException nfe) {
					throw new ErroreValoreParteSerieException(Etichette.getEtichetta("Errore_parte"), sezioneM)
				}

				if (estremiAttoMatUciMandatory && anscOn) {
					if ((obj.codiceComuneAttoMatrimonio == null) || (obj.codiceProvinciaAttoMatrimonio == null)) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneM)
					}
					if (TestoUtils.isVuoto(obj.idAttoAnscMatrimonio) && ((obj.annoAttoMatrimonio == null) || (obj.attoAttoMatrimonio == null))) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneM)
					}
					if (obj.dataAttoMatrimonio == null) {
						throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneM)
					}
				}
			}

			if (datiMatUciMandatory && anscOn) {
				if ((obj.dataMatrimonio == null) || TestoUtils.isVuoto(obj.officiante) ||
						(obj.comuneMatrimonio.codice == null) || (obj.comuneMatrimonio.codiceProvincia == null)) {
					throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneM)
				}
			}
		}
	}

	CivSposiAtto save (CivSposiAtto obj, ETipoAtto tipoAttoEnumSource, Boolean divorzio=Boolean.FALSE,
					   Boolean estremiAttoMatUciMandatory=Boolean.FALSE, Boolean datiMatUciMandatory=Boolean.FALSE){

		validaDati(obj, tipoAttoEnumSource, divorzio, estremiAttoMatUciMandatory, datiMatUciMandatory)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVSPO per id " + obj.id)
		return  civSposiAttoRepository.save(obj)
	}

}
