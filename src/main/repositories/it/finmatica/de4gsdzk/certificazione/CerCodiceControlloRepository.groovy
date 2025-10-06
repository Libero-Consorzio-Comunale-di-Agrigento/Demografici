package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCodiceControllo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerCodiceControlloRepository extends JpaRepository<CerCodiceControllo, Integer> {
}