package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizione
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivRichiamoComposizioneRepository extends JpaRepository<CivRichiamoComposizione, Long> {

    CivRichiamoComposizione findById(Long id)

    Page<CivRichiamoComposizione> findAllByTipoAtto(Integer tipoAtto, Pageable pageable)

    Page<CivRichiamoComposizione> findAllByTipoAttoAndRichiamo(Integer tipoAtto, Integer richiamo, Pageable pageable)

    Page<CivRichiamoComposizione> findAllByTipoAttoAndDescrizioneLikeIgnoreCase(Integer tipoAtto, String filtro, Pageable pageable)

}