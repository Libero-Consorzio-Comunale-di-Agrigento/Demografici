package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Slf4j
@Entity
@Table(name = "ANST97")
class AnscConsolato {

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Descrizione")]

}
