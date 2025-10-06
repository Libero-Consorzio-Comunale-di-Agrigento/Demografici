package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviareCustomRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagPagamentoDaInviareRepository extends JpaRepository<DepagPagamentoDaInviare, Long>, DepagPagamentoDaInviareCustomRepository {

    @Query(value = """SELECT o FROM DepagPagamentoDaInviare o 
                        JOIN FETCH o.certificatoEmesso ce
                        JOIN FETCH ce.tipoCertificato tc
                        JOIN FETCH o.servizio
                       WHERE ce.tipoPagamento.flagPagamentoPagoPA = java.lang.Boolean.TRUE""",
            countQuery = """SELECT count(o) FROM DepagPagamentoDaInviare o 
                                JOIN o.certificatoEmesso ce
                                JOIN ce.tipoCertificato tc
                                JOIN o.servizio
                               WHERE ce.tipoPagamento.flagPagamentoPagoPA = java.lang.Boolean.TRUE""")
    Page<DepagPagamentoDaInviare> findAllByCertificatoEmessoTipoPagamentoFlagPagamentoPagoPATrue(Pageable pageable)


}
