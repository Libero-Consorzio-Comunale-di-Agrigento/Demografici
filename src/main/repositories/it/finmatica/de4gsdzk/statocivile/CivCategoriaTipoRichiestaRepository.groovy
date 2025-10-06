package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoRichiesta
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivCategoriaTipoRichiestaRepository extends JpaRepository<CivCategoriaTipoRichiesta, Long> {
    List<CivCategoriaTipoRichiesta> findAllByTipoAttoAndSiglaCategoria(Integer tipoAtto, String siglaCategoria)

    List<CivCategoriaTipoRichiesta> findAllByTipoAtto(Integer tipoAtto)
}
