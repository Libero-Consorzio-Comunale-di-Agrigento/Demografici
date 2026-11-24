package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleServizioWsRepository extends JpaRepository<EleServizioWs, Long> {

    @Query(
        value = """
            SELECT e FROM EleServizioWs e
            WHERE UPPER(e.servizio) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(e) FROM EleServizioWs e
            WHERE UPPER(e.servizio) LIKE UPPER(:filtro)   
        """
    )
    Page<EleServizioWs> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

}