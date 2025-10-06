package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.CivEnte

class RicercaDestinatario {

    private final int id
    private final ArcComune comuneDomain
    private final CivEnte ente
    private final String denominazione

    RicercaDestinatario(int id, ArcComune comuneDomain, CivEnte ente, String denominazione){
        this.id = id
        this.comuneDomain = comuneDomain
        this.ente = ente
        this.denominazione = denominazione
    }

    int getId() {
        return id
    }

    ArcComune getComuneDomain() {
        return comuneDomain
    }

    CivEnte getEnte() {
        return ente
    }

    String getDenominazione() {
        return denominazione
    }
}
