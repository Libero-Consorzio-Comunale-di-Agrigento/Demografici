package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVNFA", uniqueConstraints = @UniqueConstraint(columnNames=["FORMULA", "VARIABILE"]))
class CivNotaFormula {

    public static final int MAX_NOTA_FORMULA_ELEMENTS = 30

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="FORMULA", nullable = false)
    CivFormulaAnnotazione formula

    @Column(name = "VARIABILE")
    Integer variabile

    @Column(name = "TESTO_VAR", nullable = true)
    String testoVariabile

    @Column(name = "TESTO_M", nullable = true)
    String testoMaschile

    @Column(name = "TESTO_F", nullable = true)
    String testoFemminile

    @Column(name = "NOTE")
    String note

    @Column(name = "TESTO_AUTO", nullable = true)
    String testoAutomatico

    @Column(name = "TESTO_VAR_AUTO", nullable = true)
    String testoVariabileAutomatico

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Valore"), Etichette.getEtichetta("Testo_fisso"),
                                              Etichette.getEtichetta("Testo_Fisso_Maschile"), Etichette.getEtichetta("Testo_Fisso_Femminile"), Etichette.getEtichetta("Note")]
}
