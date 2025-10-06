package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.CivVisualizzazioneDocumentiBaseDomain
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

interface IVisualizzazioneDocumentiService<V extends CivVisualizzazioneDocumentiBaseDomain> {

    List<Integer> listAllAnniByRegistro(CivRegistroDocumentiBaseDomain registro)

    Page<V> listAllAssociatiByRegistro(CivRegistroDocumentiBaseDomain registro,
                                       Integer anno, Boolean flagNumerati,
                                       String filtro, PageRequest p)

}