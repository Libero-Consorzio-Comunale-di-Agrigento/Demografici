package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneFormula
import it.finmatica.de4gsdzk.utils.ETipoIndividuiAtto
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivComunicazioneFormulaRepository extends JpaRepository<CivComunicazioneFormula, Long> {

    @Query("""SELECT c FROM CivComunicazioneFormula c
            JOIN FETCH c.comunicazione 
            LEFT OUTER JOIN FETCH c.tipoDocumentoFascicolo
            JOIN FETCH c.formula WHERE c.id = :id """)
    CivComunicazioneFormula findById(@Param("id") Long id)

    @Query("""SELECT c FROM CivComunicazioneFormula c 
                JOIN FETCH c.comunicazione 
                LEFT OUTER JOIN FETCH c.tipoDocumentoFascicolo LEFT OUTER JOIN FETCH c.tipoDocumentoFascicoloRif
               WHERE c.formula.id = :formula AND c.comunicazione.id = :idCom """)
    CivComunicazioneFormula findByUk(@Param("formula") String formula, @Param("idCom") Integer idCom)

    @Query("""SELECT c FROM CivComunicazioneFormula c JOIN FETCH c.comunicazione
               WHERE c.formula.id = :idFormulaDfa 
                 AND c.tipoIndividuiAtto IN (:listaTipoIndividui) """)
    List<CivComunicazioneFormula> findAllByFormulaDfaAndTipoIndividui(@Param("idFormulaDfa") String idFormulaDfa, @Param("listaTipoIndividui") List<ETipoIndividuiAtto> listaTipoIndividui)

    @Query(value = """
        SELECT c FROM CivComunicazioneFormula c 
        JOIN FETCH c.comunicazione com
        JOIN FETCH c.formula form 
        WHERE c.comunicazione = :comunicazione
          AND (UPPER(c.formula.descrizione) LIKE UPPER(:filtro) OR UPPER(c.formula.id) LIKE UPPER(:filtro))
        ORDER BY com.id """,
    countQuery = """
        SELECT count(*) FROM CivComunicazioneFormula c
        JOIN c.comunicazione com
        JOIN c.formula form 
        WHERE c.comunicazione = :comunicazione
          AND (UPPER(c.formula.descrizione) LIKE UPPER(:filtro) OR UPPER(c.formula.id) LIKE UPPER(:filtro)) """)
    Page<CivComunicazioneFormula> findAllByComunicazioneAndFormulaLike(@Param("comunicazione") CivComunicazione comunicazione, @Param("filtro") String filtro, Pageable pageable)

}