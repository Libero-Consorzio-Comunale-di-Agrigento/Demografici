package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagServizio
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagServizioRepository extends JpaRepository<DepagServizio, String> {

    DepagServizio findById(String id)

    Page<DepagServizio> findAllByDescrizioneLikeIgnoreCase(String filtro, Pageable pageable)

}
