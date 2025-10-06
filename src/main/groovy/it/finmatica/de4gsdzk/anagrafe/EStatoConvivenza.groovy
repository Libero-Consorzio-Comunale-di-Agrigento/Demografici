package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EStatoConvivenza {
    ANNULLATA("A"),
    DICHIARATA("D"),
    CESSATA("F"),
    ATTIVA("I")

    final String id

    EStatoConvivenza(String id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case ANNULLATA: return Etichette.Annullato
            case DICHIARATA: return Etichette.Dichiarata
            case CESSATA: return Etichette.Cessata
            case ATTIVA: return Etichette.Attiva
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