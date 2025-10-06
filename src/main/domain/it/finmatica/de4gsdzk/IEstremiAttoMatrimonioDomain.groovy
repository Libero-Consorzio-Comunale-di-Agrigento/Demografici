package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.statocivile.embed.Comune

interface IEstremiAttoMatrimonioDomain extends IEstremiAttoDomain{

    // MATRIMONIO
    Integer getUfficioAttoMatrimonio()
    void setUfficioAttoMatrimonio(Integer ufficioAttoMatrimonio)

    Integer getAnnoAttoMatrimonio()
    void setAnnoAttoMatrimonio(Integer annoAttoMatrimonio)

    Integer getAttoAttoMatrimonio()
    void setAttoAttoMatrimonio(Integer attoAttoMatrimonio)

    Integer getParteAttoMatrimonio()
    void setParteAttoMatrimonioString(String s)

    String getSerieAttoMatrimonio()
    void setSerieAttoMatrimonio(String serieAttoMatrimonio)

    Integer getCodiceComuneAttoMatrimonio()
    void setCodiceComuneAttoMatrimonio(Integer i)

    String getDescrizioneComuneAttoMatrimonio()
    void setDescrizioneComuneAttoMatrimonio(String s)

    Integer getCodiceProvinciaAttoMatrimonio()
    void setCodiceProvinciaAttoMatrimonio(Integer i)

    String getSiglaProvinciaAttoMatrimonio()
    void setSiglaProvinciaAttoMatrimonio(String s)

    String getIdAttoAnscMatrimonio()
    void setIdAttoAnscMatrimonio(String s)

    Comune getComuneMatrimonio()
    void setComuneMatrimonio(Comune c)

}
