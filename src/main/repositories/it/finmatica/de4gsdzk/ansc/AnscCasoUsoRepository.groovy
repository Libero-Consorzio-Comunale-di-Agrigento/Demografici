package it.finmatica.de4gsdzk.ansc

import org.springframework.data.jpa.repository.JpaRepository

interface AnscCasoUsoRepository extends JpaRepository<AnscCasoUso, Long> {

    List<AnscCasoUso> findAllByTipoAttoOrderById(Integer tipoAtto)

}