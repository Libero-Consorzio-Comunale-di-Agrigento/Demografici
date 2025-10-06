package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAnnotazione
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscComunicazioneAnnotazioneRepository extends JpaRepository<AnscComunicazioneAnnotazione, Long> {

    @Query("""SELECT c FROM AnscComunicazioneAnnotazione c INNER JOIN FETCH c.comunicazione
               WHERE c.idAnnotazione = :idAnnotazione AND c.comunicazione.servizio = :servizio 
               ORDER BY c.comunicazione.dataInvio DESC""")
    List<AnscComunicazioneAnnotazione> findAllByServizioAndIdAnnotazioneOrderByDataInvio(@Param("servizio") AnscEndPointServizio servizio,
                                                                                         @Param("idAnnotazione") Long idAnnotazione)
}