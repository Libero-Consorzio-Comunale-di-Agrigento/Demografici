package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum ETipoFamiglia {
    FAMIGLIA("F"),
    CONVIVENZA("C")

    String id

    ETipoFamiglia(String id) {
        this.id = id
    }

    static ETipoFamiglia valueOfId(String id) {
        ETipoFamiglia result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    Map getEtichettaDesc() {
        switch (this) {
            case FAMIGLIA: return Etichette.getEtichetta("Famiglia")
            case CONVIVENZA: return Etichette.getEtichetta("Convivenza")
        }
        return null
    }

    @Converter
    static class EnumTipoFamigliaToStringConverter implements AttributeConverter<ETipoFamiglia, String> {
        @Override
        String convertToDatabaseColumn(ETipoFamiglia ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ETipoFamiglia convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}