package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaMotivoRilascioRepository extends JpaRepository<AnaMotivoRilascio, Integer> {

    @Query("""
        SELECT a FROM AnaMotivoRilascio a
        LEFT JOIN FETCH a.terminalista
        WHERE a.codice = :codice
    """)
    AnaMotivoRilascio findByCodice(@Param("codice") Integer codice)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaMotivoRilascio a
            LEFT JOIN FETCH a.terminalista
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaMotivoRilascio a
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<AnaMotivoRilascio> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(Integer codice)
}