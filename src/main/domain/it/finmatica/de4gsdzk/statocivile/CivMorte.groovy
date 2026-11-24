package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.baseDomain.CivMorteBaseDomain

import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "CIVMOR_V")
class CivMorte extends CivMorteBaseDomain {

}
