package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerDettaglioIncassoRepository extends JpaRepository<CerDettaglioIncasso, Long>, CerDettaglioIncassoCustomRepository {

}
