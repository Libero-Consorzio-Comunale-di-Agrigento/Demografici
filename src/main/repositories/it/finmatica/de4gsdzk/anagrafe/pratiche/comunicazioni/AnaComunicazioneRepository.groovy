package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaComunicazioneRepository extends JpaRepository<AnaComunicazione, Integer> {

    @Query("""
        SELECT a FROM AnaComunicazione a
        LEFT JOIN FETCH a.modello
        LEFT JOIN FETCH a.terminalista
        LEFT JOIN FETCH a.enteDestinatario
        LEFT JOIN FETCH a.tipoDocumento
        WHERE a.id = :id
    """)
    AnaComunicazione findById(@Param("id") Integer id)

    long countById(Integer id)

    @Query(
        value = """
            SELECT DISTINCT a FROM AnaComunicazione a
            LEFT JOIN FETCH a.modello
            LEFT JOIN FETCH a.terminalista
            WHERE a.tipoComunicazione = :tipoComunicazione
              AND (CAST(a.id AS string) LIKE :filtro
               OR UPPER(a.descrizioneEstesa) LIKE UPPER(:filtro))
        """,
        countQuery = """
            SELECT COUNT(a) FROM AnaComunicazione a
            WHERE a.tipoComunicazione = :tipoComunicazione
              AND (CAST(a.id AS string) LIKE :filtro
               OR UPPER(a.descrizioneEstesa) LIKE UPPER(:filtro))
        """
    )
    Page<AnaComunicazione> findAllByTipoComunicazioneAndFiltroLike(
        @Param("tipoComunicazione") ETipoComunicazioneAnagrafe tipoComunicazione,
        @Param("filtro") String filtro,
        Pageable pageable
    )

}
