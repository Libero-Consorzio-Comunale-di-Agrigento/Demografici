package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.ansc.AnscComunicazione

interface IAnscComunicazione {

    AnscComunicazione getComunicazione()
    void setComunicazione(AnscComunicazione c)

    Boolean getFlagUltima()
}
