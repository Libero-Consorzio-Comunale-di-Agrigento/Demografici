package it.finmatica.de4gsdzk.utils

enum EModulo {

    ARCHIVI("ARCHIVI" , "/restrict/archivi/index.zul","archive.png"),
    ANAGRAFE("ANAGRAFE", "/restrict/anagrafe/index.zul","user.png"),
    STATO_CIVILE("STATO_CIVILE", "/restrict/statocivile/index.zul","contract.png"),
    SMART_STATS("SMART_STATS", "","chart.png"),
    ELETTORALE("ELETTORALE", "","reports.png"),
    LEVA_MILITARE("LEVA_MILITARE", "","process.png"),
    CERTIFICAZIONE("CERTIFICAZIONE", "/restrict/certificazione/index.zul","legitimate.png")

    String id
    String uri
    String img

    private EModulo(String id, String uri, String img) {
        this.id = id
        this.uri = uri
        this.img = img
    }

    Map getEtichettaDesc(){
        switch(this) {
            case ARCHIVI: return Etichette.ARCHIVI
            case ANAGRAFE: return Etichette.ANAGRAFE
            case STATO_CIVILE: return Etichette.STATO_CIVILE
            case SMART_STATS: return Etichette.SMART_STATS
            case ELETTORALE: return Etichette.ELETTORALE
            case LEVA_MILITARE: return Etichette.LEVA_MILITARE
            case CERTIFICAZIONE: return Etichette.CERTIFICAZIONE
        }
        return null
    }

}