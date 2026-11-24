package it.finmatica.de4gsdzk.utils

enum ESiglaEnteStatoCivile {

    comune_attnas,
    comune_attnas_2,
    comune_eve,
    comune_nas,
    comune_nas_2,
    comune_res,
    comune_res_2,
    tribunale_ute,
    procura_ute,
    prefetto_ute,
    ente_generico

    String getDescrizione(){
        switch (this) {
            case comune_attnas:
                return "Comune dell'atto di nascita (Soggetto 1)"
            case comune_attnas_2:
                return "Comune dell'atto di nascita (Soggetto 2)"
            case comune_eve:
                return "Comune dell'evento"
            case comune_nas:
                return "Comune di nascita (Soggetto 1)"
            case comune_nas_2:
                return "Comune di nascita (Soggetto 2)"
            case comune_res:
                return "Comune di residenza (Soggetto 1)"
            case comune_res_2:
                return "Comune di residenza (Soggetto 2)"
            case tribunale_ute:
                return "Tribunale di competenza del comune utente"
            case procura_ute:
                return "Procura di competenza del comune utente"
            case prefetto_ute:
                return "Prefetto di competenza del comune utente"
            case ente_generico:
                return "Ente generico (non automatico)"
        }
        return ""
    }
}
