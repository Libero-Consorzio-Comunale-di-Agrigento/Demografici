package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVTFA_V")
class CivTestoFormula {

    @Id
    @Column(name = "FORMULA")
    String id

    @Column(name = "TESTO")
    String testo

    @Column(name = "TESTO_4000")
    String testoA4

    @Column(name = "TESTO_A3")
    String testoA3

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FORMULA", nullable=false)
    @MapsId
    CivFormulaAnnotazione formula

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Testo")]

}
