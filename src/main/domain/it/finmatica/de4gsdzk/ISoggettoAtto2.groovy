package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.utils.ESesso

public interface ISoggettoAtto2 extends ISoggettoAtto2Base{

    String getCognome2()
    void setCognome2(String s)

    Boolean getSenzaCognome2()
    void setSenzaCognome2(Boolean val)

    String getNome2()
    void setNome2(String s)

    Boolean getSenzaNome2()
    void setSenzaNome2(Boolean val)

    Date getDataNascita2()
    void setDataNascita2(Date d)

    ESesso getSesso2()
    void setSesso2(ESesso s)

    Integer getCodiceComuneNascita2()
    void setCodiceComuneNascita2(Integer i)

    String getDescrizioneComuneNascita2()
    void setDescrizioneComuneNascita2(String s)

    Integer getCodiceProvinciaNascita2()
    void setCodiceProvinciaNascita2(Integer i)

    String getSiglaProvinciaNascita2()
    void setSiglaProvinciaNascita2(String s)

    Integer getCodiceComuneResidenza2()
    void setCodiceComuneResidenza2(Integer i)

    String getDescrizioneComuneResidenza2()
    void setDescrizioneComuneResidenza2(String s)

    Integer getCodiceProvinciaResidenza2()
    void setCodiceProvinciaResidenza2(Integer i)

    String getSiglaProvinciaResidenza2()
    void setSiglaProvinciaResidenza2(String s)

    String getCodiceFiscale2()
    void setCodiceFiscale2(String codiceFiscale)

    Boolean getCfCalcolato2()
    void setCfCalcolato2(Boolean val)

    AnaCittadinanza getNazionalita2()
    void setNazionalita2(AnaCittadinanza n)

}
