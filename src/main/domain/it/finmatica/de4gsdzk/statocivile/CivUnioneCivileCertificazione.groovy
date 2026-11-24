package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.baseDomain.CivUnioneCivileBaseDomain

import javax.persistence.Entity
import javax.persistence.Table

@Slf4j
@Entity
@Table(name = "CIVUCI_V_CER")
class CivUnioneCivileCertificazione extends CivUnioneCivileBaseDomain {

}