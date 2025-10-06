package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class LogBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "DATA_ORA", nullable = false)
    Date dataOra

    @Column(name = "OPERAZIONE")
    String operazione

    @Column(name = "NOTE")
    String note

    @Column(name = "NOTE_VIS", nullable = true, updatable = false, insertable = false)
    String noteVis

    @Column(name = "CAMPO_CLOB")
    String clob

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data, Etichette.Operazione, Etichette.Note]
}

