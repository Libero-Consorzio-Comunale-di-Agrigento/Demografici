package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.statocivile.CivTipoComprensione

interface IAttoMatUci extends IAttoMatPubUciPvuBase{

    Date getDataMatrimonio()
    void setDataMatrimonio(Date d)

    String getOraMatrimonio()
    void setOraMatrimonio(String o)

    String getMinutoMatrimonio()
    void setMinutoMatrimonio(String m)

    Boolean getDivorzio()
    void setDivorzio(Boolean b)

    String getNominativo1()

    String getNominativo2()

    CivTipoComprensione getComprensione1()
    void setComprensione1(CivTipoComprensione c)

    CivTipoComprensione getComprensione2()
    void setComprensione2(CivTipoComprensione c)

    String getMotivoImpedimento1()
    void setMotivoImpedimento1(String m)

    String getMotivoImpedimento2()
    void setMotivoImpedimento2(String m)

    Boolean isTrascrizioneEsteroDaPrivato()

    Boolean isTrascrizioneEsteroDaAutorita()

    Boolean isUfficialeAccordo()

    Boolean isUfficialeConferma()

    Boolean isUfficialeAltro()

    Boolean isAvvocati()

    Boolean isCivileXDelega()

    Boolean isDataOraMatrimonioMandatory()
}
