package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESesso

interface IConiuge {
    Integer getIdAnagrafe()

    String getCognome()

    String getNome()

    ESesso getSesso()

    Date getDataNascita()

    Comune getComuneNascita()

    Comune getComuneResidenza()

    AnaNazionalita getNazionalita()
}