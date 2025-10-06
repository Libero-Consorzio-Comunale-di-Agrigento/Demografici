package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia

import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente

import javax.persistence.*

@Embeddable
class IndirizzoResidenteFamiglia implements IIndirizzoResidente {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_VIA", nullable = false)
    ArcVia via

    @Column(name = "NUM_CIV", nullable = false)
    Long numeroCivico

    @Column(name = "SUFFISSO")
    String suffisso

    @Column(name = "INTERNO")
    Long interno

    @Column(name = "SUB_INTERNO")
    String subInterno

    @Column(name = "SCALA")
    String scala

    @Column(name = "PIANO")
    String piano

    @Column(name = "CIVICO_INTERNO", insertable = false, updatable = false)
    String civicoInternoFormatted

    @Column(name = "CIVICO_ESTERNO", insertable = false, updatable = false)
    String civicoEsternoFormatted

    @Override
    String getViaFormatted() {
        return "$via.denominazione ${civicoEsternoFormatted?:""} ${civicoInternoFormatted?:""}"
    }

    static final List<Map> etichetteDomain = [Etichette.Via]

}
