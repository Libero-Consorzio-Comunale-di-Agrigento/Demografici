package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EStatoIndirizzo {

    OCCUPATO("Occupato"),
    LIBERO("Libero"),
    IN_CANCELLAZIONE("In Cancellazione"),
    PRENOTATO("Prenotato")

    String id

    EStatoIndirizzo(String id) {
        this.id = id
    }

    static EStatoIndirizzo valueOfId(String id) {
        EStatoIndirizzo result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    Map getEtichettaDesc() {
        switch (this) {
            case OCCUPATO: return Etichette.getEtichetta("Occupato")
            case LIBERO: return Etichette.getEtichetta("Libero")
            case IN_CANCELLAZIONE: return Etichette.getEtichetta("In_Cancellazione")
            case PRENOTATO: return Etichette.getEtichetta("Prenotato")
        }
        return null
    }

    @Converter
    static class EnumStatoIndirizzoToStringConverter implements AttributeConverter<EStatoIndirizzo, String> {
        @Override
        String convertToDatabaseColumn(EStatoIndirizzo ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        EStatoIndirizzo convertToEntityAttribute(String value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}
