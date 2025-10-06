package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivMorte
import org.springframework.data.domain.Page

interface CivMorteCustomRepository {

    CivMorte getByParams(Long id, Map params)

    CivMorte findByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie)

    CivMorte findByIdAttoAnsc(String idAttoAnsc)

    Page<CivMorte> listByParams(Map params)

}