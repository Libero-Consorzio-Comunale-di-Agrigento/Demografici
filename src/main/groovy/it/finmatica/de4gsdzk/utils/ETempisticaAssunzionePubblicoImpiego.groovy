package it.finmatica.de4gsdzk.utils

enum ETempisticaAssunzionePubblicoImpiego {

    //ANSC_45
    AO("AO"), // "Assunto"
    AA("AA")  // "Assumera"

    final String id

    private ETempisticaAssunzionePubblicoImpiego(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case AO: return Etichette.Assunto
            case AA: return Etichette.Assumera
        }
        return null
    }

}