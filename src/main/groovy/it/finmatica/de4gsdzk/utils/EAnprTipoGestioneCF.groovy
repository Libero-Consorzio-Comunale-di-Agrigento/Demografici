package it.finmatica.de4gsdzk.utils

import javax.persistence.AttributeConverter
import javax.persistence.Converter

enum EAnprTipoGestioneCF {

    NESSUNA_OPERAZIONE(0),
    RICHIESTA_ATTRIBUZIONE(1),
    RICHIESTA_OMOCODICE(2),
    NESSUNA_VALIDAZIONE(3),

    final Integer id

    private EAnprTipoGestioneCF(Integer id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NESSUNA_OPERAZIONE: return Etichette.getEtichetta("Nessuna_Operazione")
            case RICHIESTA_ATTRIBUZIONE: return Etichette.getEtichetta("Richiesta_Attribuzione")
            case RICHIESTA_OMOCODICE: return Etichette.getEtichetta("Richiesta_Omocodice")
            case NESSUNA_VALIDAZIONE: return Etichette.getEtichetta("Nessuna_Validazione")
        }
        return null
    }

    static EAnprTipoGestioneCF valueOfId(Integer id) {
        EAnprTipoGestioneCF result = values().find { it.id == id }
        if (!result) {
            throw new IllegalArgumentException("Id ${id} non valido")
        }
        return result
    }

    @Converter
    static class EnumAnprTipoGestioneCFToIntegerConverter implements AttributeConverter<EAnprTipoGestioneCF, Integer> {
        @Override
        Integer convertToDatabaseColumn(EAnprTipoGestioneCF ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        EAnprTipoGestioneCF convertToEntityAttribute(Integer value) {
            return (value != null) ? valueOfId(value) : null
        }
    }

}