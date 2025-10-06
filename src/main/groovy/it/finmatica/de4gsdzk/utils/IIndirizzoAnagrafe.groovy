package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.Comune

interface IIndirizzoAnagrafe extends IIndirizzo {
    void setComune(Comune c)

    Comune getComune()

    void setCap(String cap)

    String getCap()

    void setVia(String via)

    String getVia()
}