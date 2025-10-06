package it.finmatica.de4gsdzk.pagamento

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.RicercaPagamentoInviato
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface WspaPagamentoInviatoCustomRepository {

    Page<WspaPagamentoInviato> findAll(RicercaPagamentoInviato r, Pageable p)
}
