package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepParametro
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface NextStepParametroRepository extends JpaRepository<NextStepParametro, String> {

    NextStepParametro findById(String id)

    @Query("""SELECT a FROM NextStepParametro a 
                      WHERE a.flagVisibile = java.lang.Boolean.TRUE 
                        AND (UPPER(a.descrizione) LIKE UPPER(:filtro) OR UPPER(a.id) LIKE UPPER(:filtro) OR UPPER(a.note) LIKE UPPER(:filtro)) """)
    Page<NextStepParametro> findAllByIdLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    List<NextStepParametro> findAllByIdIn(List<String> lista)
}
