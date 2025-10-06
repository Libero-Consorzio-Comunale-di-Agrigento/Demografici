package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscUtente
import org.springframework.data.jpa.repository.JpaRepository

interface AnscUtenteRepository extends JpaRepository<AnscUtente, String> {

    AnscUtente findById(String id)

}