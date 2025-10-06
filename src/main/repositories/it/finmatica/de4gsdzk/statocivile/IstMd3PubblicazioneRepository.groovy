package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd3Pubblicazione
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd3PubblicazioneRepository extends JpaRepository<IstMd3Pubblicazione, Long> {

    IstMd3Pubblicazione findById(Long id)

    IstMd3Pubblicazione findByIdAtto(String identificativoAtto)

}