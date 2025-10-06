package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscAllegato
import org.springframework.data.jpa.repository.JpaRepository

interface AnscAllegatoRepository extends JpaRepository<AnscAllegato, Long> {

    AnscAllegato findById(Long id)

}