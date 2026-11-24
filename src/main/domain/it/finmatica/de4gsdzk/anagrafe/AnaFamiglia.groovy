package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.GsdFamigliaBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.hibernate.annotations.Immutable

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "ANAFAM_V")
class AnaFamiglia extends GsdFamigliaBaseDomain {

    @Column(name = "NUMERO_COMPONENTI", nullable = false, updatable = false, insertable = false)
    Integer numeroComponenti

    @Column(name = "ID_FAMIGLIA_ANPR", nullable = false, updatable = false, insertable = false)
    Long idFamigliaAnpr
}
