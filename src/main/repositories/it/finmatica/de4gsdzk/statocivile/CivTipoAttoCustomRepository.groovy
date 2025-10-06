package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto
import org.springframework.data.domain.Page

interface CivTipoAttoCustomRepository {

    Page<CivTipoAtto> listByParams(Integer tipoAtto, Map params)

    List<CivTipoAtto> findAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura)

}