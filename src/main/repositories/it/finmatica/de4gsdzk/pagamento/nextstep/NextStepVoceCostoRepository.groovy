package it.finmatica.de4gsdzk.pagamento.nextstep

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.pagamento.nextstep.NextStepVoceCosto
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface NextStepVoceCostoRepository extends JpaRepository<NextStepVoceCosto, Long> {

    NextStepVoceCosto findById(Long id)

    Page<NextStepVoceCosto> findAllByTariffaDirittoDescrizioneLikeIgnoreCase(@Param("filtro") String filtro, Pageable pageable)

    List<NextStepVoceCosto> findAllByIdIn(List<Long> lista)
}
