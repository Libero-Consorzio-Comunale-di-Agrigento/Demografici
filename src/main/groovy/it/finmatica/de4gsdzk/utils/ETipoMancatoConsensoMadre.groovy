package it.finmatica.de4gsdzk.utils

enum ETipoMancatoConsensoMadre {

    // ANSC_35
    NO("NO"), // Non vuole essere nominata
    DE("DE")  // Non può essere nominata per difetto di età

    final String id

    private ETipoMancatoConsensoMadre(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case NO: return Etichette.non_vuole_essere_nominata
            case DE: return Etichette.non_puo_essere_nominata
        }
        return null
    }

}