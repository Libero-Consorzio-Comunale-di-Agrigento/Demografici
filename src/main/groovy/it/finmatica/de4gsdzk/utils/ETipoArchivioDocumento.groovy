package it.finmatica.de4gsdzk.utils

enum ETipoArchivioDocumento {

    DAT("DAT") // Dichiarazione Anticipata di Trattamento

    final String id

    private ETipoArchivioDocumento(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case DAT: return Etichette.Dichiarazione_Anticipata_di_Trattamento
        }
        return null
    }

}