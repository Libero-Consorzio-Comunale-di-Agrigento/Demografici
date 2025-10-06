package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAtto
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscComunicazioneAttoRepository extends JpaRepository<AnscComunicazioneAtto, Long> {

    @Query("""SELECT c FROM AnscComunicazioneAtto c INNER JOIN FETCH c.comunicazione
               WHERE c.comunicazione.archivioRif = :archivioRif 
                 AND c.comunicazione.idRif = :idRif 
                 AND c.comunicazione.servizio = :servizio 
               ORDER BY c.comunicazione.dataInvio DESC""")
    List<AnscComunicazioneAtto> findAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(@Param("archivioRif") ETipoArchivioAnsc archivioRif,
                                                                                        @Param("servizio") AnscEndPointServizio servizio,
                                                                                        @Param("idRif") Long idRif)
}