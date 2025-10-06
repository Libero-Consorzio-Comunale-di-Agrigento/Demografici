package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivPubblicazione
import org.springframework.data.domain.Page

interface CivPubblicazioneCustomRepository {

    CivPubblicazione getByParams(Long id, Map params)

    CivPubblicazione findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    Page<CivPubblicazione> listByParams(Map params)

}