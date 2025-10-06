package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioAllegato
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscEndPointServizioAllegatoRepository extends JpaRepository<AnscEndPointServizioAllegato, Long> {

    @Query("""SELECT c FROM AnscEndPointServizioAllegato c 
               INNER JOIN FETCH c.servizio INNER JOIN FETCH c.tipoDocumentoFascicolo INNER JOIN c.tipoDocumentoFascicolo.tipoAllegatoANSC 
               WHERE c.servizio = :servizio AND c.idCasoUso = :idCasoUso AND c.tipoDocumentoFascicolo.tipoAtto = :tipoAtto
                 AND ( (c.tipoDocumento = :tipoDocumentoCdu) OR 
                       (c.tipoDocumento IS NULL AND NOT EXISTS (SELECT 1 from AnscEndPointServizioAllegato b
                                                                 WHERE b.idCasoUso = :idCasoUso
                                                                   AND b.servizio = :servizio
                                                                   AND b.tipoDocumentoFascicolo = c.tipoDocumentoFascicolo
                                                                   AND b.tipoDocumento = :tipoDocumentoCdu ) ) )
               ORDER BY c.sequenza""")
    List<AnscEndPointServizioAllegato> findAllByServizioAndCasoUsoOrderBySequenza(@Param("servizio") AnscEndPointServizio servizio,
                                                                                  @Param("idCasoUso") Long idCasoUso,
                                                                                  @Param("tipoAtto") Integer tipoAtto,
                                                                                  @Param("tipoDocumentoCdu") String tipoDocumentoCdu)

}