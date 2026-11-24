package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.utils.EGruppo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CampiCaratteriSpecialiDizionarioRepository extends JpaRepository<CampoCaratteriSpecialiDizionario, Long> {

        List<CampoCaratteriSpecialiDizionario> findAllByGruppoIn(List<EGruppo> gruppo)

}