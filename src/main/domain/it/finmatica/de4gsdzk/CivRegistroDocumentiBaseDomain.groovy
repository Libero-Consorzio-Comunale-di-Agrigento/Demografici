package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Id
import javax.persistence.MappedSuperclass

@MappedSuperclass
abstract class CivRegistroDocumentiBaseDomain {

    @Id
    @Column(name = "COD_REGISTRO", nullable = false)
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Tipo_Registro")]

}
