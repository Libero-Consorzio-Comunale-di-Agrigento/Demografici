package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.utils.Etichette

enum EStatoInvio {
    INVIATO_CON_SUCCESSO,
    INVIO_NON_RIUSCITO

    Map getEtichettaDesc() {
        switch (this) {
            case INVIATO_CON_SUCCESSO: return Etichette.getEtichetta("Inviato")
            case INVIO_NON_RIUSCITO: return Etichette.getEtichetta("Da_inviare")
        }
        return null
    }
}