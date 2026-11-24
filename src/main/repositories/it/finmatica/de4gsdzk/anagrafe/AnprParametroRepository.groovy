package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnprParametroRepository extends JpaRepository<AnprParametro, String> {

    AnprParametro findByParametro(String parametro)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnprParametro a
            WHERE a.flagVisibile = true
              AND (UPPER(a.parametro) LIKE UPPER(:filtro)
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.valore) LIKE UPPER(:filtro))
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnprParametro a
            WHERE a.flagVisibile = true
              AND (UPPER(a.parametro) LIKE UPPER(:filtro)
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
               OR UPPER(a.valore) LIKE UPPER(:filtro))
        """
    )
    Page<AnprParametro> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByParametro(String parametro)

}
