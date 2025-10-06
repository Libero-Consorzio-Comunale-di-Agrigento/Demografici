package it.finmatica.de4gsdzk.errors

import it.finmatica.de4gsdzk.utils.EtichetteMessaggi

class NumeroProtocolloException extends De4gsdzkRuntimeException {

    private static final Map etichettaDefault = EtichetteMessaggi.Errore_Numero_Protocollo
    private int numero

    /** Lista di entity dove il numero protocollo è stato trovato */
    private List entities

    NumeroProtocolloException(Integer nr, String additionalInfo="", List entities=[]) {
        super(etichettaDefault, additionalInfo, (etichettaDefault.defaultValue + " " + (additionalInfo?:"")))
        this.numero = nr
        this.entities = entities
    }

    int getNumero() { numero }
    List getEntities() { entities }

    @Override
    String toString() {
        return super.toString() + " numero " + numero + " presente in: " + entities
    }
}
