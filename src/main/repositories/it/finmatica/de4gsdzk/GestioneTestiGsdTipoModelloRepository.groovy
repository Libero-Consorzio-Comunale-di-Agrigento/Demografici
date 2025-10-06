package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.GestioneTestiGsdTipoModello
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface GestioneTestiGsdTipoModelloRepository extends JpaRepository<GestioneTestiGsdTipoModello, String> {

    GestioneTestiGsdTipoModello findByCodice(String id)

}