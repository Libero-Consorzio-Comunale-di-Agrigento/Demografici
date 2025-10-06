package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaEnte
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaEnteRepository extends JpaRepository<AnaEnte, Integer> {

    AnaEnte findById(Integer id)

    Page<AnaEnte> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

}