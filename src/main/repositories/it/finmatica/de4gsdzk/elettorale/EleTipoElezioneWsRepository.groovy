package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface EleTipoElezioneWsRepository extends JpaRepository<EleTipoElezioneWs, Long> {

    @Query(
        value = """
            SELECT e FROM EleTipoElezioneWs e
            WHERE UPPER(e.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(e) FROM EleTipoElezioneWs e
            WHERE UPPER(e.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<EleTipoElezioneWs> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)
}