package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc

class AnscInfoArchivioRifIdRifs {

    private final ETipoArchivioAnsc tipoArchivioRif
    private final List<Long> idRifs

    AnscInfoArchivioRifIdRifs(ETipoArchivioAnsc tipoArchivioRif, List<Long> idRifs){
        this.tipoArchivioRif = tipoArchivioRif
        this.idRifs = idRifs
    }

    ETipoArchivioAnsc getTipoArchivioRif() {
        return tipoArchivioRif
    }

    List<Long> getIdRifs() {
        return idRifs
    }
}
