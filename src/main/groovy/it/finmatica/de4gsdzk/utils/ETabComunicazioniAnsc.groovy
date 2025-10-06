package it.finmatica.de4gsdzk.utils

enum ETabComunicazioniAnsc {
    Allegati(0),
    Obbligatori(1),
    Aggiuntivi(2)

    Integer index

    ETabComunicazioniAnsc(Integer index) {
        this.index = index
    }

    Map getEtichettaDesc() {
        switch (this) {
            case Allegati: return Etichette.Servizi_allegati
            case Obbligatori: return Etichette.Servizi_obbligatori
            case Aggiuntivi: return Etichette.Servizi_aggiuntivi
        }
        return null
    }

    static ETabComunicazioniAnsc fromIndex(Integer index) {
        return values().find { it.index == index }
    }
}
