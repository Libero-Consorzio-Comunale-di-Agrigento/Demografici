package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.baseDomain.CivMatrimonioBaseDomain

import javax.persistence.Entity
import javax.persistence.Table
import javax.persistence.UniqueConstraint

@Slf4j
@Entity
@Table(name = "CIVMAT_V_CER", uniqueConstraints = @UniqueConstraint(columnNames = ["UFFICIO", "ANNO", "PARTE", "SERIE", "ATTO"]))
class CivMatrimonioCertificazione extends CivMatrimonioBaseDomain {

}