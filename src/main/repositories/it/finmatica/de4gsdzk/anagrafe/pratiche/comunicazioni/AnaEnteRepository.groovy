package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.IEnteRepository
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaEnteRepository extends JpaRepository<AnaEnte, Integer>, IEnteRepository {

    @Query("""
        SELECT a FROM AnaEnte a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE a.id = :codice
    """)
    AnaEnte findByCodice(@Param("codice") Integer codice)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaEnte a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE (UPPER(CAST(a.id AS string)) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro))
           AND a.sigla IS NULL
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaEnte a
         WHERE (UPPER(CAST(a.id AS string)) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro))
           AND a.sigla IS NULL
    """
    )
    Page<AnaEnte> findAllByFiltroLikeAndSiglaNull(@Param("filtro") String filtro, Pageable pageable)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaEnte a
        LEFT JOIN FETCH a.codiceAnpr
         WHERE (UPPER(CAST(a.id AS string)) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro))
           AND a.sigla IS NOT NULL
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaEnte a
        WHERE (UPPER(CAST(a.id AS string)) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro))
           AND a.sigla IS NOT NULL
    """
    )
    Page<AnaEnte> findAllByFiltroLikeAndSiglaNotNull(@Param("filtro") String filtro, Pageable pageable)

    AnaEnte findById(Integer id)

    Page<AnaEnte> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    List<AnaEnte> findAllByTipoEnteDestinatario(ETipoEnteDestinatario tipoEnteDestinatario, Sort sort)

    List<AnaEnte> findAllByTipoEnteDestinatarioAndIdNotInOrderByDescrizione(ETipoEnteDestinatario tipoEnteDestinatario, List<Integer> listaId)

    long countById(Integer idEnte)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaEnte a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE a.codiceAnpr IS NOT NULL
        ORDER BY a.descrizione ASC
    """
    )
    List<AnaEnte> findAllByCodiceAnprNotNull()

    @Query(
            value = """
        SELECT a FROM AnaEnte a
        WHERE a.cdf IS NULL OR a.cdf = java.lang.Boolean.FALSE
        ORDER BY a.descrizione ASC
    """
    )
    List<AnaEnte> findAllByCdfIsFalse()


}
