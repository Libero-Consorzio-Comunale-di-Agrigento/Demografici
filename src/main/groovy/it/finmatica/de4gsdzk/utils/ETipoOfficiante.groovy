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
            case O1: return Etichette.Sindaco
            case O2: return Etichette.Vicesindaco
            case O3: return Etichette.Ufficiale_Stato_Civile
            case O4: return Etichette.Comune_Cittadino
            case O5: return Etichette.Parroco
            case O6: return Etichette.Diacono
            case O7: return Etichette.Cappellano_Militare
            case O8: return Etichette.Comandante_Nave
            case O9: return Etichette.Comandante_Aereo
            case O10: return Etichette.Ministro_culto
        }
        return null
    }
    */

}