package it.finmatica.de4gsdzk.ansc

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnpUtenteRepository extends JpaRepository<AnpUtente, String> {

    AnpUtente findById(String id)

    @Query(value="""
              SELECT DISTINCT u FROM AnpUtente u
              WHERE UPPER(u.cognome) LIKE UPPER(:filtro)
                 OR UPPER(u.nome) LIKE UPPER(:filtro)
                 OR UPPER(u.id) LIKE UPPER(:filtro)""",
            countQuery = """SELECT COUNT(DISTINCT u) FROM AnpUtente u
              WHERE UPPER(u.cognome) LIKE UPPER(:filtro)
                 OR UPPER(u.nome) LIKE UPPER(:filtro)
                 OR UPPER(u.id) LIKE UPPER(:filtro)""")
    Page<AnpUtente> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

}