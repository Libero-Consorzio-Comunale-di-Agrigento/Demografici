package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscita
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivVisualizzazioneDocumentiUscitaRepository extends JpaRepository<CivVisualizzazioneDocumentiUscita, String> {

    @Query("""SELECT DISTINCT(c.annoProtocollo) FROM CivVisualizzazioneDocumentiUscita c 
               WHERE c.registro.id=:idRegistro
                 AND c.annoProtocollo IS NOT NULL ORDER BY 1""")
    List<Integer> findAllAnniByIdRegistro(@Param("idRegistro") Integer idRegistro)

    @Query(value = """
        SELECT c FROM CivVisualizzazioneDocumentiUscita c WHERE c.registro IS NULL
        AND (:dts=TRUE OR c.idTrasportoESeppellimento IS NULL)
        AND (:dts=FALSE OR c.idTrasportoESeppellimento IS NOT NULL)
        AND (:filtro IS NULL OR UPPER(c.cognome) LIKE :filtro OR UPPER(c.nome) LIKE :filtro) """)
    Page<CivVisualizzazioneDocumentiUscita> findAllNonAssociatiByDTS(
            @Param("dts") Boolean dts,
            @Param("filtro") String filtro, Pageable pageable)

    @Query(value = """
        SELECT c FROM CivVisualizzazioneDocumentiUscita c INNER JOIN c.registro
        WHERE c.registro.id = :idRegistro
        AND c.numeroProtocollo IS NOT NULL AND c.annoProtocollo IS NOT NULL  
        AND (:anno IS NULL OR c.annoProtocollo = :anno)
        AND (:filtro IS NULL OR UPPER(c.cognome) LIKE :filtro OR UPPER(c.nome) LIKE :filtro)""")
    Page<CivVisualizzazioneDocumentiUscita> findAllAssociatiNumeratiByIdRegistro(
            @Param("idRegistro") Integer idRegistro,
            @Param("anno") Integer anno,
            @Param("filtro") String filtro, Pageable pageable)

    @Query(value = """
        SELECT c FROM CivVisualizzazioneDocumentiUscita c INNER JOIN c.registro
        WHERE c.registro.id = :idRegistro
        AND (c.numeroProtocollo IS NULL OR c.annoProtocollo IS NULL) 
        AND (:anno IS NULL OR c.annoProtocollo = :anno)
        AND (:filtro IS NULL OR UPPER(c.cognome) LIKE :filtro OR UPPER(c.nome) LIKE :filtro)""")
    Page<CivVisualizzazioneDocumentiUscita> findAllAssociatiNonNumeratiByIdRegistro(
            @Param("idRegistro") Integer idRegistro,
            @Param("anno") Integer anno,
            @Param("filtro") String filtro, Pageable pageable)
}