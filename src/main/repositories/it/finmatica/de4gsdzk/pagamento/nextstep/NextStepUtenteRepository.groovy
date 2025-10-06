package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepUtente
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface NextStepUtenteRepository extends JpaRepository<NextStepUtente, String> {

    NextStepUtente findById(String id)

    long countById(String id)

    @Query("""SELECT a FROM NextStepUtente a 
                      WHERE UPPER(a.id) LIKE UPPER(:filtro) OR UPPER(a.idEsterno) LIKE UPPER(:filtro)""")
    Page<NextStepUtente> findAllByIdLikeIgnoreCaseOrIdentificativoProviderLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)
}
