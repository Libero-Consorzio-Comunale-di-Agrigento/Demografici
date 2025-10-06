package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.utils.IIndirizzo
import it.finmatica.de4gsdzk.utils.IIndirizzoNonResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidenteEstero

class AnagrafeUtils {
    static IIndirizzo getIndirizzo(EFascia fascia,
                                   IIndirizzoResidente indirizzoResidente,
                                   IIndirizzoResidenteEstero indirizzoResidenteEstero,
                                   IIndirizzoNonResidente indirizzoNonResidente) {
        switch (fascia) {
            case EFascia.ISCRITTO_APR:
                return indirizzoResidente
            case EFascia.CANCELLATO_APR:
                return indirizzoResidente
            case EFascia.ISCRITTO_AIRE:
                return indirizzoResidenteEstero
            case EFascia.CANCELLATO_AIRE:
                return indirizzoResidenteEstero
            case EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA:
                return indirizzoNonResidente
            case EFascia.NON_RESIDENTE:
                return indirizzoNonResidente
        }
    }
}
