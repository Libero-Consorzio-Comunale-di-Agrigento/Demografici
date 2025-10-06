package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivLuogoDecessoRepository extends JpaRepository<CivLuogoDecesso, Integer> {

    CivLuogoDecesso findById(Integer id)

    Page<CivLuogoDecesso> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    @Query("""SELECT DISTINCT(c.ricevuto) FROM CivLuogoDecesso c 
                                          WHERE UPPER(c.ricevuto) LIKE UPPER(:filtro) 
                                            AND c.ricevuto IS NOT NULL """)
    List<String> findAllDistinctRicevutoDaByRicevutoDaLike(@Param("filtro") String filtro)

}