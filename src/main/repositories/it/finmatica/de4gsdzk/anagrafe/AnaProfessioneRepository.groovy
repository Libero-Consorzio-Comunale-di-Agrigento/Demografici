package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnaProfessioneRepository extends JpaRepository<AnaProfessione, String> {

    @Query("""
        SELECT a FROM AnaProfessione a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE a.id = :id
    """)
    AnaProfessione findById(@Param("id") String id)

    List<AnaProfessione> findAllBySessoOrderByDescrizioneAsc(ESesso sesso)

    @Query(
            value = """
        SELECT DISTINCT a FROM AnaProfessione a
        LEFT JOIN FETCH a.codiceAnpr
        WHERE CAST(a.codice AS string) LIKE :filtro
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """,
            countQuery = """
        SELECT COUNT(a) FROM AnaProfessione a
        WHERE CAST(a.codice AS string) LIKE :filtro
           OR UPPER(a.descrizione) LIKE UPPER(:filtro)
    """
    )
    Page<AnaProfessione> findAllByFiltroLike(@Param("filtro") String filtro, Pageable pageable)

    long countByCodice(Integer codice)

}
