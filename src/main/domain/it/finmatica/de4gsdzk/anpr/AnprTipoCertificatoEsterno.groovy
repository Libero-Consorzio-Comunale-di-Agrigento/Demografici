package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.certificazione.CerTipoCertificatoEsternoBaseDomain

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("ANPR")
class AnprTipoCertificatoEsterno extends CerTipoCertificatoEsternoBaseDomain {
}
