package it.finmatica.de4gsdzk.utils

interface IRicercaNotificheAnsc extends IRicercaAnsc{

    Date getDal()

    Date getAl()

    EStatoFlussoNotifica getStatoNotifica()

    EGenereNotifica getGenereNotifica()

    ETipoContenutoAnsc getTipoContenutoNotifica()

}
