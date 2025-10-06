package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepPagamentoDaInviare
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface NextStepPagamentoDaInviareRepository extends JpaRepository<NextStepPagamentoDaInviare, Long>, NextStepPagamentoDaInviareCustomRepository {

    @Query(value = """SELECT o FROM NextStepPagamentoDaInviare o 
                        JOIN FETCH o.certificatoEmesso ce
                        JOIN FETCH ce.tipoCertificato tc""",
            countQuery = """SELECT count(o) FROM NextStepPagamentoDaInviare o 
                                JOIN o.certificatoEmesso ce
                                JOIN ce.tipoCertificato tc""")
    Page<NextStepPagamentoDaInviare> findAll(Pageable pageable)

}
