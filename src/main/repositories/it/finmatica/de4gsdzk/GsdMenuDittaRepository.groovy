package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.GsdMenuDitta
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface GsdMenuDittaRepository extends JpaRepository<GsdMenuDitta, String> {

}