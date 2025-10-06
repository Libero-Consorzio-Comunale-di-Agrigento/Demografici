package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.utils.EGenereNotifica
import it.finmatica.de4gsdzk.utils.EStatoFlussoNotifica

class AnscInfoNotifica {

    private final Long id
    private final String idAnsc
    private final String descrizione
    private final AnscInfoSoggetto infoSoggetto
    private final EStatoFlussoNotifica stato
    private final EGenereNotifica genere
    private final Date validoDal
    private final String comuneFormazione


    private AnscInfoEvento infoEvento

    AnscInfoNotifica(Long id, String idAnsc, String descrizione, AnscInfoSoggetto infoSoggetto, EStatoFlussoNotifica stato, EGenereNotifica genere,
                     Date validoDal, String comuneFormazione){
        this.id = id
        this.idAnsc = idAnsc
        this.descrizione = descrizione
        this.infoSoggetto = infoSoggetto
        this.stato = stato
        this.genere = genere
        this.validoDal = validoDal
        this.comuneFormazione = comuneFormazione
    }

    Long getId() {
        return id
    }

    String getIdAnsc() {
        return idAnsc
    }

    String getDescrizione() {
        return descrizione
    }

    AnscInfoSoggetto getInfoSoggetto() {
        return infoSoggetto
    }

    EStatoFlussoNotifica getStato() {
        return stato
    }

    EGenereNotifica getGenere() {
        return genere
    }

    Date getValidoDal() {
        return validoDal
    }

    String getComuneFormazione() {
        return comuneFormazione
    }

    AnscInfoEvento getInfoEvento() {
        return infoEvento
    }

    void setInfoEvento(AnscInfoEvento infoEvento) {
        this.infoEvento = infoEvento
    }
}
