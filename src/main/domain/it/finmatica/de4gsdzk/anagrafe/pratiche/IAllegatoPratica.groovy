package it.finmatica.de4gsdzk.anagrafe.pratiche

interface IAllegatoPratica {

    Long getId()
    byte[] getBlob()
    String getNome()
    Integer getSequenza()

}