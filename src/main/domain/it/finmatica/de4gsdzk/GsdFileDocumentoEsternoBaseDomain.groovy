package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.integrazioni.documentale.IFileDocumentoEsterno

import javax.persistence.Column
import javax.persistence.MappedSuperclass

@MappedSuperclass
abstract class GsdFileDocumentoEsternoBaseDomain extends GsdBaseDomain implements IFileDocumentoEsterno{

    // indica l'id del file se salvato su un repository esterno (ad es GDM)
    @Column(name = "ID_OGGETTO_FILE_GDM")
    Long idFileEsterno

}
