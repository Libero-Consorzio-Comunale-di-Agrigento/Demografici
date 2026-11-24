package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.utils.ETipoModello
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaModelloEnteRepository extends JpaRepository<AnaModelloEnte, Long> {

    @Query("""
        SELECT a FROM AnaModelloEnte a
        LEFT JOIN FETCH a.ente
        LEFT JOIN FETCH a.modello
        WHERE a.id = :id
    """)
    AnaModelloEnte findById(@Param("id") Long id)

    long countByModelloAndEnte(AnaModello modello, AnaEnte ente)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaModelloEnte a
            LEFT JOIN FETCH a.ente e
            LEFT JOIN FETCH a.modello m
            WHERE a.tipoModello = :tipoModello
              AND (CAST(a.id AS string) LIKE :filtro
               OR UPPER(a.codModello) LIKE UPPER(:filtro))
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaModelloEnte a
            WHERE a.tipoModello = :tipoModello
              AND (CAST(a.id AS string) LIKE :filtro
               OR UPPER(a.codModello) LIKE UPPER(:filtro))
        """
    )
    Page<AnaModelloEnte> findAllByTipoModelloAndFiltroLike(@Param("tipoModello") ETipoModello tipoModello, @Param("filtro") String filtro, Pageable pageable)

    List<AnaModelloEnte> findAllByTipoModello(ETipoModello tipoModello)
}