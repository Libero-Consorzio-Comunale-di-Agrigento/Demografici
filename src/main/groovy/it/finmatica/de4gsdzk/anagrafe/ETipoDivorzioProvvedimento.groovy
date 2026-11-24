package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum ETipoDivorzioProvvedimento {

    CESSAZIONE("C"),
    SCIOGLIMENTO("S"),
    SEPARAZIONE("X"),
    ANNULLAMENTO("A"),
    NULLITA("N"),
    DELIBAZIONE("D")

    final String id

    private ETipoDivorzioProvvedimento(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch(this) {
            case CESSAZIONE: return Etichette.getEtichetta("Cessazione")
            case SCIOGLIMENTO: return Etichette.getEtichetta("Scioglimento")
            case SEPARAZIONE: return Etichette.getEtichetta("Separazione")
            case ANNULLAMENTO: return Etichette.getEtichetta("Annullamento")
            case NULLITA: return Etichette.getEtichetta("Nullita")
            case DELIBAZIONE: return Etichette.getEtichetta("Delibazione")
        }
        return null
    }

    static ETipoDivorzioProvvedimento valueOfId(String id) {
        ETipoDivorzioProvvedimento result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido per ETipoDivorzioProvvedimento")
        }
        return result
    }

    @Converter
    static class EnumTipoDivorzioProvvedimentoToStringConverter implements AttributeConverter<ETipoDivorzioProvvedimento, String> {
        @Override
        String convertToDatabaseColumn(ETipoDivorzioProvvedimento ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ETipoDivorzioProvvedimento convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }
}
