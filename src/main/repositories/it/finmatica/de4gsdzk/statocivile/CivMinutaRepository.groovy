package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMinutaRepository extends JpaRepository<CivMinuta, Long> {

    @Query("SELECT m FROM CivMinuta m LEFT OUTER JOIN FETCH m.categoriaDomain WHERE m.id = :id")
    CivMinuta findById(@Param("id") Long id)

    @Query("SELECT m FROM CivMinuta m LEFT OUTER JOIN FETCH m.categoriaDomain LEFT OUTER JOIN FETCH m.testo WHERE m.id = :id")
    CivMinuta findWithTestoById(@Param("id") Long id)

    @Query(value = """SELECT c FROM CivMinuta c LEFT OUTER JOIN FETCH c.categoriaDomain
                       WHERE c.tipoAtto = :tipoAtto""",
            countQuery = """SELECT count(c) FROM CivMinuta c LEFT OUTER JOIN c.categoriaDomain  
                             WHERE c.tipoAtto = :tipoAtto """)
    Page<CivMinuta> findAllByTipoAtto(@Param("tipoAtto") Integer tipoAtto, Pageable pageable)

    @Query(value = """SELECT c FROM CivMinuta c LEFT OUTER JOIN FETCH c.categoriaDomain
                       WHERE c.tipoAtto = :tipoAtto 
                         AND ( UPPER(c.codiceDescrizione) LIKE UPPER(:filtro) OR UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) )""",
            countQuery = """SELECT count(c) FROM CivMinuta c LEFT OUTER JOIN c.categoriaDomain  
                             WHERE c.tipoAtto = :tipoAtto 
                               AND ( UPPER(c.codiceDescrizione) LIKE UPPER(:filtro) OR UPPER(c.descrizioneEstesa) LIKE UPPER(:filtro) ) """)
    Page<CivMinuta> findAllByTipoAttoAndDescrizioneLike(@Param("tipoAtto") Integer tipoAtto, @Param("filtro") String filtro, Pageable pageable)

    Integer countByTipoAttoAndCodice(Integer tipoAtto, Integer codice)
}