package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.IstMd3UProcessoVerbale
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface IstMd3UProcessoVerbaleRepository extends JpaRepository<IstMd3UProcessoVerbale, Long> {

    IstMd3UProcessoVerbale findById(Long id)

    IstMd3UProcessoVerbale findByIdAtto(String identificativoAtto)

}