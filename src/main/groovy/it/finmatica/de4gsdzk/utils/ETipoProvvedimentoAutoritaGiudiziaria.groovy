package it.finmatica.de4gsdzk.utils

enum ETipoProvvedimentoAutoritaGiudiziaria {

    // ANSC_99
    NO("NO"), // nulla osta del Procuratore della Repubblica
    AP("AP"), // autorizzazione del Procuratore della Repubblica
    PT("PT")  // provvedimento del Presidente del Tribunale

    final String id

    private ETipoProvvedimentoAutoritaGiudiziaria(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NO: return Etichette.getEtichetta("nulla_osta_procuratore")
            case AP: return Etichette.getEtichetta("autorizzazione_procuratore")
            case PT: return Etichette.getEtichetta("provvedimento_tribunale")
        }
        return null
    }

}