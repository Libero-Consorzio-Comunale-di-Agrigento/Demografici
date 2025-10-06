package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.certificazione.CerMotivoEsenzioneBolloBaseDomain

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("ANSC")
class AnscMotivoEsenzioneBollo extends CerMotivoEsenzioneBolloBaseDomain {
}
