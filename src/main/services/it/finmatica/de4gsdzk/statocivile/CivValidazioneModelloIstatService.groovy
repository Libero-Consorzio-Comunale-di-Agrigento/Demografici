package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IstBaseDomain
import it.finmatica.de4gsdzk.IstMscMsuBaseDomain
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiAttoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivValidazioneModelloIstatService {

	void checkEstremiAtto(IstBaseDomain obj){
		Boolean emptyMandatoryFields = Boolean.TRUE

		ETipoAtto tipoAttoEnum = obj.getTipoAttoEnum()
		switch (tipoAttoEnum) {
			case ETipoAtto.NAS:
			case ETipoAtto.PUB:
			case ETipoAtto.MAT:
			case ETipoAtto.UCI:
			case ETipoAtto.MOR:
				emptyMandatoryFields = ( (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null))
				break
			case ETipoAtto.PVU:
				emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null))
				break
		}

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}
	}

	void checkChiusuraProvvisorio(IstBaseDomain obj){
		if (obj.flagCompleto && (obj.atto != null) ){
			if (obj.atto.compareTo(new Integer(0)) < 0){
				throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_ISTAT_chiusura_atto_provvisorio"))
			}
		}
	}

	void checkDatiProvvedimento(IstMscMsuBaseDomain obj) {
		if (obj.isProvvedimento()){
			if ( (obj.tipoProcedura == null) ||
				 (obj.comuneTribCda?.codice == null) || (obj.comuneTribCda?.codiceProvincia == null) || (obj.dataProvvedimento == null) ||
				 (obj.tipoProvvedimentoTribCda == null) ){
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_modello_istat"))
			}
		}
	}

}
