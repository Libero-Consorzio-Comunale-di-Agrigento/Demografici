package it.finmatica.de4gsdzk

interface IArchivioComunicazione {

    Long getId()

    Boolean isProtocollato()

    Boolean isDaProtocollare()

    Boolean isInviatoAlbo()

    Boolean isDaInviareAlbo()

    Boolean getStampaEseguita()

    IComunicazione getComunicazione()

    Integer getNumero()

    Long getIdDocumentoEsterno()

}