package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerIndividuoCertificato
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerIndividuoCertificatoRepository extends JpaRepository<CerIndividuoCertificato, Long> {

    CerIndividuoCertificato findById(long id)

    CerIndividuoCertificato findByAnnoEmissioneAndProgressivoEmissione(Integer annoEmissione, Integer progressivoEmissione)

}