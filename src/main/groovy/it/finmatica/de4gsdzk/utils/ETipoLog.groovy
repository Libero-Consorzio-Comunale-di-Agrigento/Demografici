package it.finmatica.de4gsdzk.utils

enum ETipoLog {

    Doc_Area("Doc_Area"),
    Firma_Remota("Firma_Remota"),
    Istat("Istat"),
    ANPR("ANPR"),
    ANSC("ANSC"),
    Gestione_Testi("GTE"),
    Wspa("WSPA"),
    Gsd("GSD")

    final String id

    private ETipoLog(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case Doc_Area: return Etichette.Doc_Area
            case Firma_Remota: return Etichette.Firma_Remota
            case Istat: return Etichette.Istat
            case ANPR: return Etichette.ANPR
            case ANSC: return Etichette.ANSC
            case Gestione_Testi: return Etichette.Gestione_Testi
            case Wspa: return Etichette.Pagamenti
            case Gsd: return Etichette.Applicativo
        }
        return null
    }

}