package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.utils.Etichette

enum EFunzionePagamentoInviato {
    RIPETIZIONE,
    CONFERMA,
    VERIFICA,
    ANNULLA

    Map getEtichettaDesc() {
        switch (this) {
            case RIPETIZIONE: return Etichette.getEtichetta("ripetizione_invio_tooltip")
            case CONFERMA: return Etichette.getEtichetta("conferma_pagamento_tooltip")
            case VERIFICA: return Etichette.getEtichetta("verifica_pagamento_tooltip")
            case ANNULLA: return Etichette.getEtichetta("annulla_pagamento_tooltip")
        }
        return null
    }
}
