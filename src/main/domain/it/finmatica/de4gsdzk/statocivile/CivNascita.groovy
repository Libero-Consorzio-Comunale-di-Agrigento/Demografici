package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.baseDomain.CivNascitaBaseDomain

import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.UniqueConstraint

@Slf4j
@Entity
@Table(name = "CIVNAS_V", uniqueConstraints = @UniqueConstraint(columnNames = ["UFFICIO", "ANNO", "ATTO", "PARTE", "SERIE"]))
class CivNascita extends CivNascitaBaseDomain {

}
