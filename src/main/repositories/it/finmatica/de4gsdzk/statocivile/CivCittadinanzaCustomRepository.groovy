package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
import org.springframework.data.domain.Page

interface CivCittadinanzaCustomRepository {

    CivCittadinanza getByParams(Long id, Map params)

    CivCittadinanza findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    CivCittadinanza findByIdAttoAnsc(String idAttoAnsc)

    Page<CivCittadinanza> listByParams(Map params)

}