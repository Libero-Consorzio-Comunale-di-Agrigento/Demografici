package it.finmatica.de4gsdzk.certificazione.error

import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.EDiritto
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class CategoriaGiaAssociataADirittoRuntimeException extends De4gsdzkRuntimeException {
    private static final Map<String, String> etichettaDefault = EtichetteMessaggi.Errore_Tariffa_diritto_associata_a_categoria

    CerCategoriaTipoCertificato categoria
    EDiritto diritto

    CategoriaGiaAssociataADirittoRuntimeException(CerCategoriaTipoCertificato categoria, EDiritto diritto) {
        super(etichettaDefault, String.format(etichettaDefault.defaultValue, "${categoria?.descrizione}", "${diritto?.id} - ${diritto?.getEtichettaDesc()?.defaultValue}"))
        this.categoria = categoria
        this.diritto = diritto
    }
}
