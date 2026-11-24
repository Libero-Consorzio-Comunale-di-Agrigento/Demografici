package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaSoggettoRettificaRepository extends JpaRepository< AnaSoggettoRettifica, String> {

}