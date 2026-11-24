package it.finmatica.de4gsdzk.anagrafe.pratiche

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum ETipoArchivioDizionario {

    INIZIATIVA("INI"),
    RICHIESTA("RIC"),
    PROVVEDIMENTO("PRO"),
    MOTIVO("MOT")

    final String id

    ETipoArchivioDizionario(String id) {
        this.id = id
    }

    static ETipoArchivioDizionario valueOfId(String id) {
        ETipoArchivioDizionario result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumTipoArchivioDizionarioToStringConverter implements AttributeConverter<ETipoArchivioDizionario, String> {
        @Override
        String convertToDatabaseColumn(ETipoArchivioDizionario ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ETipoArchivioDizionario convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}