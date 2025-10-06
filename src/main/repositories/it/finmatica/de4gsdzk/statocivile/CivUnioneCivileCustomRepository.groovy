package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivUnioneCivile
import org.springframework.data.domain.Page

interface CivUnioneCivileCustomRepository {

    CivUnioneCivile getByParams(Long id, Map params)

    CivUnioneCivile findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    CivUnioneCivile findByIdAttoAnsc(String idAttoAnsc)

    Page<CivUnioneCivile> listByParams(Map params)

}