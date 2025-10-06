package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerTipoRichiedente
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerTipoRichiedenteRepository extends JpaRepository<CerTipoRichiedente, Integer> {

    CerTipoRichiedente findById(Integer id)

    List<CerTipoRichiedente> findAllByFlagVisibileTrueOrderBySequenza()
}