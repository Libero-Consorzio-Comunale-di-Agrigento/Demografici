package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.GsdFamigliaBaseDomain
import org.hibernate.annotations.Immutable
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Immutable
@Table(name = "ANAFAM_V")
class AnaFamiglia extends GsdFamigliaBaseDomain {

}
