package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAllegato
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscComunicazioneAllegatoRepository extends JpaRepository<AnscComunicazioneAllegato, Long> {

    @Query("""SELECT c FROM AnscComunicazioneAllegato c INNER JOIN FETCH c.comunicazione
               WHERE c.idAllegato = :idAllegato AND c.comunicazione.servizio = :servizio 
               ORDER BY c.comunicazione.dataInvio DESC""")
    List<AnscComunicazioneAllegato> findAllByServizioAndIdAllegatoOrderByDataInvio(@Param("servizio") AnscEndPointServizio servizio,
                                                                                   @Param("idAllegato") Long idAllegato)

    @Query(""" SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                 FROM AnscComunicazioneAllegato c 
                WHERE c.idAllegato = :idAllegato 
                  AND c.comunicazione.inviato = java.lang.Boolean.TRUE""")
    Integer existsComunicazioneByIdAllegatoAndInviatoANSC(@Param("idAllegato") Long idAllegato)

}