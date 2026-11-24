package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceTitoloStudio
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnpCodiceTitoloStudioRepository extends JpaRepository<AnpCodiceTitoloStudio, String> {

}