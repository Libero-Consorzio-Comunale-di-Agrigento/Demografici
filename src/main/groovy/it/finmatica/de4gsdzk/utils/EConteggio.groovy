package it.finmatica.de4gsdzk.utils

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EConteggio {

    COMPORTA(1),
    NON_COMPORTA(2)

    final Integer id

    private EConteggio(Integer id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case COMPORTA: return Etichette.getEtichetta("Comporta")
            case NON_COMPORTA: return Etichette.getEtichetta("Non_Comporta")
        }
        return null
    }

    static EConteggio valueOfId(Integer id) {
        EConteggio result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumConteggioToIntegerConverter implements AttributeConverter<EConteggio, Integer> {
        @Override
        Integer convertToDatabaseColumn(EConteggio ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        EConteggio convertToEntityAttribute(Integer value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}