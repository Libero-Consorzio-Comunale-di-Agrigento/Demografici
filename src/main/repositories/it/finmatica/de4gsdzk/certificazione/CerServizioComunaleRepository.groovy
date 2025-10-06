package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerServizioComunale
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerServizioComunaleRepository extends JpaRepository<CerServizioComunale, String> {

    CerServizioComunale findById(String id)

    Page<CerServizioComunale> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

    long countById(String idServizio)

}