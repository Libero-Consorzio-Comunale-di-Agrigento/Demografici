package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.GsdFamigliaBaseDomain
import org.hibernate.annotations.Immutable

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Entity
@Immutable
@Table(name = "ANAFAM_STORICO_V")
class AnaFamigliaStorico extends GsdFamigliaBaseDomain {

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_RES", nullable = false)
    Date dataInizioResidenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_RES", nullable = false)
    Date dataFineResidenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_FAM", nullable = false)
    Date dataInizioFamiglia

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FINE_FAM", nullable = false)
    Date dataFineFamiglia

}
