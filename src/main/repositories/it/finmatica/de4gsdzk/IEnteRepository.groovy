package it.finmatica.de4gsdzk


import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort

interface IEnteRepository {

    IEnte findById(Integer id)

    Page<IEnte> findAllByDescrizioneLikeIgnoreCaseOrPecLikeIgnoreCase(String filtroDes, String filtroPec, Pageable pageable)

    List<IEnte> findAllByTipoEnteDestinatario(ETipoEnteDestinatario tipoEnteDestinatario, Sort sort)

    List<IEnte> findAllByTipoEnteDestinatarioAndIdNotInOrderByDescrizione(ETipoEnteDestinatario tipoEnteDestinatario, List<Integer> listaId)

    long countById(Integer idEnte)

    IEnte save(IEnte obj)

}