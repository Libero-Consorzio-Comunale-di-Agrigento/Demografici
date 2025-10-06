package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface AnaNazionalitaRepository extends JpaRepository<AnaNazionalita, String> {

    AnaNazionalita findById(String id)

}