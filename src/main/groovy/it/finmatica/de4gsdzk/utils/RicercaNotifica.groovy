package it.finmatica.de4gsdzk.utils

class RicercaNotifica implements IRicercaNotificheAnsc {

    private Date dal
    private Date al
    private ETipoEventoAnsc tipoEventoAnsc
    private EGenereNotifica genereNotifica
    private EStatoFlussoNotifica statoNotifica
    private ETipoContenutoAnsc tipoContenutoNotifica

    RicercaNotifica() {}

    RicercaNotifica(Date dal, Date al){
        this.dal = dal
        this.al = al
    }

    RicercaNotifica(Date dal, Date al, EStatoFlussoNotifica statoNotifica){
        this.dal = dal
        this.al = al
        this.statoNotifica = statoNotifica
    }

    Date getDal() {
        return dal
    }

    Date getAl() {
        return al
    }

    ETipoEventoAnsc getTipoEventoAnsc(){
        return tipoEventoAnsc
    }

    EGenereNotifica getGenereNotifica() {
        return genereNotifica
    }

    EStatoFlussoNotifica getStatoNotifica() {
        return statoNotifica
    }

    ETipoContenutoAnsc getTipoContenutoNotifica() {
        return tipoContenutoNotifica
    }

    void setDal(Date dal) {
        this.dal = dal
    }

    void setAl(Date al) {
        this.al = al
    }

    void setGenereNotifica(EGenereNotifica genereNotifica) {
        this.genereNotifica = genereNotifica
    }

    void setStatoNotifica(EStatoFlussoNotifica statoNotifica) {
        this.statoNotifica = statoNotifica
    }

    void setTipoEventoAnsc(ETipoEventoAnsc tipoEventoAnsc) {
        this.tipoEventoAnsc = tipoEventoAnsc
    }

    void setTipoContenutoNotifica(ETipoContenutoAnsc tipoContenutoNotifica) {
        this.tipoContenutoNotifica = tipoContenutoNotifica
    }

    static final List<Map> etichetteRicercaNotDesc = [Etichette.Effettua_Ricerca, Etichette.Data_validita, Etichette.Da, Etichette.A, Etichette.Stato, Etichette.Genere]

}
