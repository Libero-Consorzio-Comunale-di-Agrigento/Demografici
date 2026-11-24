package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.baseDomain.CivCittadinanzaBaseDomain

import javax.persistence.Entity
import javax.persistence.Table

@Slf4j
@Entity
@Table(name = "CIVCIT_V")
class CivCittadinanza extends CivCittadinanzaBaseDomain {

}