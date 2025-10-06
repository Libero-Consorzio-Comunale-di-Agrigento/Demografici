package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno

import javax.persistence.Column
import javax.persistence.MappedSuperclass

@MappedSuperclass
abstract class GsdDocumentoEsternoBaseDomain extends GsdBaseDomain implements IDocumentoEsterno{

    @Column(name = "ID_DOCUMENTO_GDM", nullable = true)
    Long idDocumentoEsterno

    static final String AREA_GDM = "DE4"

}
