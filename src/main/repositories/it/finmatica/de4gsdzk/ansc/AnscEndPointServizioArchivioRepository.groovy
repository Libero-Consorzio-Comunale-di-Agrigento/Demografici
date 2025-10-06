package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscEndPointServizioArchivioRepository extends JpaRepository<AnscEndPointServizioArchivio, Long> {

    @Query("SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio WHERE c.id = :id ")
    AnscEndPointServizioArchivio findById(@Param("id") Long id)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.servizio.flagVisibile = java.lang.Boolean.TRUE
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioArchivio> findAllByArchivioAndFlagVisibileIsTrueOrderBySequenza(@Param("archivio") ETipoArchivioAnsc archivio)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.servizio.flagConsultazioneEvento = java.lang.Boolean.TRUE AND c.idCasoUso IS NULL""")
    List<AnscEndPointServizioArchivio> findAllByArchivioAndServizioFlagConsultazioneEventoIsTrueAndIdCasoUsoIsNull(@Param("archivio") ETipoArchivioAnsc archivio)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.idCasoUso = :idCasoUso AND c.servizio.flagVisibile = java.lang.Boolean.TRUE
                 AND ( (c.tipoEvento LIKE :tipoEvento) OR 
                       (c.tipoEvento IS NULL AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio b 
                                                              WHERE b.archivio = c.archivio 
                                                                AND b.idCasoUso = c.idCasoUso
                                                                AND b.servizio = c.servizio 
                                                                AND b.tipoEvento LIKE :tipoEvento) ) )
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioArchivio> findAllByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(@Param("archivio") ETipoArchivioAnsc archivio,
                                                                                                       @Param("idCasoUso") Long idCasoUso,
                                                                                                       @Param("tipoEvento") String tipoEvento)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.idCasoUso = :idCasoUso AND c.servizio.flagVisibile = java.lang.Boolean.TRUE
                 AND ( (  c.tipoEvento LIKE :tipoEvento OR 
                         (c.tipoEvento IS NULL AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio b 
                                                                WHERE b.archivio = c.archivio 
                                                                  AND b.idCasoUso = c.idCasoUso
                                                                  AND b.servizio = c.servizio 
                                                                  AND b.tipoEvento LIKE :tipoEvento
                                                               ) 
                         ) 
                       )
                     OR EXISTS (SELECT 1 FROM AnscComunicazioneAtto cat 
                                        WHERE cat.comunicazione.archivioRif = c.archivio AND cat.comunicazione.servizio = c.servizio AND cat.comunicazione.idRif = :pkAtto
                                          AND cat.comunicazione.inviato = java.lang.Boolean.TRUE
                                          AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c2 
                                                                  WHERE c2.archivio = c.archivio
                                                                    AND c2.servizio = c.servizio
                                                                    AND c2.idCasoUso = c.idCasoUso                                                                     
                                                                    AND (  c2.tipoEvento LIKE :tipoEvento OR 
                                                                          (c2.tipoEvento IS NULL AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c3 
                                                                                                                  WHERE c3.archivio = c2.archivio 
                                                                                                                    AND c3.idCasoUso = c2.idCasoUso
                                                                                                                    AND c3.servizio = c2.servizio 
                                                                                                                    AND c3.tipoEvento LIKE :tipoEvento
                                                                                                                 ) 
                                                                          )
                                                                        )
                                                         )
                               )
                     OR EXISTS (SELECT 1 FROM AnscComunicazioneAllegato cal, CivFascicoloAttoAllegato fal 
                                        WHERE cal.comunicazione.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.ALL AND cal.comunicazione.servizio = c.servizio AND cal.comunicazione.idRif = fal.id
                                          AND cal.comunicazione.inviato = java.lang.Boolean.TRUE
                                          AND fal.fascicoloAtto.idAtto = :identificativoAtto
                                          AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c2 
                                                                  WHERE c2.archivio = c.archivio
                                                                    AND c2.servizio = c.servizio
                                                                    AND c2.idCasoUso = c.idCasoUso
                                                                    AND (  c2.tipoEvento LIKE :tipoEvento OR 
                                                                          (c2.tipoEvento IS NULL AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c3 
                                                                                                                  WHERE c3.archivio = c2.archivio 
                                                                                                                    AND c3.idCasoUso = c2.idCasoUso
                                                                                                                    AND c3.servizio = c2.servizio 
                                                                                                                    AND c3.tipoEvento LIKE :tipoEvento
                                                                                                                ) 
                                                                          )
                                                                        )
                                                         )
                                          AND COALESCE(c.tipoEvento, '--') = (SELECT COALESCE(MIN(c3.tipoEvento), '--') FROM AnscEndPointServizioArchivio c3
                                                                               WHERE c3.archivio = c.archivio AND c3.servizio = c.servizio AND c3.idCasoUso = c.idCasoUso)                                                         

                               )
                     OR EXISTS (SELECT 1 FROM AnscComunicazioneFirmatario cfi, CivFirmatarioAtto fat 
                                        WHERE cfi.comunicazione.archivioRif = it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc.FIR AND cfi.comunicazione.servizio = c.servizio AND cfi.comunicazione.idRif = fat.id
                                          AND cfi.comunicazione.inviato = java.lang.Boolean.TRUE
                                          AND fat.idAtto = :identificativoAtto
                                          AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c2 
                                                                  WHERE c2.archivio = c.archivio
                                                                    AND c2.servizio = c.servizio
                                                                    AND c2.idCasoUso = c.idCasoUso
                                                                    AND (  c2.tipoEvento LIKE :tipoEvento OR 
                                                                          (c2.tipoEvento IS NULL AND NOT EXISTS (SELECT 1 FROM AnscEndPointServizioArchivio c3 
                                                                                                                  WHERE c3.archivio = c2.archivio 
                                                                                                                    AND c3.idCasoUso = c2.idCasoUso
                                                                                                                    AND c3.servizio = c2.servizio 
                                                                                                                    AND c3.tipoEvento LIKE :tipoEvento
                                                                                                                ) 
                                                                          )
                                                                        )
                                                         )                                                    
                                          AND COALESCE(c.tipoEvento, '--') = (SELECT COALESCE(MIN(c3.tipoEvento), '--') FROM AnscEndPointServizioArchivio c3
                                                                               WHERE c3.archivio = c.archivio AND c3.servizio = c.servizio AND c3.idCasoUso = c.idCasoUso)                    
                               )                               
                     )                               
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioArchivio> findAllServiziAttoByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(@Param("archivio") ETipoArchivioAnsc archivio,
                                                                                                                  @Param("idCasoUso") Long idCasoUso,
                                                                                                                  @Param("tipoEvento") String tipoEvento,
                                                                                                                  @Param("pkAtto") Long pkAtto,
                                                                                                                  @Param("identificativoAtto") String identificativoAtto)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.idCasoUso = :idCasoUso 
                 AND c.servizio.flagPoolingPresaVisione = java.lang.Boolean.TRUE """)
    List<AnscEndPointServizioArchivio> findAllByArchivioAndCasoUsoAndFlagPoolingPresaVisioneIsTrue(@Param("archivio") ETipoArchivioAnsc archivio,
                                                                                                   @Param("idCasoUso") Long idCasoUso)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.idCasoUso = :idCasoUso 
                 AND c.servizio.flagConsultazioneSoggetto = java.lang.Boolean.TRUE 
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioArchivio> findAllByArchivioAndCasoUsoAndFlagConsultazioneSoggettoIsTrueOrderBySequenza(@Param("archivio") ETipoArchivioAnsc archivio,
                                                                                                                    @Param("idCasoUso") Long idCasoUso)

    @Query("""SELECT c FROM AnscEndPointServizioArchivio c INNER JOIN FETCH c.servizio LEFT OUTER JOIN FETCH c.servizioPrecedente
               WHERE c.archivio = :archivio AND c.idCasoUso = :idCasoUso 
                 AND c.servizio.flagConsultazioneEvento = java.lang.Boolean.TRUE 
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioArchivio> findAllByArchivioAndCasoUsoAndFlagConsultazioneEventoIsTrueOrderBySequenza(@Param("archivio") ETipoArchivioAnsc archivio,
                                                                                                                  @Param("idCasoUso") Long idCasoUso)

}