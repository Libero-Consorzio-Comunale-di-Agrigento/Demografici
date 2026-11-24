package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EFascia {
    ISCRITTO_APR(1),
    CANCELLATO_APR(2),
    ISCRITTO_AIRE(3),
    CANCELLATO_AIRE(4),
    ISCRIZIONE_ATTESA_O_ANNULLATA(5),
    NON_RESIDENTE(6),

    final Integer id

    EFascia(Integer id) {
        this.id = id
    }

    Map getEtichettaDesc() {
        switch (this) {
            case ISCRITTO_APR: return Etichette.getEtichetta("Iscritto_in_APR")
            case CANCELLATO_APR: return Etichette.getEtichetta("Cancellato_da_APR")
            case ISCRITTO_AIRE: return Etichette.getEtichetta("Iscritto_in_AIRE")
            case CANCELLATO_AIRE: return Etichette.getEtichetta("Cancellato_da_AIRE")
            case ISCRIZIONE_ATTESA_O_ANNULLATA: return Etichette.getEtichetta("Iscrizione_non_avvenuta")
            case NON_RESIDENTE: return Etichette.getEtichetta("Non_Residente")
        }
        return null
    }

    Map getEtichettaPluralDesc() {
        switch (this) {
            case ISCRITTO_APR: return Etichette.getEtichetta("Iscritto_in_APR_Famiglia")
            case CANCELLATO_APR: return Etichette.getEtichetta("Cancellato_da_APR_Famiglia")
            case ISCRITTO_AIRE: return Etichette.getEtichetta("Iscritto_in_AIRE_Famiglia")
            case CANCELLATO_AIRE: return Etichette.getEtichetta("Cancellato_da_AIRE_Famiglia")
            case ISCRIZIONE_ATTESA_O_ANNULLATA: return Etichette.getEtichetta("Iscrizione_non_avvenuta")
            case NON_RESIDENTE: return Etichette.getEtichetta("Non_Residente")
        }
        return null
    }


    static EFascia valueOfId(Integer id) {
        EFascia result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumFasciaToIntConverter implements AttributeConverter<EFascia, Integer> {
        @Override
        Integer convertToDatabaseColumn(EFascia ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        EFascia convertToEntityAttribute(Integer value) {
            return (value != null) ? valueOfId(value) : null
        }
    }
}