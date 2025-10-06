package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivSoggettoAnnotazioneRepository extends JpaRepository<CivSoggettoAnnotazione, String>, CivSoggettoAnnotazioneCustomRepository {

}