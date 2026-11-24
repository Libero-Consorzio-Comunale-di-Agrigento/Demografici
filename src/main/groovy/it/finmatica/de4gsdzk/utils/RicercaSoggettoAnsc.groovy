package it.finmatica.de4gsdzk.utils

class RicercaSoggettoAnsc implements IRicercaAnsc {

    String cognome
    String nome
    Date dataNascita
    ESesso sesso


    @Override
    ETipoEventoAnsc getTipoEventoAnsc() {
        return null
    }

    @Override
    Date getDal() {
        return null
    }

    @Override
    Date getAl() {
        return null
    }

    @Override
    EStatoFlussoNotifica getStatoNotifica() {
        return null
    }

    @Override
    EGenereNotifica getGenereNotifica() {
        return null
    }

    @Override
    ETipoContenutoAnsc getTipoContenutoNotifica() {
        return null
    }
}
