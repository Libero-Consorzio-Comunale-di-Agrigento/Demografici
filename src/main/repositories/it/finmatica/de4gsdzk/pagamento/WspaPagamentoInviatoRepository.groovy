package it.finmatica.de4gsdzk.pagamento

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface WspaPagamentoInviatoRepository extends JpaRepository<WspaPagamentoInviato, Long>, WspaPagamentoInviatoCustomRepository {

    WspaPagamentoInviato findByAnnoAndProgressivo(Integer anno, Integer progressivo)

    @Query(value = """SELECT p FROM WspaPagamentoInviato p
                LEFT JOIN FETCH p.documenti d
                LEFT JOIN FETCH d.certificatoEmesso c
                LEFT JOIN FETCH c.tipoCertificato
                LEFT JOIN FETCH c.terminalista""",
            countQuery = """SELECT count(p) FROM WspaPagamentoInviato p
                LEFT JOIN p.documenti d
                LEFT JOIN d.certificatoEmesso c
                LEFT JOIN c.tipoCertificato
                LEFT JOIN c.terminalista""")
    Page<WspaPagamentoInviato> findAll(Pageable p)
}
