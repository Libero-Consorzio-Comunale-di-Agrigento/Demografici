package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaAlberoRepository extends JpaRepository<AnaAlbero, Integer> {

    /**
     * Recupera un albero tramite codice con LEFT JOIN FETCH per evitare LazyInitializationException
     */
    @Query("""
        SELECT a FROM AnaAlbero a
        LEFT JOIN FETCH a.terminalista
        WHERE a.codice = :codice
    """)
    AnaAlbero findByCodice(@Param("codice") Integer codice)

    /**
     * Conta il numero di alberi con il codice specificato (per validazione duplicati)
     */
    long countByCodice(Integer codice)

    /**
     * Ricerca paginata per filtro su codice e descrizione
     */
    @Query(
        value = """
            SELECT DISTINCT a FROM AnaAlbero a
            LEFT JOIN FETCH a.terminalista
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaAlbero a
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<AnaAlbero> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)
}
