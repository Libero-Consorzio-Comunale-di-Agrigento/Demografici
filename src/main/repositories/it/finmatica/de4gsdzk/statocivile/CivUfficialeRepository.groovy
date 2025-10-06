package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivUfficiale
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivUfficialeRepository extends JpaRepository<CivUfficiale, Integer> {

    CivUfficiale findById(Integer id)

    CivUfficiale findByCognomeNome(String val)

    @Query("""SELECT (COALESCE(MAX(u.id), 0) + 1) AS ID FROM CivUfficiale u """)
    Object[] findMaxId()

    @Query("SELECT DISTINCT(u.qualifica) FROM CivUfficiale u WHERE UPPER(u.qualifica) LIKE UPPER(:filtro) AND u.qualifica IS NOT NULL")
    List<String> findAllDistinctQualificaByQualificaLike(@Param("filtro") String filtro)

    List<CivUfficiale> findAllByCognomeNomeLikeIgnoreCaseOrderByCognomeNome(String filtro)

    Page<CivUfficiale> findAllByCognomeNomeLikeIgnoreCaseOrQualificaLikeIgnoreCase(String filtroCn, String filtroQualifica, Pageable pageable)

}