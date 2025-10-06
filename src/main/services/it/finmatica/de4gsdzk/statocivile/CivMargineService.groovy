package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.*
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivMargineService {

	private final StatoCivileService statoCivileService
	private final ArcParametroService arcParametroService
	private final CivMargineRepository civMargineRepository

	CivMargineService(CivMargineRepository civMargineRepository,
					  ArcParametroService arcParametroService,
					  StatoCivileService statoCivileService) {
		this.civMargineRepository = civMargineRepository
		this.arcParametroService = arcParametroService
		this.statoCivileService = statoCivileService
	}

	CivMargine getByUkAtto(String identificativoAtto) {
		return civMargineRepository.findByUkAtto(identificativoAtto)
	}

	CivMargine getOrCreateByUkAtto(CivAttoBaseDomain a) {
		CivMargine m = getByUkAtto(a.idAtto)
		if (!(m)){
			String tm = getMargineDefault(a, CivMargine.tipoMagineDS)
			ETipoMargineLaterale tipoMargineLaterale = (tm?ETipoMargineLaterale.valueOf(tm):null)
			m = new CivMargine(tipoMargineLaterale: tipoMargineLaterale)
		}
		return m
	}

	private void validaDati(CivMargine obj, ETipoAtto tipoAttoEnumSource,
							Boolean tipoMargineLateraleMandatory, Boolean sceltaConvenzioniMandatory, Boolean pubblicazioniMandatory){
		Boolean emptyMandatoryFields = Boolean.TRUE

		switch (tipoAttoEnumSource) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.UCI:
			case ETipoAtto.MOR: //Anche alto-basso solo nel formato A3
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) || (tipoMargineLateraleMandatory && obj.tipoMargineLaterale == null) )
				break
			case ETipoAtto.PUB:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
				break
			case ETipoAtto.CIT:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (tipoMargineLateraleMandatory && obj.tipoMargineLaterale == null) )
				break
		}

		if (emptyMandatoryFields){
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_margine)
		}

		/////////////////////// CONVENZIONI ///////////////////////////

		if (sceltaConvenzioniMandatory) {
			if (obj.sceltaConvenzioni == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_convenzioni_patrimoniali)
			}
			if ((obj.sceltaConvenzioni.intValue() == 2) && TestoUtils.isVuoto(obj.leggeConvenzioni)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_convenzioni_patrimoniali)
			}
			if (TestoUtils.checkAcapo(obj?.leggeConvenzioni)) {
				throw new ErroreDatiAttoRuntimeException(EtichetteMessaggi.Errore_carattere_a_capo_non_ammesso, "(Legge Convenzioni)")
			}
		}

		///////////////////////////////////////////////////////////

		String sezione1 = ( ( (tipoAttoEnumSource == ETipoAtto.MOR) )?"( Estremi Atto di nascita deceduto )":"( Estremi Atto di nascita intestatario )" )

		if (arcParametroService.isNuovaGestioneAnnotazioniSuAttoAttiva()) {
			EstremiAtto estremiAtto = new EstremiAtto(ufficio: obj.ufficioAttoNascita1,
					atto: obj.attoAttoNascita1,
					anno: obj.annoAttoNascita1,
					parte: obj.parteAttoNascita1,
					serie: obj.serieAttoNascita1)
			DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS, estremiAtto, false, false)
			ValidationUtils.validaEstremiAtto(dve, sezione1)
		} else {
			if ((obj.serieAttoNascita1 ?: "") != "") {
				Boolean serie1Ok = TipoAttoUtils.isSerieOk(ETipoAtto.NAS, obj.serieAttoNascita1)
				if (!(serie1Ok)) {
					throw new ErroreValoreParteSerieException(EtichetteMessaggi.Errore_serie, sezione1)
				}
			}

			if ((obj.parteAttoNascita1String ?: "") != "") {
				try {
					Integer p1 = obj.parteAttoNascita1
					Boolean p1Ok = TipoAttoUtils.isParteOk(ETipoAtto.NAS, p1)
					if (!(p1Ok)) {
						throw new ErroreValoreParteSerieException(EtichetteMessaggi.Errore_parte, sezione1)
					}
				} catch (NumberFormatException nfe) {
					throw new ErroreValoreParteSerieException(EtichetteMessaggi.Errore_parte, sezione1)
				}
			}

			Boolean isAtto1Ok = ((obj.getAttoAttoNascita1() == null) || (obj.getAttoAttoNascita1().compareTo(new Integer(1000000)) < 0))
			if (!(isAtto1Ok)) {
				throw new ErroreLunghezzaCampiRuntimeException("Atto nella sezione " + sezione1)
			}
		}

		if (pubblicazioniMandatory){
			String sezioneDatiPubblicazione = "'Dati Pubblicazione'"
			if (obj.documentoPresentatoMatrimonio == null){
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiPubblicazione)
			}
			switch(obj.documentoPresentatoMatrimonio){
				case EDocumentoMatrimonio.UNO:
					if ( (obj.comuneAffissione1?.codice == null ) || (obj.comuneAffissione1?.codiceProvincia == null) || (obj.dataAffissioneDa1 == null) || (obj.dataAffissioneA1 == null) ){
						throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiPubblicazione)
					}
					break
				case EDocumentoMatrimonio.DUE:
					if ( (obj.comuneAffissione1?.codice == null ) || (obj.comuneAffissione1?.codiceProvincia == null) || (obj.dataAffissioneDa1 == null) || (obj.dataAffissioneA1 == null) ||
						 (obj.comuneAffissione2?.codice == null ) || (obj.comuneAffissione2?.codiceProvincia == null) ){
						throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezioneDatiPubblicazione)
					}
					break
			}
		}
	}

	CivMargine save (CivMargine obj, ETipoAtto tipoAttoEnumSource,
					 Boolean tipoMargineLateraleMandatory=Boolean.TRUE, Boolean sceltaConvenzioniMandatory=Boolean.FALSE, Boolean pubblicazioniMandatory=Boolean.FALSE){

		validaDati(obj, tipoAttoEnumSource, tipoMargineLateraleMandatory, sceltaConvenzioniMandatory, pubblicazioniMandatory)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVMAR per id " + obj.id)
		CivMargine saved = civMargineRepository.save(obj)
		return saved
	}

    String getGestioneMargine(CivAttoBaseDomain obj){
        ETipoAtto ta = obj.getTipoAttoEnum()
        if ((ta == null) || (obj.atto == null)) {
            throw new De4gsdzkRuntimeException("Impossibile recuperare il valore del parametro associato alla gestione del margine per l'atto corrente}")
        }
        StringBuilder parametro = new StringBuilder("ATTI_")
        parametro.append(ta.name())
        parametro.append( (obj.parte?.toString()?:"") )
        if ((ta == ETipoAtto.MOR) && ( ((CivMorte)obj).isSecondaBBis()) ) {
            parametro.append(CivTipoAtto.SERIE_C)
        } else {
            parametro.append( (obj.serie?:"") )
            if ((ta == ETipoAtto.NAS) && ( (((CivNascita)obj).serie?:"") == "") ) {
                parametro.append(CivTipoAtto.SERIE_A)
            }
        }
        String mDef
        try{
            mDef = (statoCivileService.getValoreParametro(parametro.toString(), 4)?:"").trim()
        } catch (De4gsdzkRuntimeException ex){
            throw new De4gsdzkRuntimeException("Impossibile recuperare il valore del parametro ${parametro.toString()}")
        }
        return mDef
    }

	ETipoMargineLaterale getMargineLateraleDefault(CivAttoBaseDomain obj){
		String tm = getMargineDefault(obj, CivMargine.tipoMagineDS)
		ETipoMargineLaterale tml = (tm?ETipoMargineLaterale.valueOf(tm):null)
		return tml
	}

    String getMargineDefault(CivAttoBaseDomain obj, String tipo=CivMargine.tipoMagineDS){
        ETipoAtto ta = obj.getTipoAttoEnum()
        String mDef = getGestioneMargine(obj)
        String tipoMargine = null
		switch (ta) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.UCI:
			case ETipoAtto.CIT:
			case ETipoAtto.MOR:
				Boolean attivaFormatoA3 = Boolean.FALSE
				/*
				Partiamo con il formato A4 dunque mi risparmio la query SU ArcParametro.ATTI_A3
				*/
				if (attivaFormatoA3) {
					if (obj.isSecondaB()) {
						int k = 0
						while (((obj.atto.intValue() - 1 - k) % 4) != 0) {
							k++
						}
						if (k == 0) {
							if (mDef == CivMargine.S) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.S1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.INV) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.INV1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.B)
							}
						} else if (k == 1) {
							if (mDef == CivMargine.S) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.S1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.INV) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.INV1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.A)
							}
						} else if (k == 2) {
							if (mDef == CivMargine.S) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.S1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.INV) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.INV1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.B)
							}
						} else if (k == 3) {
							if (mDef == CivMargine.S) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.S1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.A)
							}
							if (mDef == CivMargine.INV) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.S.name() : ETipoMargineIntestazione.B)
							}
							if (mDef == CivMargine.INV1) {
								tipoMargine = ((tipo == CivMargine.tipoMagineDS) ? ETipoMargineLaterale.D.name() : ETipoMargineIntestazione.A)
							}
						}
					}
				} else {
					// Formato A4
					if (tipo == CivMargine.tipoMagineDS){
						if ( (mDef == CivMargine.S) || (mDef == CivMargine.S1) ){
							tipoMargine = ((obj.atto.intValue() % 2 == 0)?ETipoMargineLaterale.D.name(): ETipoMargineLaterale.S.name())
						} else if ( (mDef == CivMargine.INV) || (mDef == CivMargine.INV1) ) {
							tipoMargine = ((obj.atto.intValue() % 2 == 0)?ETipoMargineLaterale.S.name(): ETipoMargineLaterale.D.name())
						}
					}
				}
				break
		}
		return tipoMargine
	}

}
