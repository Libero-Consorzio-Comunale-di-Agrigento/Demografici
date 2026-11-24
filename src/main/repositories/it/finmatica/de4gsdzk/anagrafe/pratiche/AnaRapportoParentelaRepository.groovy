package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaRapportoParentelaRepository extends JpaRepository<AnaRapportoParentela, String> {

    List<AnaRapportoParentela> findAllBySessoAndTipoFamigliaOrderByDescrizioneAsc(ESesso sesso, ETipoFamiglia tipoFamiglia)

    @Query("""
        SELECT DISTINCT drp
        FROM AnaRapportoParentela drp, AnaRapportoParentelaIstat dpi
        WHERE dpi.sesso = drp.sesso
          AND dpi.codiceRapportoParentela = drp.codiceRapportoParentela
          AND drp.sesso = :sesso
          AND drp.codiceRapportoParentela NOT IN ('CF', 'CC', 'IC', 'CV')
        ORDER BY drp.descrizione ASC
    """)
    List<AnaRapportoParentela> findBySessoConCodiceIstat(@Param("sesso") ESesso sesso)

}