package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivFormulaAnnotazioneRepository extends JpaRepository<CivFormulaAnnotazione, String>, CivFormulaAnnotazioneCustomRepository {

    @Query("SELECT c FROM CivFormulaAnnotazione c WHERE c.id = :id ")
    CivFormulaAnnotazione findById(@Param("id") String id)

    @Query("SELECT c FROM CivFormulaAnnotazione c JOIN FETCH c.testo WHERE c.id = :id ")
    CivFormulaAnnotazione findWithTestoById(@Param("id") String id)

    @Query("""SELECT DISTINCT(c) FROM CivFormulaAnnotazione c, CivComunicazioneFormula cf
               WHERE c.tipoAtto = :tipoAtto
               AND cf.formula.id = c.id
               AND c.tipoAnnotazione IN (:tipiAnnotazione) ORDER BY c.id""")
    List<CivFormulaAnnotazione> findAllByTipoAttoAndTipoAnnotazioneIn(@Param("tipoAtto") Integer tipoAtto, @Param("tipiAnnotazione") List<ETipoAnnotazione> tipiAnnotazione)

    @Query("""SELECT c FROM CivFormulaAnnotazione c WHERE c.id IN (:ids) ORDER BY c.id""")
    List<CivFormulaAnnotazione> findAllByIdIn(@Param("ids") List<String> ids)

    long countById(String idFormula)
}