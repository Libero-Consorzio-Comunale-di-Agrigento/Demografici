package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivArchivioComunicazione
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFascicoloAttoRepository extends JpaRepository<CivFascicoloAtto, Long> {

    @Query("""SELECT c FROM CivFascicoloAtto c 
               INNER JOIN FETCH c.tipoDocumentoFascicolo 
                LEFT OUTER JOIN FETCH c.archivioComunicazione 
               WHERE c.id = :id """)
    CivFascicoloAtto findById(@Param("id") Long id)

    @Query("""SELECT c.archivioComunicazione FROM CivFascicoloAtto c 
                INNER JOIN c.archivioComunicazione 
               WHERE c.id = :id """)
    CivArchivioComunicazione findComunicazioneByIdFascicolo(@Param("id") Long id)

    @Query(value = """SELECT c FROM CivFascicoloAtto c 
                       INNER JOIN FETCH c.tipoDocumentoFascicolo 
                       INNER JOIN c.archivioComunicazione 
                       WHERE c.tipoAtto = :tipoAtto 
                         AND c.idAtto = :identificativoAtto 
                         AND c.archivioComunicazione = :arcCom """)
    CivFascicoloAtto findByUkAttoAndTipoAttoAndArchivioComunicazione(@Param("identificativoAtto") String identificativoAtto,
                                                                     @Param("tipoAtto") Integer tipoAtto, @Param("arcCom") CivArchivioComunicazione arcCom)

    @Query(value = """SELECT c FROM CivFascicoloAtto c 
                       INNER JOIN FETCH c.tipoDocumentoFascicolo 
                       WHERE c.tipoAtto = :tipoAtto 
                         AND c.idAtto = :identificativoAtto 
                         AND c.tipoDocumentoFascicolo = :tdf """)
    CivFascicoloAtto findByUkAttoAndTipoAttoAndTipoDocumentoFascicolo(@Param("identificativoAtto") String identificativoAtto,
                                                                      @Param("tipoAtto") Integer tipoAtto, @Param("tdf") CivTipoDocumentoFascicolo tdf)

    @Query(value = """SELECT c FROM CivFascicoloAtto c 
                       INNER JOIN FETCH c.tipoDocumentoFascicolo 
                        LEFT OUTER JOIN FETCH c.archivioComunicazione
                       WHERE c.idAtto IN (:idAttoList) """,
            countQuery = """SELECT count(c) FROM CivFascicoloAtto c 
                             INNER JOIN c.tipoDocumentoFascicolo 
                              LEFT OUTER JOIN c.archivioComunicazione  
                             WHERE c.idAtto IN (:idAttoList) """)
    Page<CivFascicoloAtto> findAllByUkAttoInList(@Param("idAttoList") List<String> idAttoList, Pageable pageable)

    long countByTipoDocumentoFascicolo(CivTipoDocumentoFascicolo tdf)

    @Query("""SELECT 1 FROM CivFascicoloAtto c 
               WHERE c.id = :idFascicolo  
                 AND EXISTS (SELECT 1 FROM AnscComunicazioneAllegato cal, CivFascicoloAttoAllegato fal 
                              WHERE cal.idAllegato = fal.id
                                AND fal.fascicoloAtto.id = c.id
                                AND fal.fascicoloAtto.tipoDocumentoFascicolo.id != :idTipoDocumentoFascicolo
                                AND cal.comunicazione.inviato = java.lang.Boolean.TRUE) """)
    Integer contieneAllegatoByOldTipoDocumentoInviatoANSC(@Param("idFascicolo") Long idFascicolo, @Param("idTipoDocumentoFascicolo") Long idTipoDocumentoFascicolo)

}