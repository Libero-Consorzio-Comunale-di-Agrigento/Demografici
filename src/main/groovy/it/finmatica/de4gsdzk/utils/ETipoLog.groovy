package it.finmatica.de4gsdzk.utils

enum ETipoLog {

    Doc_Area("Doc_Area"),
    Firma_Remota("Firma_Remota"),
    Istat("Istat"),
    ANPR("ANPR"),
    ANSC("ANSC"),
    Gestione_Testi("GTE"),
    Wspa("WSPA"),
    Gsd("GSD"),
    Ws_min_int("WS_MININT")

    final String id

    private ETipoLog(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case Doc_Area: return Etichette.getEtichetta("Doc_Area")
            case Firma_Remota: return Etichette.getEtichetta("Firma_Remota")
            case Istat: return Etichette.getEtichetta("Istat")
            case ANPR: return Etichette.getEtichetta("ANPR")
            case ANSC: return Etichette.getEtichetta("ANSC")
            case Gestione_Testi: return Etichette.getEtichetta("Gestione_Testi")
            case Wspa: return Etichette.getEtichetta("Pagamenti")
            case Gsd: return Etichette.getEtichetta("Applicativo")
            case Ws_min_int: return Etichette.getEtichetta("Web_Service_Ministero_Interno")
        }
        return null
    }

}