package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.ETipoIndividuiAtto
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneAttoRepository extends JpaRepository<CivComunicazioneAtto, String> {

    @Query("""SELECT c FROM CivComunicazioneAtto c 
                JOIN FETCH c.comunicazione 
                LEFT OUTER JOIN FETCH c.tipoDocumentoFascicolo
                WHERE c.id = :id """)
    CivComunicazioneAtto findById(@Param("id") String id)

    @Query("""SELECT c FROM CivComunicazioneAtto c 
                JOIN FETCH c.comunicazione 
                LEFT OUTER JOIN FETCH c.tipoDocumentoFascicolo
               WHERE c.tipoAtto = :tipoAtto AND c.comunicazione.id = :idCom """)
    CivComunicazioneAtto findByUk(@Param("tipoAtto") Integer tipoAtto, @Param("idCom") Integer idCom)

    @Query(value="""
        SELECT c FROM CivComunicazioneAtto c JOIN FETCH c.comunicazione 
        WHERE c.tipoAtto = :tipoAtto 
        ORDER BY c.id""",
    countQuery = """
        SELECT count(c) FROM CivComunicazioneAtto c 
        JOIN c.comunicazione 
        WHERE c.tipoAtto = :tipoAtto""")
    Page<CivComunicazioneAtto> findAllByTipoAtto(@Param("tipoAtto") Integer tipoAtto, Pageable pageable)

    @Query("SELECT c FROM CivComunicazioneAtto c INNER JOIN FETCH c.comunicazione WHERE c.comunicazione = :comunicazione ")
    List<CivComunicazioneAtto> findAllByComunicazione(@Param("comunicazione") CivComunicazione comunicazione)

    @Query("""SELECT distinct c.tipoAtto FROM CivComunicazioneAtto c WHERE c.comunicazione = :comunicazione """)
    List<Integer> findAllTipiAttoByComunicazione(@Param("comunicazione") CivComunicazione comunicazione)

    @Query("""SELECT c, c.comunicazione FROM CivComunicazioneAtto c JOIN FETCH c.comunicazione
               WHERE c.tipoAtto = :tipoAtto 
                 AND COALESCE(c.natura, :natura) = :natura 
                 AND c.tipoIndividuiAtto IN (:listaTipoIndividui)""")
    List<CivComunicazioneAtto> findAllByTipoAttoAndNaturaAndTipoIndividui(@Param("tipoAtto") Integer tipoAtto, @Param("natura") ENaturaAtto natura,
                                                                          @Param("listaTipoIndividui") List<ETipoIndividuiAtto> listaTipoIndividui)

    @Query("""SELECT c, c.comunicazione FROM CivComunicazioneAtto c JOIN FETCH c.comunicazione
               WHERE c.tipoAtto = :tipoAtto
                 AND COALESCE(c.natura, :natura) = :natura
                 AND c.tipoIndividuiAtto IN (:listaTipoIndividui)
                 AND ((:priorita = TRUE AND c.comunicazione.priorita = TRUE)
                      OR (:priorita = FALSE AND c.comunicazione.priorita IS NULL))
                AND c.numeroCopie > 0""")
    List<CivComunicazioneAtto> findAllByTipoAttoAndNaturaAndTipoIndividuiAndFlagPriorita(@Param("tipoAtto") Integer tipoAtto,
                                                                                         @Param("natura") ENaturaAtto natura,
                                                                                         @Param("listaTipoIndividui") List<ETipoIndividuiAtto> listaTipoIndividui,
                                                                                         @Param("priorita") Boolean priorita)

}