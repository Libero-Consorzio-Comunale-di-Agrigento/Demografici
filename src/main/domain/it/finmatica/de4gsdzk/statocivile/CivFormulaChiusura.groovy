package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "CIVFCR_V")
class CivFormulaChiusura extends GsdBaseDomain {

    @Id
    @Column(name = "CODICE")
    String id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AUTORITA", nullable = true)
    Boolean flagAutorita

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RESTITUZIONE", nullable = true)
    Boolean flagRestituzione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []
}
