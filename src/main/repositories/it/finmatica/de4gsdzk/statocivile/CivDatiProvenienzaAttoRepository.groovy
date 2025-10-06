package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivDatiProvenienzaAttoRepository extends JpaRepository<CivDatiProvenienzaAtto, Long> {

    @Query("""SELECT c FROM CivDatiProvenienzaAtto c 
                LEFT JOIN FETCH c.consolato
                LEFT JOIN FETCH c.nazionalitaDichiarante
                LEFT JOIN FETCH c.comprensioneDichiarante
               WHERE c.idAtto = :identificativoAtto """)
    CivDatiProvenienzaAtto findByUkAtto(@Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT DISTINCT(c.documentoDecesso) FROM CivDatiProvenienzaAtto c 
               WHERE UPPER(c.documentoDecesso) LIKE UPPER(:filtro) 
                 AND c.documentoDecesso IS NOT NULL """)
    List<String> findAllDistinctDocumentoDecessoByDocumentoDecessoLike(@Param("filtro") String filtro)

}