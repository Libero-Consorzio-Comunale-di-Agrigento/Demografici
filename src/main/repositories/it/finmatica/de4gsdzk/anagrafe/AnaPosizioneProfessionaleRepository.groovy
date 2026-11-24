package it.finmatica.de4gsdzk.anagrafe


import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaPosizioneProfessionaleRepository extends JpaRepository<AnaPosizioneProfessionale, Integer> {

    @Query("""
        SELECT a FROM AnaPosizioneProfessionale a
        LEFT JOIN FETCH a.terminalista
        WHERE a.codice = :codice
    """)
    AnaPosizioneProfessionale findByCodice(@Param("codice") Integer codice)

    @Query("""
        SELECT COUNT(a) FROM AnaPosizioneProfessionale a
        WHERE a.codice = :codice
    """)
    long countByCodice(@Param("codice") Integer codice)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaPosizioneProfessionale a
            LEFT JOIN FETCH a.terminalista
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaPosizioneProfessionale a
            WHERE CAST(a.codice AS string) LIKE :filtro
               OR UPPER(a.descrizione) LIKE UPPER(:filtro)
        """
    )
    Page<AnaPosizioneProfessionale> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)
}