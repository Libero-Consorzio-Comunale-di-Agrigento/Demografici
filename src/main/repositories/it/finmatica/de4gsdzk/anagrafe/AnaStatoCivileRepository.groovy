package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaStatoCivile
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaStatoCivileRepository extends JpaRepository<AnaStatoCivile, String> {

    List<AnaStatoCivile> findAllBySessoOrderByDescrizione(ESesso sesso)

}