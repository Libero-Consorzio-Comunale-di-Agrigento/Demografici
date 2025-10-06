package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ESesso

interface ISoggettoCollegato {

    String getCognome()
    void setCognome(String s)

    String getNome()
    void setNome(String s)

    ESesso getSesso()
    void setSesso(ESesso s)

    Date getDataNascita()
    void setDataNascita(Date d)

    Comune getComuneNascita()
    void setComuneNascita(Comune c)

    Comune getComuneResidenza()
    void setComuneResidenza(Comune c)

}