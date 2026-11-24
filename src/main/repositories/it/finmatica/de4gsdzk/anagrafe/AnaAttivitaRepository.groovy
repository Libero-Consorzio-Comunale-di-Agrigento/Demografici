package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaAttivitaRepository extends JpaRepository<AnaAttivita, Integer> {

    @Query("""
        SELECT a FROM AnaAttivita a
        LEFT JOIN FETCH a.terminalista
        WHERE a.codice = :codice
    """)
    AnaAttivita findByCodice(@Param("codice") Integer codice)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaAttivita a
            LEFT JOIN FETCH a.terminalista
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaAttivita a
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<AnaAttivita> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(Integer codice)
}
