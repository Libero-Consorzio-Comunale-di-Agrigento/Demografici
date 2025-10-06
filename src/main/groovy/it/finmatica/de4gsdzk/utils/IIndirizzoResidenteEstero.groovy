package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.embed.Comune

interface IIndirizzoResidenteEstero extends IIndirizzo {
    String getVia()

    Comune getComune()

    String getZipcode()

    String getProvinciaContea()

    String getPresso()

    String getCodiceConsolato()

    String getSedeConsolato()
}