package it.finmatica.de4gsdzk.utils

interface IRicercaAnsc {

    //Contiene tutti i campi che possono essere ottenuti da interfaccia per una ricerca ANSC

    ETipoEventoAnsc getTipoEventoAnsc()

    Date getDal()

    Date getAl()

    EStatoFlussoNotifica getStatoNotifica()

    EGenereNotifica getGenereNotifica()

    ETipoContenutoAnsc getTipoContenutoNotifica()

    Date getDataNascita()

    ESesso getSesso()

    String getCognome()

    String getNome()

}
