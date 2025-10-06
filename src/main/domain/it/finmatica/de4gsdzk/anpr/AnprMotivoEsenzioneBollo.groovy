package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.certificazione.CerMotivoEsenzioneBolloBaseDomain

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("ANPR")
class AnprMotivoEsenzioneBollo extends CerMotivoEsenzioneBolloBaseDomain {

}
