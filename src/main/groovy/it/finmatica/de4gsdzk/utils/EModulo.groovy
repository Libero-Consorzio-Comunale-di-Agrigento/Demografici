package it.finmatica.de4gsdzk.utils

enum EModulo {

    ARCHIVI("ARCHIVI" , "/restrict/archivi/index.zul","archive.png"),
    ANAGRAFE("ANAGRAFE", "/restrict/anagrafe/index.zul","group.png"),
    STATO_CIVILE("STATO_CIVILE", "/restrict/statocivile/index.zul","contract.png"),
    SMART_STATS("SMART_STATS", "","chart.png"),
    ELETTORALE("ELETTORALE", "/restrict/elettorale/index.zul","reports.png"),
    LEVA_MILITARE("LEVA_MILITARE", "/restrict/levamilitare/index.zul","process.png"),
    CERTIFICAZIONE("CERTIFICAZIONE", "/restrict/certificazione/index.zul","legitimate.png"),
    TOPONOMASTICA("TOPONOMASTICA", "/restrict/toponomastica/index.zul","dictionary.png")

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
            case ARCHIVI: return Etichette.getEtichetta("ARCHIVI")
            case ANAGRAFE: return Etichette.getEtichetta("ANAGRAFE")
            case STATO_CIVILE: return Etichette.getEtichetta("STATO_CIVILE")
            case SMART_STATS: return Etichette.getEtichetta("SMART_STATS")
            case ELETTORALE: return Etichette.getEtichetta("ELETTORALE")
            case LEVA_MILITARE: return Etichette.getEtichetta("LEVA_MILITARE")
            case CERTIFICAZIONE: return Etichette.getEtichetta("CERTIFICAZIONE")
            case TOPONOMASTICA: return Etichette.getEtichetta("TOPONOMASTICA")
        }
        return null
    }

}