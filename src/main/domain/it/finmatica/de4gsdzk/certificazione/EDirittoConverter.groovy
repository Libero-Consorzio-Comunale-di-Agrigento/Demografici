package it.finmatica.de4gsdzk.certificazione

import javax.persistence.AttributeConverter
import javax.persistence.Converter

@Converter
class EDirittoConverter implements AttributeConverter<EDiritto, Integer> {
    @Override
    Integer convertToDatabaseColumn(EDiritto value) {
        return (value != null) ? value.id : null
    }

    @Override
    EDiritto convertToEntityAttribute(Integer value) {
        return EDiritto.fromId(value)
    }
}
