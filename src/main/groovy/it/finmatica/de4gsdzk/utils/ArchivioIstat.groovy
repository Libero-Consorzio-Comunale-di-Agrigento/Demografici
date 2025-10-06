package it.finmatica.de4gsdzk.utils

class ArchivioIstat {

    private final Integer codice
    private final String descrizione
    private final String codiceAds
    private final ETipoArchivioIstat archivioIstat

    ArchivioIstat(Integer codice, String descrizione, String codiceAds, ETipoArchivioIstat archivioIstat) {
        this.codice = codice
        this.descrizione = descrizione
        this.codiceAds = codiceAds
        this.archivioIstat = archivioIstat
    }

    ArchivioIstat(Integer codice, String descrizione) {
        this.codice = codice
        this.descrizione = descrizione
        this.codiceAds = null
        this.archivioIstat = null
    }

    Integer getCodice() {
        return codice
    }

    String getDescrizione() {
        return descrizione
    }

    String getCodiceAds() {
        return codiceAds
    }

    ETipoArchivioIstat getArchivioIstat() {
        return archivioIstat
    }
}

