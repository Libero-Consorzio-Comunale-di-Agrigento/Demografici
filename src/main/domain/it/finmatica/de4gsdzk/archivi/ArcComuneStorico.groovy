package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.ArcComuneBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ARCCOM_STORICO")
class ArcComuneStorico extends ArcComuneBaseDomain{

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_VALIDITA", nullable = false)
    Date dataInizioValidita

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_VALIDITA", nullable = false)
    Date dataFineValidita

    @Transient
    Boolean isStorico = Boolean.TRUE

}
