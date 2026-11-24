package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaTipoProvvedimentoRepository extends JpaRepository<AnaTipoProvvedimento, Integer> {

    @Query("""
        SELECT a FROM AnaTipoProvvedimento a
        LEFT JOIN FETCH a.terminalista
        WHERE a.codice = :codice
    """)
    AnaTipoProvvedimento findByCodice(@Param("codice") Integer codice)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaTipoProvvedimento a
            LEFT JOIN FETCH a.terminalista
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaTipoProvvedimento a
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<AnaTipoProvvedimento> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(Integer codice)
}