package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAllegato
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAtto
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegato
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFascicoloAttoAllegatoRepository extends JpaRepository<CivFascicoloAttoAllegato, Long> {

    @Query("""SELECT c FROM CivFascicoloAttoAllegato c INNER JOIN FETCH c.fascicoloAtto LEFT OUTER JOIN FETCH c.allegatoComunicazione
               WHERE c.id = :id """)
    CivFascicoloAttoAllegato findById(@Param("id") Long id)

    @Query("""SELECT c.allegatoComunicazione FROM CivFascicoloAttoAllegato c 
                INNER JOIN c.allegatoComunicazione 
               WHERE c.id = :id """)
    CivComunicazioneAllegato findComunicazioneAllegatoByIdFascicoloAllegato(@Param("id") Long id)

    @Query(value = """SELECT c FROM CivFascicoloAttoAllegato c 
                       INNER JOIN FETCH c.fascicoloAtto fas INNER JOIN FETCH fas.tipoDocumentoFascicolo 
                        LEFT OUTER JOIN FETCH c.allegatoComunicazione
                       WHERE fas.id = :idFascicoloAtto AND c.allegatoComunicazione.id = :idComAlle """)
    CivFascicoloAttoAllegato findByIdFascicoloAttoAndIdComunicazioneAllegato(@Param("idFascicoloAtto") Long idFascicoloAtto, @Param("idComAlle") Long idComAlle)

    @Query(value = """SELECT c FROM CivFascicoloAttoAllegato c 
                      INNER JOIN FETCH c.fascicoloAtto 
                      INNER JOIN FETCH c.utenteIns 
                      LEFT OUTER JOIN FETCH c.allegatoComunicazione
                       WHERE c.fascicoloAtto.id = :idFascicoloAtto 
                       ORDER BY c.lastUpdated DESC """)
    List<CivFascicoloAttoAllegato> findAllByIdFascicoloAttoOrderByDataModifica(@Param("idFascicoloAtto") Long idFascicoloAtto)

    @Query(value = """SELECT c FROM CivFascicoloAttoAllegato c INNER JOIN FETCH c.fascicoloAtto fas INNER JOIN FETCH fas.tipoDocumentoFascicolo 
                       WHERE fas.idAtto = :identificativoAtto 
                         AND fas.tipoDocumentoFascicolo in ( 
                                    SELECT c.tipoDocumentoFascicolo FROM AnscEndPointServizioAllegato c 
                                     INNER JOIN c.servizio INNER JOIN c.tipoDocumentoFascicolo
                                     WHERE c.servizio = :servizio 
                                       AND c.idCasoUso = :idCasoUso
                                       AND c.tipoDocumentoFascicolo.tipoAtto = :tipoAtto)
                         AND (:checkHash = java.lang.Boolean.FALSE OR c.hashAllegatoAnsc IS NOT NULL)
                       ORDER BY fas.tipoDocumentoFascicolo.descrizione, c.lastUpdated DESC """)
    List<CivFascicoloAttoAllegato> findAllByUkAttoAndServizioAndCasoUsoAndCheckHashOrdered(@Param("identificativoAtto") String identificativoAtto,
                                                                                           @Param("servizio") AnscEndPointServizio servizio, @Param("idCasoUso") Long idCasoUso,
                                                                                           @Param("tipoAtto") Integer tipoAtto, @Param("checkHash") boolean checkHash)

    @Query(value = """SELECT c FROM CivFascicoloAttoAllegato c INNER JOIN FETCH c.fascicoloAtto fas INNER JOIN FETCH fas.tipoDocumentoFascicolo 
                       WHERE fas.idAtto = :identificativoAtto 
                         AND fas.tipoDocumentoFascicolo = :tipoDocumentoFascicolo
                         AND (:checkHash = java.lang.Boolean.FALSE OR c.hashAllegatoAnsc IS NOT NULL)
                       ORDER BY fas.tipoDocumentoFascicolo.descrizione, c.lastUpdated DESC """)
    List<CivFascicoloAttoAllegato> findAllByUkAttoAndTipoDocumentoFascicoloCheckHashOrdered(@Param("identificativoAtto") String identificativoAtto,
                                                                                            @Param("tipoDocumentoFascicolo") CivTipoDocumentoFascicolo tipoDocumentoFascicolo,
                                                                                            @Param("checkHash") boolean checkHash)

    long countByFascicoloAtto(CivFascicoloAtto fascicoloAtto)

    @Query("""SELECT COUNT(c) AS NUM_ALLEGATI FROM CivFascicoloAttoAllegato c 
               WHERE c.fascicoloAtto.id = :idFascicoloAtto 
                 AND (:id IS NULL OR c.id != :id)
                 AND UPPER(c.nome) LIKE UPPER(:nomeAllegato) """)
    Integer getNumAllegatiFascicoloByNomeLike(@Param("idFascicoloAtto") Long idFascicoloAtto, @Param("id") Long id,
                                              @Param("nomeAllegato") String nomeAllegato)

    @Query("""SELECT COUNT(c) AS NUM_ALLEGATI FROM CivFascicoloAttoAllegato c 
               WHERE c.fascicoloAtto.id = :idFascicoloAtto 
                 AND (:id IS NULL OR c.id != :id)
                 AND UPPER(c.nome) = UPPER(:nomeAllegato) """)
    Integer getNumAllegatiFascicoloByNome(@Param("idFascicoloAtto") Long idFascicoloAtto, @Param("id") Long id,
                                          @Param("nomeAllegato") String nomeAllegato)

    @Modifying
    @Query("UPDATE CivFascicoloAttoAllegato c SET c.note = :note WHERE c.id = :id")
    void updateNote(@Param(value = "id") Long id, @Param(value = "note") String note)
}