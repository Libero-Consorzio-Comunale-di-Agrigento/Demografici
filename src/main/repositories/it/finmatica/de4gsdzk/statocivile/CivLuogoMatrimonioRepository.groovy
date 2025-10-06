package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivLuogoMatrimonio
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivLuogoMatrimonioRepository extends JpaRepository<CivLuogoMatrimonio, Integer> {

    CivLuogoMatrimonio findById(Integer id)

    List<CivLuogoMatrimonio> findAllByMinistroLikeIgnoreCaseAndMinistroNotNull(String filtro)

    @Query("""SELECT DISTINCT(c.qualita) FROM CivLuogoMatrimonio c WHERE UPPER(c.qualita) LIKE UPPER(:filtro) AND c.ministro IS NOT NULL """)
    List<String> findAllDistinctQualificaLike(@Param("filtro") String filtro)

    Page<CivLuogoMatrimonio> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

}