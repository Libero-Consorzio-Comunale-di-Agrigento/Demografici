package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivNumerazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

interface IRegistroDocumentiService<R extends CivRegistroDocumentiBaseDomain, N extends CivNumerazioneDocumentiBaseDomain> {

    Tuple2<R, Collection<N>> get(Integer id)

    List<R> listAll()

    Page<R> listAllByDescrizioneLike (String filtro, PageRequest p)

    R save (ETipoOperazione tipoOperazione, R obj, LinkedHashSet<N> listaNumeriDocumenti)

}
