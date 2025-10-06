package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivArchivioComunicazione
import org.springframework.data.domain.Page

interface CivArchivioComunicazioneCustomRepository {

    Page<CivArchivioComunicazione> listByParams(Map params)

    List<CivArchivioComunicazione> findAllByUkAttoAndTipoAtto(Integer tipoAtto, Integer ufficio, Integer anno, Integer atto, Integer parte, String serie, Map params)
}