package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.CivFascicoloAtto
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegato

class DocumentoFascicolo {

    private final CivFascicoloAtto fascicolo
    private final Boolean modifyTipoEnabled
    private final List<CivFascicoloAttoAllegato> allegatiFascicolo

    DocumentoFascicolo(CivFascicoloAtto fascicolo, Boolean modifyTipoEnabled, List<CivFascicoloAttoAllegato> allegatiFascicolo) {
        this.fascicolo = fascicolo
        this.modifyTipoEnabled = modifyTipoEnabled
        this.allegatiFascicolo = allegatiFascicolo
    }

    CivFascicoloAtto getFascicolo() {
        return fascicolo
    }

    Boolean isModifyTipoEnabled() {
        return modifyTipoEnabled
    }

    List<CivFascicoloAttoAllegato> getAllegatiFascicolo() {
        return allegatiFascicolo
    }

    Long getId(){
        return fascicolo?.id
    }
}

