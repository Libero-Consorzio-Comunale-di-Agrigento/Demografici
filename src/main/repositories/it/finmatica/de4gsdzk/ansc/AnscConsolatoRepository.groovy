package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.ansc.AnscConsolato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository

interface AnscConsolatoRepository extends JpaRepository<AnscConsolato, Integer> {

    Page<AnscConsolato> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

}