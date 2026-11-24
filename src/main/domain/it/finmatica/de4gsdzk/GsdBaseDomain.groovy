package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.DomainUtils

import javax.persistence.AttributeConverter
import javax.persistence.Converter
import javax.persistence.MappedSuperclass

@MappedSuperclass
abstract class GsdBaseDomain {

    abstract Object getId()

    String getTableName() {
        return DomainUtils.getTableName(this)
    }

    @Converter
    static class BooleanToStringConverter implements AttributeConverter<Boolean, String> {
        @Override String convertToDatabaseColumn(Boolean value) {
            return (value != null && value) ? "S" : null
        }
        @Override Boolean convertToEntityAttribute(String value) {
            return "S".equals(value)
        }
    }

    @Converter
    static class BooleanToIntegerConverter implements AttributeConverter<Boolean, Integer> {
        @Override Integer convertToDatabaseColumn(Boolean value) {
            return (value != null && value) ? 1 : null
        }
        @Override Boolean convertToEntityAttribute(Integer value) {
            return value == 1
        }
    }

}
