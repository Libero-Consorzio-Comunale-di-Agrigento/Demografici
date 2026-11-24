package it.finmatica.de4gsdzk.certificazione.error

import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette

class CertificatoAnnullatoException extends De4gsdzkRuntimeException {

    private static final Map<String, String> etichettaDefault = Etichette.getEtichetta("Errore_Certificazioni_certificato_annullato")

    CertificatoAnnullatoException() {
        this('')
    }

    CertificatoAnnullatoException(String additionalInfo) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo ?: "")))
    }
}
