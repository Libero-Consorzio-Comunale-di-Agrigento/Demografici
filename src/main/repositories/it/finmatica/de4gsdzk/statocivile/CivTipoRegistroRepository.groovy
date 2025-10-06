package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivTipoRegistro
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivTipoRegistroRepository extends JpaRepository<CivTipoRegistro, String> {

    CivTipoRegistro findById(String id)

    List<CivTipoRegistro> findAllByDescrizioneLikeIgnoreCaseOrderById(String filtro)

}