package it.finmatica.de4gsdzk.archivi

import it.finmatica.de4gsdzk.ArcComuneBaseDomain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.Transient

@Entity
@Table(name = "ARCCOM_V")
class ArcComune extends ArcComuneBaseDomain{

    @Column(name = "COD_COM_FUSIONE", nullable = false)
    Integer codiceComuneFusione

    @Column(name = "COD_PRO_FUSIONE", nullable = false)
    Integer codiceProvinciaFusione

    @Transient
    Boolean isStorico = Boolean.FALSE

}
