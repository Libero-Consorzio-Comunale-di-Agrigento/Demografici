package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.Comune

interface IIndirizzoNonResidente extends IIndirizzo {
    String getVia()

    Comune getComune()
}