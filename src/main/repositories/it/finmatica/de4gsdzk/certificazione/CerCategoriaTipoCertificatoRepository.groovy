package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerCategoriaTipoCertificatoRepository extends JpaRepository<CerCategoriaTipoCertificato, Integer>, CerCategoriaTipoCertificatoCustomRepository {

}