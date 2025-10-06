package it.finmatica.de4gsdzk.certificazione

enum ECompetenzaCertificazione {
    AN("AN"),
    EL("EL"),
    LM("LM"),
    SC("SC")

    String id

    ECompetenzaCertificazione(String id) {
        this.id = id
    }
}