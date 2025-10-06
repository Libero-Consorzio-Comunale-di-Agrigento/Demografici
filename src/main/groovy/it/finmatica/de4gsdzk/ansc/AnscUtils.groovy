package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAtto
import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoContenutoAnsc
import it.finmatica.de4gsdzk.utils.ETipoFirmaAnsc
import it.finmatica.de4gsdzk.utils.ETipologiaAnsc

class AnscUtils {

	static final String KEYSTORE_TYPE    		= "PKCS12"
	static final String ALGORITHM_TYPE   		= "RS256"
	static final String HEADER_JWT_TYPE  		= "JWT"
	static final String HEADER_JWS_TYPE  		= "JWS"
	static final String HEADER_JWS_FULL_TYPE  	= "JWS_FULL"

	static final String X5C_PROPERTY     = "x5c"
	static final int TOKEN_DURATION      = 300
	static final int SCARTO_IAT      	 = 60

	static final int OTP_DURATION      = 239

	static final String parametroFirma1 		= "inputFirma1"
	static final String parametroFirma2 		= "inputFirma2"
	static final String parametroFirma3 		= "inputFirma3"
	static final String parametroIdOperazione 	= "idOperazione"
	static final String parametroIdRif 			= "idRif"
	static final String parametroPkAtto 		= "pkAtto"

	static final String parametroDataInizioRicercaNot     	= "dataInizioRicercaNot"
	static final String parametroDataFineRicercaNot     	= "dataFineRicercaNot"
    static final String parametroIdTipoEventoRicercaNot     = "idTipoEventoRicercaNot"
	static final String parametroIdGenereRicercaNot 		= "idGenereRicercaNot"
	static final String parametroIdStatoFlussoRicercaNot 	= "idStatoFlussoRicercaNot"
	static final String parametroIdTipoContenutoRicercaNot 	= "idTipoContenutoRicercaNot"
	static final String parametroNumPaginaRicercaNot 		= "numPaginaRicercaNot"
	static final String parametroNumRecordPaginaRicercaNot 	= "numRecordPaginaRicercaNot"
	static final String parametroNumRecordTotaliRicercaNot 	= "numRecordTotaliRicercaNot"
	static final String parametroIdAnscRicercaEve 			= "idAnscRicercaEve"

	static ETipoContenutoAnsc fromValoreTipoContenuto(Integer idTipoContenuto) {
		ETipoContenutoAnsc tipoContenutoAnsc = null
		if (idTipoContenuto != null){
			for (ETipoContenutoAnsc tc : ETipoContenutoAnsc.values()) {
				if (tc.valore == new Integer(idTipoContenuto)) {
					tipoContenutoAnsc = tc
					break
				}
			}
		}
		return tipoContenutoAnsc
	}

	static ETipologiaAnsc fromValoreTipologia(Integer idTipologia) {
		ETipologiaAnsc tipologiaAnsc = null
		if (idTipologia != null){
			for (ETipologiaAnsc tc : ETipologiaAnsc.values()) {
				if (tc.valore == new Integer(idTipologia)) {
					tipologiaAnsc = tc
					break
				}
			}
		}
		return tipologiaAnsc
	}

	static String getTipoDocumentoCdu(CivAttoBaseDomain atto, CivDatiProvenienzaAtto datiProvenienza){
		if (((IAttoAnsc)atto).isTrascrizioneEsteroDaPrivato()){
			// 07/05/2024: Recupero retrocompatibilità per adeguamento a nuove specifiche ANSC nel metodo del service che estrae i servizi per cdu
			return datiProvenienza?.tipoRichiestaTrascrizione?.name()
		} else {
			String tipoDocumento = null
			switch (atto.getTipoAttoEnum()) {
				case ETipoAtto.NAS:
					if (datiProvenienza.flagInViaggio ) {
						tipoDocumento = datiProvenienza?.tipoLuogoNascita?.name()
					} else {
						tipoDocumento = datiProvenienza?.tipoAccertamento?.name()
					}
					break
				case ETipoAtto.MAT:
					if (atto instanceof CivMatrimonio && (atto.isAvvocati() || atto.isAvvocatiAltro()) ){
						tipoDocumento = datiProvenienza?.tipoProvvedimentoAutoritaGiudiziaria?.name()
					}
					break
				case ETipoAtto.MOR:
					tipoDocumento = datiProvenienza?.tipoTrasmissione?.name()
					break
			}
			return tipoDocumento
		}
	}

	// per la gestione della dipendenza in sequenza dei servizi
	static String getTipoEventoCdu(List<CivFirmatarioAtto> lFirmatari, Boolean isAttoDaAttestareAnsc){
		// cambio gestione per firma digitale/firma cartacea!
		// refs #66892
		/*if (TestoUtils.isVuoto(datiProvenienza.tipoFirmatario)) {
            return ETipoDichiaranteNascita.NE.name()
        }*/
		String tipoEvento = ""
		if (lFirmatari.isEmpty()){
			// 07/05/2024: Recupero retrocompatibilità per adeguamento a nuove specifiche ANSC nel metodo del service che estrae i servizi per cdu
			// Sono sicura che la codifica NE ci sia negli enum del tipo dichiarante di tutti gli atti
			tipoEvento += "NE"
			if (isAttoDaAttestareAnsc){
				tipoEvento += "AL"
			}
		} else {
			Boolean firmaCartacea = Boolean.FALSE
			Boolean firmaDigitale = Boolean.FALSE
			for (CivFirmatarioAtto f:lFirmatari){
				if (f.tipoFirma == ETipoFirmaAnsc.CA){
					firmaCartacea = Boolean.TRUE
				}
				if (f.tipoFirma == ETipoFirmaAnsc.EL){
					firmaDigitale = Boolean.TRUE
				}
			}
			if (firmaCartacea){
				tipoEvento += ETipoFirmaAnsc.CA.name()
			}
			if (firmaDigitale){
				tipoEvento += ETipoFirmaAnsc.EL.name()
			}
		}
		return tipoEvento
	}

}

