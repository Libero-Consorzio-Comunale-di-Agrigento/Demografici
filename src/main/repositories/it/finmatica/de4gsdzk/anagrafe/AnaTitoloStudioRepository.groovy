package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaTitoloStudioRepository extends JpaRepository<AnaTitoloStudio, String> {

    @Query("""
        SELECT a FROM AnaTitoloStudio a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE a.codice = :codice
    """)
    AnaTitoloStudio findByCodice(@Param("codice") String codice)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaTitoloStudio a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE UPPER(a.codice) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaTitoloStudio a
        WHERE UPPER(a.codice) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """
    )
    Page<AnaTitoloStudio> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(String codice)


}