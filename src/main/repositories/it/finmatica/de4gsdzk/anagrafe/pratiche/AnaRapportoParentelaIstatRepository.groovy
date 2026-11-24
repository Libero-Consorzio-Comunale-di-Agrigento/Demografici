package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaRapportoParentelaIstatRepository extends JpaRepository<AnaRapportoParentelaIstat, String> {

    AnaRapportoParentelaIstat findBySessoAndCodiceRapportoParentela(ESesso sesso, String codiceRapportoParentela)

}