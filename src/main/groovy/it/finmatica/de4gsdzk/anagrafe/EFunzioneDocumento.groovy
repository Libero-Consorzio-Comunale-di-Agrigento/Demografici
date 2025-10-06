package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

enum EFunzioneDocumento {
    DOWNLOAD,
    ADD_ALLEGATO

    Map getEtichettaDesc() {
        switch (this) {
            case DOWNLOAD: return Etichette.scarica_allegati_tooltip
            case ADD_ALLEGATO: return Etichette.inserisci_allegato_tooltip
        }
        return null
    }
}