package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivLuogoNascita
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivLuogoNascitaRepository extends JpaRepository<CivLuogoNascita, Integer> {

    CivLuogoNascita findById(Integer id)

    Page<CivLuogoNascita> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

}