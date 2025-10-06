package it.finmatica.de4gsdzk.utils

enum ETipoRiconoscimentoCittadinanza {

    //ANSC_98
    MD("MD"), // Riconoscimento materno
    PD("PD"), // Riconoscimento paterno
    SP("SP"), // Sentenza di riconoscimento paterno
    SM("SM")  // Sentenza di riconoscimento materno

    final String id

    private ETipoRiconoscimentoCittadinanza(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case MD: return Etichette.Riconoscimento_materno
            case PD: return Etichette.Riconoscimento_paterno
            case SP: return Etichette.Sentenza_padre
            case SM: return Etichette.Sentenza_madre
        }
        return null
    }

}