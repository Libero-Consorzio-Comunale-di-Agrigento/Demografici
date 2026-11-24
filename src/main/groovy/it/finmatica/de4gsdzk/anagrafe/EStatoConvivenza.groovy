package it.finmatica.de4gsdzk.anagrafe

enum EStatoConvivenza {

    DICHIARATA("D"),
    ATTIVA("I"),
    CESSATA("F"),
    ANNULLATA("A")

    final String id

    EStatoConvivenza(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case ANNULLATA: return Etichette.getEtichetta("Annullato")
            case DICHIARATA: return Etichette.getEtichetta("Dichiarata")
            case CESSATA: return Etichette.getEtichetta("Cessata")
            case ATTIVA: return Etichette.getEtichetta("Attiva")
        }
        return null
    }

    static EStatoConvivenza valueOfId(String id) {
        EStatoConvivenza result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumStatoConvivenzaToStringConverter implements AttributeConverter<EStatoConvivenza, String> {
        @Override
        String convertToDatabaseColumn(EStatoConvivenza ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        EStatoConvivenza convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }
}

import it.finmatica.de4gsdzk.utils.Etichette
import javax.persistence.AttributeConverter

import javax.persistence.Converter
