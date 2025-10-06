package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagParametro
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagParametroRepository extends JpaRepository<DepagParametro, String> {

    DepagParametro findById(String id)

    @Query("""SELECT a FROM DepagParametro a 
                      WHERE a.flagVisibile = java.lang.Boolean.TRUE 
                        AND (UPPER(a.descrizione) LIKE UPPER(:filtro) OR UPPER(a.id) LIKE UPPER(:filtro) OR UPPER(a.note) LIKE UPPER(:filtro)) """)
    Page<DepagParametro> findAllByIdLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    List<DepagParametro> findAllByIdIn(List<String> lista)
}
