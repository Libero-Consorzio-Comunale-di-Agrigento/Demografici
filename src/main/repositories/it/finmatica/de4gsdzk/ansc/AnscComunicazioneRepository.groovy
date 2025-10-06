package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscComunicazione
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface AnscComunicazioneRepository extends JpaRepository<AnscComunicazione, Long> {

    @Query("""SELECT c FROM AnscComunicazione c INNER JOIN FETCH c.servizio
               WHERE c.id = :id """)
    AnscComunicazione findById(@Param("id")Long id)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE 
                FROM AnscComunicazione c INNER JOIN c.servizio
               WHERE c.archivioRif = :archivioRif AND c.idRif in (:idRifs) AND c.servizio.id = :idServizio 
                 AND c.inviato = :inviato 
                 AND c.httpError = false """)
    Integer esisteComunicazioneByInviatoAndArchivioRifAndServizioAndIdRifInListAndHttpErrorFalse(@Param("inviato") Boolean inviato,
                                                                                                 @Param("archivioRif") ETipoArchivioAnsc archivioRif,
                                                                                                 @Param("idServizio") String idServizio,
                                                                                                 @Param("idRifs") List<Long> idRifs)

    @Query("""SELECT CASE WHEN COUNT(c) = 0 THEN 0 ELSE 1 END AS ESISTE
                FROM AnscComunicazione c INNER JOIN c.servizio
               WHERE c.archivioRif = :archivioRif AND c.idRif in (:idRifs) AND c.servizio.id = :idServizio  """)
    Integer esisteComunicazioneByArchivioRifAndServizioAndIdRifInList(@Param("archivioRif") ETipoArchivioAnsc archivioRif,
                                                                      @Param("idServizio") String idServizio,
                                                                      @Param("idRifs") List<Long> idRifs)
}