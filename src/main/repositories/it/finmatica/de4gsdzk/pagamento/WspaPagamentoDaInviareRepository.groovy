package it.finmatica.de4gsdzk.pagamento

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface WspaPagamentoDaInviareRepository extends JpaRepository<WspaPagamentoDaInviare, Long> {

    @Query(value = """SELECT o FROM WspaPagamentoDaInviare o 
                        JOIN FETCH o.certificatoEmesso ce
                        JOIN FETCH ce.tipoCertificato tc
                       WHERE ce.tipoPagamento.flagPagamentoPagoPA = java.lang.Boolean.TRUE""",
            countQuery = """SELECT count(o) FROM WspaPagamentoDaInviare o 
                                JOIN o.certificatoEmesso ce
                                JOIN ce.tipoCertificato tc
                               WHERE ce.tipoPagamento.flagPagamentoPagoPA = java.lang.Boolean.TRUE""")
    Page<WspaPagamentoDaInviare> findAllByCertificatoEmessoTipoPagamentoFlagPagamentoPagoPATrue(Pageable pageable)

    @Query(value = """SELECT o FROM WspaPagamentoDaInviare o 
                        JOIN FETCH o.certificatoEmesso ce
                        JOIN FETCH ce.tipoCertificato tc""",
            countQuery = """SELECT count(o) FROM WspaPagamentoDaInviare o 
                                JOIN o.certificatoEmesso ce
                                JOIN ce.tipoCertificato tc""")
    Page<WspaPagamentoDaInviare> findAll(Pageable pageable)

}
