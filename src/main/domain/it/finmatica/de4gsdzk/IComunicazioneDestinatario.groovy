package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.archivi.ArcComune

interface IComunicazioneDestinatario {

    Long getId()
    void setId(Long id)

    IArchivioComunicazione getArchivioComunicazione()

    String getPec()
    void setPec(String pec)

    String getDenominazione()

    IEnte getEnte()

    Integer getCodiceProvinciaDestinatario()

    Integer getCodiceComuneDestinatario()

    ArcComune getComuneDomain()


}