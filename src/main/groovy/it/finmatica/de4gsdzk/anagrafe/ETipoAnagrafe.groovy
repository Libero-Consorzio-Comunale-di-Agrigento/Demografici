package it.finmatica.de4gsdzk.anagrafe

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum ETipoAnagrafe {
    RESIDENTI("RES"),
    NON_RESIDENTI("NRE"),
    AIRE("AIR")

    final String id

    ETipoAnagrafe(String id) {
        this.id = id
    }

    static ETipoAnagrafe valueOfId(String id) {
        ETipoAnagrafe result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumTipoAnagrafeToStringConverter implements AttributeConverter<ETipoAnagrafe, String> {
        @Override
        String convertToDatabaseColumn(ETipoAnagrafe ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ETipoAnagrafe convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}
