package it.finmatica.de4gsdzk.utils

enum ETipoOfficiante {

    // ANSC_46
    O1("O1"),
    O2("O2"),
    O3("O3"),
    O4("O4"),
    O5("O5"),
    O6("O6"),
    O7("O7"),
    O8("O8"),
    O9("O9"),
    O10("O10")

    final String id

    private ETipoOfficiante(String id) {
        this.id = id
    }

    /*
    Map getEtichettaDesc(){
        switch(this) {
            case O1: return Etichette.getEtichetta("getEtichetta("Sindaco"),
            case O2: return Etichette.getEtichetta("Vicesindaco")
            case O3: return Etichette.getEtichetta("Ufficiale_Stato_Civile")
            case O4: return Etichette.getEtichetta("Comune_Cittadino")
            case O5: return Etichette.getEtichetta("Parroco")
            case O6: return Etichette.getEtichetta("Diacono")
            case O7: return Etichette.getEtichetta("Cappellano_Militare")
            case O8: return Etichette.getEtichetta("Comandante_Nave")
            case O9: return Etichette.getEtichetta("Comandante_Aereo")
            case O10: return Etichette.getEtichetta("Ministro_culto")
        }
        return null
    }
    */

}