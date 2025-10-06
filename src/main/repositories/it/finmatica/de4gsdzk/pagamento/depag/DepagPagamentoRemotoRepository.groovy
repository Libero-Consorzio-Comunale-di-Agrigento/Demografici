package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoRemoto
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagPagamentoRemotoRepository extends JpaRepository<DepagPagamentoRemoto, String> {

    DepagPagamentoRemoto findById(String chiaveServizioEsterno)
}
