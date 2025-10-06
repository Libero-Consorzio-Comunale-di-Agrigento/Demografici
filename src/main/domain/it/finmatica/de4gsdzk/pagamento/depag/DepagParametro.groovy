package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.pagamento.WspaParametro

import javax.persistence.DiscriminatorValue
import javax.persistence.Entity

@Entity
@DiscriminatorValue("DEPAG")
class DepagParametro extends WspaParametro {
}
