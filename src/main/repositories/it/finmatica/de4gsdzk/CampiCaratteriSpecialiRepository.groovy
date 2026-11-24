package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CampiCaratteriSpecialiRepository extends JpaRepository<CampoCaratteriSpeciali, Long> {

    List<CampoCaratteriSpeciali> findAllByTabellaAndIdRifOrderByIdAsc(String tabella, Object idRif)

}