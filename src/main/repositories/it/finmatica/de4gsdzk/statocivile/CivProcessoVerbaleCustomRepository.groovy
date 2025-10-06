package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbale
import org.springframework.data.domain.Page

interface CivProcessoVerbaleCustomRepository {

    CivProcessoVerbale getByParams(Long id, Map params)

    CivProcessoVerbale findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    Page<CivProcessoVerbale> listByParams(Map params)

}