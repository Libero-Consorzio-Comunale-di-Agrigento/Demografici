package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaCittadinanzaRepository extends JpaRepository<AnaCittadinanza, String> {

    AnaCittadinanza findByCodCi(String codCi)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaCittadinanza a
        WHERE UPPER(a.codCi) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaCittadinanza a
        WHERE UPPER(a.codCi) LIKE UPPER(:filtro)
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """
    )
    Page<AnaCittadinanza> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodCi(String codice)

}