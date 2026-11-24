package it.finmatica.de4gsdzk.anpr

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnprComunicazioneRepository extends JpaRepository<AnprComunicazione, Long> {

    @Query("""SELECT c FROM AnprComunicazione c
                LEFT OUTER JOIN FETCH c.pratica
                LEFT OUTER JOIN FETCH c.servizio
                WHERE c.pratica.id = :idPratica
                AND (:filtroInviato IS NULL OR (:filtroInviato = 'S' AND c.inviato = true) OR (:filtroInviato = 'N' AND c.inviato IS NULL))
                AND (:archivioRif IS NULL OR c.archivioRif = :archivioRif)
                ORDER BY c.id""")
    List<AnprComunicazione> findAllByPraticaAndInviatoAndArchivioRif(@Param("idPratica") Long idPratica,
                                                                     @Param("filtroInviato") String filtroInviato,
                                                                     @Param("archivioRif") AnprTipoArchivio archivioRif)

    @Query("""SELECT c FROM AnprComunicazione c
                LEFT OUTER JOIN FETCH c.pratica
                LEFT OUTER JOIN FETCH c.servizio
                WHERE (c.pratica.id = :idPratica OR c.matricola IN :matricole)
                AND (:filtroInviato IS NULL OR (:filtroInviato = 'S' AND c.inviato = true) OR (:filtroInviato = 'N' AND c.inviato IS NULL))
                AND (:archivioRif IS NULL OR c.archivioRif = :archivioRif)
                ORDER BY c.id""")
    List<AnprComunicazione> findAllByPraticaOrMatricoleAndInviatoAndArchivioRif(@Param("idPratica") Long idPratica,
                                                                                @Param("matricole") List<Integer> matricole,
                                                                                @Param("filtroInviato") String filtroInviato,
                                                                                @Param("archivioRif") AnprTipoArchivio archivioRif)

    @Query("""SELECT c FROM AnprComunicazione c
                LEFT OUTER JOIN FETCH c.pratica
                LEFT OUTER JOIN FETCH c.servizio
                WHERE c.matricola = :matricola
                AND (:filtroInviato IS NULL OR (:filtroInviato = 'S' AND c.inviato = true) OR (:filtroInviato = 'N' AND c.inviato IS NULL))
                AND (:archivioRif IS NULL OR c.archivioRif = :archivioRif)
                ORDER BY c.id""")
    List<AnprComunicazione> findAllByMatricolaAndInviatoAndArchivioRif(@Param("matricola") Integer matricola,
                                                                       @Param("filtroInviato") String filtroInviato,
                                                                       @Param("archivioRif") AnprTipoArchivio archivioRif)

    @Query("""SELECT c FROM AnprComunicazione c 
                LEFT OUTER JOIN FETCH c.datiAggiuntivi
                LEFT OUTER JOIN FETCH c.servizio
                WHERE c.id = :id""")
    AnprComunicazione findById(@Param("id") Long id)

}