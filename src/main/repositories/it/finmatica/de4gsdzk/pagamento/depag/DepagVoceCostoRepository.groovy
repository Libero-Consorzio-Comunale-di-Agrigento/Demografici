package it.finmatica.de4gsdzk.pagamento.depag

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.depag.DepagVoceCosto
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface DepagVoceCostoRepository extends JpaRepository<DepagVoceCosto, Long> {

    DepagVoceCosto findById(Long id)

    Page<DepagVoceCosto> findAllByTariffaDirittoDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    List<DepagVoceCosto> findAllByIdIn(List<Long> lista)
}
