package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTipoComprensione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTipoComprensioneRepository extends JpaRepository<CivTipoComprensione, String> {

    CivTipoComprensione findById(String id)

}