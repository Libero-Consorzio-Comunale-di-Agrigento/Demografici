package it.finmatica.de4gsdzk.utils

class RicercaProtocollo {

    Date dal
    Date al

    Integer anno

    Integer numeroDal
    Integer numeroAl

    String oggetto

    RicercaProtocollo() {
        super()
    }

    String getZulCampiRicerca() {
        return "/restrict/afc/campiRicercaProtocollo.zul"
    }
}