package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivMatrimonio
import org.springframework.data.domain.Page

interface CivMatrimonioCustomRepository {

    CivMatrimonio getByParams(Long id, Map params)

    CivMatrimonio findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    CivMatrimonio findByIdAttoAnsc(String idAttoAnsc)

    Page<CivMatrimonio> listByParams(Map params)

}