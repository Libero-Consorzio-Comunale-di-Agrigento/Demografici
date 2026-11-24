package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaCategoriaRepository extends JpaRepository<AnaCategoria, Integer> {

    @Query("""
        SELECT a FROM AnaCategoria a
        LEFT JOIN FETCH a.tipoDocumento
        WHERE a.codice = :codice
    """)
    AnaCategoria findByCodice(@Param("codice") Integer codice)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaCategoria a
        LEFT JOIN FETCH a.tipoDocumento
        WHERE CAST(a.codice AS string) LIKE :filtro
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
           OR UPPER(a.tipoDocumento.descrizione) LIKE UPPER(:filtro)
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaCategoria a
        WHERE CAST(a.codice AS string) LIKE :filtro
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
           OR UPPER(a.tipoDocumento.descrizione) LIKE UPPER(:filtro)
    """
    )
    Page<AnaCategoria> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(Integer codice)

    List<AnaCategoria> findAllByTipoDocumentoOrderByDescrizioneAsc(AnaTipoDocumento tipoDocumento)
}