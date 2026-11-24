package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoModello
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaModelloRepository extends JpaRepository<AnaModello, String> {

    @Query("""
        SELECT a FROM AnaModello a
        LEFT JOIN FETCH a.terminalista
        WHERE a.id = :id
    """)
    AnaModello findById(@Param("id") String id)

    long countById(String id)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaModello a
            LEFT JOIN FETCH a.terminalista
            WHERE a.tipoModello = :tipoModello
              AND (UPPER(a.codModello) LIKE UPPER(:filtro)
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.note) LIKE UPPER(:filtro))
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaModello a
            WHERE a.tipoModello = :tipoModello
              AND (UPPER(a.codModello) LIKE UPPER(:filtro)
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.note) LIKE UPPER(:filtro))
        """
    )
    Page<AnaModello> findAllByTipoModelloAndFiltroLike(@Param("tipoModello") ETipoModello tipoModello, @Param("filtro") String filtro, Pageable pageable)


    List<AnaModello> findAllByTipoModello(ETipoModello tipoModello)
}
