package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivArchivioComunicazione
import it.finmatica.de4gsdzk.utils.EStatoInvioAlbo
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivArchivioComunicazioneRepository extends JpaRepository<CivArchivioComunicazione, Long>, CivArchivioComunicazioneCustomRepository {

    @Query("""SELECT c FROM CivArchivioComunicazione c JOIN FETCH c.comunicazione WHERE c.id = :id """)
    CivArchivioComunicazione findById(@Param("id") Long id)

    @Query("SELECT c.statoProtocollazione FROM CivArchivioComunicazione c WHERE c.id = :id ")
    EStatoProtocollazione findStatoProtocollazione(@Param("id") Long id)

    @Query("SELECT c.statoInvioAlbo FROM CivArchivioComunicazione c WHERE c.id = :id ")
    EStatoInvioAlbo findStatoInvioAlbo(@Param("id") Long id)

    @Query("SELECT c.stampaEseguita FROM CivArchivioComunicazione c WHERE c.id = :id ")
    Boolean findStampaEseguita(@Param("id") Long id)

    @Query("""SELECT COUNT(c) AS NUM_ALLE_PRINCIPALE 
                FROM CivComunicazioneAllegato c 
               WHERE c.principale = java.lang.Boolean.TRUE 
                 AND c.archivioComunicazione.id = :idArcCom """)
    Integer checkAllegatoPrincipale(@Param("idArcCom") Long idArcCom)

    // Tutti i parametri devono essere valorizzati
    @Query("""SELECT c FROM CivArchivioComunicazione c
               WHERE c.ufficio = :ufficio 
                 AND c.anno = :anno 
                 AND c.atto = :atto
                 AND COALESCE(c.parte, :parte) = :parte
                 AND COALESCE(c.serie, :serie) = :serie
                 AND c.tipoAtto = :tipoAtto
                 AND c.formula = :formula 
                 AND c.dataRegistrazione = :dataRegistrazione
                 AND COALESCE(c.sequenza, :sequenza) = :sequenza """)
    List<CivArchivioComunicazione> findAllComunicazioniDaAnnotazione(@Param("ufficio") Integer ufficio,
                                                                     @Param("anno") Integer anno,
                                                                     @Param("atto") Integer atto,
                                                                     @Param("parte") Integer parte,
                                                                     @Param("serie") String serie,
                                                                     @Param("tipoAtto") Integer tipoAtto,
                                                                     @Param("formula") String formula,
                                                                     @Param("dataRegistrazione") Date dataRegistrazione,
                                                                     @Param("sequenza") Integer sequenza)

    @Query(value = """SELECT c FROM CivArchivioComunicazione c JOIN FETCH c.comunicazione LEFT JOIN FETCH c.formulaDfa 
                       WHERE c.tipoAtto = :tipoAtto 
                         AND c.stampaEseguita = :stampaEseguita 
                         AND EXISTS (SELECT 'x' FROM CivComunicazioneDestinatario d
                                      WHERE d.ente.id = :idEnte 
                                        AND d.archivioComunicazione.id = c.id) """,
            countQuery = """SELECT count(c) FROM CivArchivioComunicazione c JOIN c.comunicazione LEFT JOIN c.formulaDfa
                       WHERE c.tipoAtto = :tipoAtto 
                         AND c.stampaEseguita = :stampaEseguita 
                         AND EXISTS (SELECT 'x' FROM CivComunicazioneDestinatario d
                                      WHERE d.ente.id = :idEnte 
                                        AND d.archivioComunicazione.id = c.id) """)
    Page<CivArchivioComunicazione> findAllByTipoAttoAndEnteDestinatarioAndStampaEseguita(@Param("tipoAtto") Integer tipoAtto, @Param("idEnte") Integer idEnte
                                                                                         , @Param("stampaEseguita") Boolean stampaEseguita, Pageable pageable)

    @Query(value = """SELECT c FROM CivArchivioComunicazione c JOIN FETCH c.comunicazione LEFT JOIN FETCH c.formulaDfa 
               WHERE c.tipoAtto = :tipoAtto 
                 AND c.stampaEseguita = :stampaEseguita
                 AND EXISTS (SELECT 'x' FROM CivComunicazioneDestinatario d
                                  WHERE d.codiceComuneDestinatario = :codiceComune
                                    AND d.codiceProvinciaDestinatario = :codiceProvincia
                                    AND d.archivioComunicazione.id = c.id) """,
            countQuery = """SELECT count(c) FROM CivArchivioComunicazione c JOIN c.comunicazione LEFT JOIN c.formulaDfa
               WHERE c.tipoAtto = :tipoAtto 
                 AND c.stampaEseguita = :stampaEseguita
                 AND EXISTS (SELECT 'x' FROM CivComunicazioneDestinatario d
                                  WHERE d.codiceComuneDestinatario = :codiceComune
                                    AND d.codiceProvinciaDestinatario = :codiceProvincia
                                    AND d.archivioComunicazione.id = c.id) """)
    Page<CivArchivioComunicazione> findAllByTipoAttoAndComuneAndStampaEseguita(@Param("tipoAtto") Integer tipoAtto, @Param("codiceComune") Integer codiceComune
                                                                               , @Param("codiceProvincia") Integer codiceProvincia, @Param("stampaEseguita") Boolean stampaEseguita
                                                                               , Pageable pageable)

}