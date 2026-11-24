package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaComunicazionePraticaRepository extends JpaRepository<AnaComunicazionePratica, String> {

    @Query("""SELECT c FROM AnaComunicazionePratica c 
                JOIN FETCH c.comunicazione 
                LEFT JOIN FETCH c.eventoPratica 
                WHERE c.id = :id """)
    AnaComunicazionePratica findById(@Param("id") String id)

    @Query("""SELECT c FROM AnaComunicazionePratica c 
                JOIN FETCH c.comunicazione 
               WHERE c.archivioAnagrafe = :anagrafe AND c.tipoPratica = :tipoEvento AND c.comunicazione.id = :idCom """)
    AnaComunicazionePratica findByUk(@Param("anagrafe") ETipoAnagrafe anagrafe, @Param("tipoEvento") ETipoPratica tipoEvento, @Param("idCom") Integer idCom)

/*    @Query(value="""
        SELECT c FROM AnaComunicazionePratica c JOIN FETCH c.comunicazione 
        WHERE c.archivioAnagrafe = :anagrafe AND c.tipoPratica = :tipoEvento
        ORDER BY c.id""",
    countQuery = """
        SELECT count(c) FROM AnaComunicazionePratica c 
        JOIN c.comunicazione 
       WHERE c.archivioAnagrafe = :anagrafe AND c.tipoPratica = :tipoEvento""")
    Page<AnaComunicazionePratica> findAllByTipoAtto(@Param("anagrafe") ETipoAnagrafe anagrafe, @Param("tipoEvento") ETipoPratica tipoEvento, Pageable pageable)*/

    @Query("""SELECT c 
              FROM AnaComunicazionePratica c 
              INNER JOIN FETCH c.comunicazione 
              LEFT JOIN FETCH c.eventoPratica
              WHERE c.comunicazione = :comunicazione""")
    List<AnaComunicazionePratica> findAllByComunicazione(@Param("comunicazione") AnaComunicazione comunicazione)

    @Query("""SELECT c
              FROM AnaComunicazionePratica c
              JOIN FETCH c.comunicazione
              WHERE c.archivioAnagrafe = :anagrafe AND c.tipoPratica = :tipoEvento""")
    List<AnaComunicazionePratica> findAllByArchivioAnagrafeAndTipoPratica(@Param("anagrafe") ETipoAnagrafe anagrafe,
                                                                          @Param("tipoEvento") ETipoPratica tipoEvento)

    @Query("""SELECT c
              FROM AnaComunicazionePratica c
              JOIN FETCH c.comunicazione
              WHERE c.archivioAnagrafe = :anagrafe AND c.tipoPratica = :tipoEvento
              AND ((:priorita = TRUE AND c.comunicazione.priorita = TRUE)
                   OR (:priorita = FALSE AND c.comunicazione.priorita IS NULL))
              AND c.numeroCopie > 0""")
    List<AnaComunicazionePratica> findAllByArchivioAnagrafeAndTipoPraticaAndFlagPriorita(@Param("anagrafe") ETipoAnagrafe anagrafe,
                                                                          @Param("tipoEvento") ETipoPratica tipoEvento,
                                                                          @Param("priorita") Boolean priorita)


}