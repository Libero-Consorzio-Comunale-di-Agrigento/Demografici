package it.finmatica.de4gsdzk.utils

enum EGenereAnnotazione {

    RET("RET"),
    REA("REA"),
    EMA("EMA"),
    COM("COM"),  // se serve faremo casi specifici come per le annotazioni da amministrazione
    AMM("AMM"),
    AMD("AMD"),  // per matrimoni
    AMX("AMX"),
    AMS("AMS"), // per unioni civili
    AMA("AMA"), // annullamento (es sacra rota)
    AUT("AUT")

    final String id

    private EGenereAnnotazione(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case RET: return Etichette.getEtichetta("Annotazione_rettifica_modifica")
            case REA: return Etichette.getEtichetta("Annotazione_rettifica_annullamento")
            case EMA: return Etichette.getEtichetta("Annotazione_errore_materiale")
            case COM: return Etichette.getEtichetta("Annotazione_comuni_generica")
            case AMM: return Etichette.getEtichetta("Annotazione_amministrazioni_generica")
            case AMD: return Etichette.getEtichetta("Annotazione_amministrazioni_divorzio")
            case AMX: return Etichette.getEtichetta("Annotazione_amministrazioni_separazione")
            case AMS: return Etichette.getEtichetta("Annotazione_amministrazioni_scioglimento")
            case AMA: return Etichette.getEtichetta("Annotazione_amministrazioni_annullamento")
            case AUT: return Etichette.getEtichetta("Annotazione_auto")
        }
        return null
    }

}