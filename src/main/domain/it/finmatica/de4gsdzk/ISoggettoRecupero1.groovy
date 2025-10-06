package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.ESesso

interface ISoggettoRecupero1 {

    Integer  getIdAnagrafe1()
    void setIdAnagrafe1(Integer i)

    String getCognome1()
    void setCognome1(String s)

    String getNome1()
    void setNome1(String s)

    Date getDataNascita1()
    void setDataNascita1(Date d)

    ESesso getSesso1()
    void setSesso1(ESesso s)

    Integer getCodiceComuneResidenza1()
    void setCodiceComuneResidenza1(Integer i)

    Integer getCodiceProvinciaResidenza1()
    void setCodiceProvinciaResidenza1(Integer i)

}
