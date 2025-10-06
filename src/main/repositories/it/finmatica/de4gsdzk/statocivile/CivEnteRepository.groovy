package it.finmatica.de4gsdzk.statocivile

import groovy.transform.CompileStatic
import it.finmatica.de4gsdzk.statocivile.CivEnte
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@CompileStatic
@Repository
interface CivEnteRepository extends JpaRepository<CivEnte, Integer> {

    CivEnte findById(Integer id)

    Page<CivEnte> findAllByDescrizioneLikeIgnoreCaseOrPecLikeIgnoreCase(String filtroDes, String filtroPec, Pageable pageable)

    List<CivEnte> findAllByTipoEnteDestinatario(ETipoEnteDestinatario tipoEnteDestinatario, Sort sort)

    List<CivEnte> findAllByTipoEnteDestinatarioAndIdNotInOrderByDescrizione(ETipoEnteDestinatario tipoEnteDestinatario, List<Integer> listaId)

    long countById(Integer idEnte)
}