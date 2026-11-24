package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoCivile

interface ISoggettoAtto1 extends ISoggettoAtto1Base{

    String getCognome1()
    void setCognome1(String s)

    Boolean getSenzaCognome1()
    void setSenzaCognome1(Boolean val)

    String getNome1()
    void setNome1(String s)

    Boolean getSenzaNome1()
    void setSenzaNome1(Boolean val)

    Date getDataNascita1()
    void setDataNascita1(Date d)

    ESesso getSesso1()
    void setSesso1(ESesso sesso1)

    Integer getCodiceComuneNascita1()
    void setCodiceComuneNascita1(Integer i)

    String getDescrizioneComuneNascita1()
    void setDescrizioneComuneNascita1(String s)

    Integer getCodiceProvinciaNascita1()
    void setCodiceProvinciaNascita1(Integer i)

    String getSiglaProvinciaNascita1()
    void setSiglaProvinciaNascita1(String s)

    Integer getCodiceComuneResidenza1()
    void setCodiceComuneResidenza1(Integer i)

    String getDescrizioneComuneResidenza1()
    void setDescrizioneComuneResidenza1(String s)

    Integer getCodiceProvinciaResidenza1()
    void setCodiceProvinciaResidenza1(Integer i)

    String getSiglaProvinciaResidenza1()
    void setSiglaProvinciaResidenza1(String s)

    String getCodiceFiscale1()
    void setCodiceFiscale1(String codiceFiscale)

    Boolean getCfCalcolato1()
    void setCfCalcolato1(Boolean val)

    AnaCittadinanza getNazionalita1()
    void setNazionalita1(AnaCittadinanza n)

    EStatoCivile getStatoCivile1()
    void setStatoCivile1(EStatoCivile s)

}
