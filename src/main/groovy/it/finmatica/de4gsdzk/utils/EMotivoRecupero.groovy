package it.finmatica.de4gsdzk.utils

enum EMotivoRecupero {

    // ANSC_96
    M1("M1"), // "Indisponibilita del sistema gestionale"
    M2("M2"), // "Atto formato fuori da casa comunale"
    M3("M3"), // "Caso d'uso non previsto nel sistema centrale"
    M4("M4"), // "Indisponibilità del sistema centrale"
    MX("MX")  // "Altro"

    final String id

    private EMotivoRecupero(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case M1: return Etichette.getEtichetta("Indisponibilita")
            case M2: return Etichette.getEtichetta("Atto_fcc")
            case M3: return Etichette.getEtichetta("Cdu_non_gestito")
            case M4: return Etichette.getEtichetta("Indisp_centrale")
            case MX: return Etichette.getEtichetta("Altro")
        }
        return null
    }

}