package it.finmatica.de4gsdzk.pagamento.nextstep

import it.finmatica.de4gsdzk.pagamento.WspaParametro

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("NEXTSTEP")
class NextStepParametro extends WspaParametro {
}
