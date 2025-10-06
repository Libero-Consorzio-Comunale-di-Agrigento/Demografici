package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivNascita
import org.springframework.data.domain.Page

interface CivNascitaCustomRepository {

    CivNascita getByParams(Long id, Map params)

    CivNascita findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    CivNascita findByIdAttoAnsc(String idAttoAnsc)

    Page<CivNascita> listByParams(Map params)

}