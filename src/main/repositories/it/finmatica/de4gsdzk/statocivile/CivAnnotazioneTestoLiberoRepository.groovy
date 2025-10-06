package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneTestoLibero
import it.finmatica.de4gsdzk.utils.ETipoFormulaAnnotazioneDaAtto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivAnnotazioneTestoLiberoRepository extends JpaRepository<CivAnnotazioneTestoLibero, Long> {

    @Query("""SELECT c FROM CivAnnotazioneTestoLibero c 
               WHERE c.idAtto = :identificativoAtto AND c.tipoAtto = :tipoAtto AND c.tipoFormula IN (:ltf)
               ORDER BY c.sequenza """)
    List<CivAnnotazioneTestoLibero> findAllByUkAttoAndTipoAttoAndTipoFormulaIn(@Param("identificativoAtto") String identificativoAtto, @Param("tipoAtto") Integer tipoAtto,
                                                                               @Param("ltf") List<ETipoFormulaAnnotazioneDaAtto> ltf)

}