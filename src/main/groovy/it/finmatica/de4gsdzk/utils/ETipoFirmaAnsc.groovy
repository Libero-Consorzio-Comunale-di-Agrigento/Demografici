package it.finmatica.de4gsdzk.utils

enum ETipoFirmaAnsc {

    CA("CA"), //"Firma_Cartacea"
    EL("EL")  //"Firma_Elettronica"

    final String id

    private ETipoFirmaAnsc(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case CA: return Etichette.getEtichetta("Firma_Cartacea")
            case EL: return Etichette.getEtichetta("Firma_Elettronica")
        }
        return null
    }

}