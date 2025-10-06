package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaMessaggio
import it.finmatica.de4gsdzk.anagrafe.AnaMessaggioCompositeId
import it.finmatica.de4gsdzk.statocivile.CivMessaggio
import it.finmatica.de4gsdzk.statocivile.CivMessaggioCompositeId
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivMessaggioRepository extends JpaRepository<CivMessaggio, CivMessaggioCompositeId> {

    List<CivMessaggio> findAllByIdTipoAttoAndIdIdAndFlagCertificazioneTrueOrderByFlagAvvisoDescIdSequenzaAsc(Integer tipoAtto, Long id)
}