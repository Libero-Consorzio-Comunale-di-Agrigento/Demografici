package it.finmatica.de4gsdzk.integrazioni.documentale

interface IFileDocumentoEsterno {

    String getNome()

    Long getIdFileEsterno()

    //Extra
    void setIdFileEsterno(Long l)

    void setDocumento(IDocumentoEsterno de)
}