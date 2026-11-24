package it.finmatica.de4gsdzk.anpr

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnprDatiAggiuntiviComunicazioneRepository extends JpaRepository<AnprDatiAggiuntiviComunicazione, Long> {
}