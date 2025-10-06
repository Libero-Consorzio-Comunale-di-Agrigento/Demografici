package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.utils.Etichette

enum EFunzionePagamentoInviato {
    RIPETIZIONE,
    CONFERMA,
    VERIFICA,
    ANNULLA

    Map getEtichettaDesc() {
        switch (this) {
            case RIPETIZIONE: return Etichette.ripetizione_invio_tooltip
            case CONFERMA: return Etichette.conferma_pagamento_tooltip
            case VERIFICA: return Etichette.verifica_pagamento_tooltip
            case ANNULLA: return Etichette.annulla_pagamento_tooltip
        }
        return null
    }
}
