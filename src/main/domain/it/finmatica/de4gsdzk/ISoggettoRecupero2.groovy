package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ESesso

interface ISoggettoRecupero2 {

    Integer  getIdAnagrafe2()
    void setIdAnagrafe2(Integer i)

    String getCognome2()
    void setCognome2(String s)

    String getNome2()
    void setNome2(String s)

    Date getDataNascita2()
    void setDataNascita2(Date d)

    ESesso getSesso2()
    void setSesso2(ESesso s)

    Integer getCodiceComuneResidenza2()
    void setCodiceComuneResidenza2(Integer i)

    Integer getCodiceProvinciaResidenza2()
    void setCodiceProvinciaResidenza2(Integer i)

}
