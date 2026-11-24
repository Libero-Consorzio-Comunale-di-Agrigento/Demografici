package it.finmatica.de4gsdzk.utils

enum EGruppo {

    CIV("CIV"),
    CER("CER"),
    GSD("GSD"),
    XXX("XXX"),
    WSP("WSP"),
    ANA("ANA"),
    ELE("ELE"),
    LEV("LEV"),
    TRA("TRA")

    final String id

    private EGruppo(String id) {
        this.id = id
    }

}