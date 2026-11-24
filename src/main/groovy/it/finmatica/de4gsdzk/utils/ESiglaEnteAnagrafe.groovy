package it.finmatica.de4gsdzk.utils

enum ESiglaEnteAnagrafe {

     comune_eve,
     comune_nas,
     consolato_res,
     consolato_res_prec,
     ente_dest,
     matricola,
     matricola_dic,
     matricola_sog

    String getDescrizione(){
        switch (this) {
            case comune_eve:
                return "Comune dell'evento"
            case comune_nas:
                return "Comune di nascita (Soggetto 1)"
            case consolato_res:
                return "Consolato di residenza"
            case consolato_res_prec:
                return "Consolato di residenza (precedente)"
            case ente_dest:
                return "Ente Destinatario (pre-definito)"
            case matricola:
                return "Cittadino interessato"
            case matricola_dic:
                return  "Cittadino dichiarante pratica"
            case matricola_sog:
                return "Cittadino soggetto pratica"
        }
        return ""
    }
}
