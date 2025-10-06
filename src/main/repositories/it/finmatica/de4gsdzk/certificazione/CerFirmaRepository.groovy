package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerFirma
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerFirmaRepository extends JpaRepository<CerFirma, Integer> {

    CerFirma findById(Integer id)

    Page<CerFirma> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    long countById(Integer idFirma)

}