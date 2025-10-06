package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.utils.Etichette

enum EDiritto {
    SEGRETERIA(1),
    STATO_CIVILE(2),
    CARTA_IDENTITA(3),
    RIMBORSO_STAMPATI(4),
    BOLLO(9)

    private Integer id

    EDiritto(Integer id) {
        this.id = id
    }

    Integer getId() { id }

    Map getEtichettaDesc() {
        switch (this) {
            case SEGRETERIA: return Etichette.Diritti_segreteria
            case STATO_CIVILE: return Etichette.Diritti_stato_civile
            case CARTA_IDENTITA: return Etichette.Diritti_carta_identita
            case RIMBORSO_STAMPATI: return Etichette.Rimborso_stampati
            case BOLLO: return Etichette.Bollo
        }
        return null
    }

    // TODO: move to domain utils
    static EDiritto fromId(Integer id) {
        values().find { it.id == id }
    }


}