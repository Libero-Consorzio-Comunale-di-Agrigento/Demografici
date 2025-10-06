package it.finmatica.de4gsdzk.certificazione

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamento
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CerTipoPagamentoRepository extends JpaRepository<CerTipoPagamento, Integer> {

    CerTipoPagamento findById(Integer id)

    List<CerTipoPagamento> findAll(Sort sort)

    long countById(Integer idTipoPagamento)

}