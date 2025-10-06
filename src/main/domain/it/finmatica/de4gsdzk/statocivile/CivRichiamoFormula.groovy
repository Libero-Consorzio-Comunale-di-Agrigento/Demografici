package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVDRF")
class CivRichiamoFormula extends CivRichiamoBaseDomain {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FORMULA")
    CivFormulaAnnotazione formula

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DEFAULT", nullable = true)
    Boolean predefinito

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RICORRENTE", nullable = true)
    Boolean ricorrente

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TESTO_FISSO", nullable = true)
    Boolean testoFisso

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AGGIUNTA_A_CAPO", nullable = true)
    Boolean aCapo

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Formula,
                                              Etichette.Default, Etichette.Ricorrente,
                                              Etichette.Testo_fisso, Etichette.Testo_ACapo]
}
