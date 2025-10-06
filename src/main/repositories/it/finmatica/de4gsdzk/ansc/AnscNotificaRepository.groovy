package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscNotifica
import org.springframework.data.jpa.repository.JpaRepository

interface AnscNotificaRepository extends JpaRepository<AnscNotifica, Long>, AnscNotificaCustomRepository {

    AnscNotifica findById(Long id)

}