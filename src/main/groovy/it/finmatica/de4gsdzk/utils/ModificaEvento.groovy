package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.Comune

class ModificaEvento {

    Boolean aggiornamento
    Boolean ripristinoVisible

    Integer anno
    Integer pratica
    Comune comuneEvento
    Comune comuneIscrizioneAire
    Date dataRegistrazione

    Boolean ripristino

    String motivo



    ModificaEvento(Boolean aggiornamento, Boolean ripristinoVisible) {
        this.aggiornamento = aggiornamento
        if(aggiornamento) {
            comuneEvento = new Comune()
            comuneIscrizioneAire = new Comune()
        } else {
            this.ripristinoVisible = ripristinoVisible
        }
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Nuovi_Valori"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Pratica"),
                                              Etichette.getEtichetta("Comune_Evento"), Etichette.getEtichetta("Comune_Iscrizione_Aire"),
                                              Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Ripristino_DL"),
                                              Etichette.getEtichetta("Motivo_Aggiornamento"), Etichette.getEtichetta("Motivo_Eliminazione")]



}
