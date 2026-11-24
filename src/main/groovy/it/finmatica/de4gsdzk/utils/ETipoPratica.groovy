package it.finmatica.de4gsdzk.utils

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum ETipoPratica {

    ISC("I"),
    CANC("C"),
    VAR("E"),
    RET("R")

    final String id

    private ETipoPratica(String id) {
        this.id = id
    }

    static ETipoPratica valueOfId(String id) {
        ETipoPratica result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    Map getEtichettaDesc(){
        switch(this) {
            case ISC: return Etichette.getEtichetta("Iscrizione")
            case CANC: return Etichette.getEtichetta("Cancellazione")
            case VAR: return Etichette.getEtichetta("Variazione")
            case RET: return Etichette.getEtichetta("Rettifica")
        }
        return null

    }

    @Converter
    static class EnumTipoPraticaToStringConverter implements AttributeConverter<ETipoPratica, String> {
        @Override
        String convertToDatabaseColumn(ETipoPratica ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ETipoPratica convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }
}
