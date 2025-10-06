package it.finmatica.de4gsdzk.pagamento.nextstep


import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("NEXTSTEP")
class NextStepVoceCosto extends WspaVoceCosto {
}
