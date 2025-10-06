package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerFiltro
import it.finmatica.de4gsdzk.certificazione.CerSindaco
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerFiltroRepository extends JpaRepository<CerFiltro, String> {
    List<CerFiltro> findAllByTipoCompetenzaOrderById(ETipoCompetenzaCertificazioneOnLine tipoCompetenza)
}