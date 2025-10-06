package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.utils.ENaturaAtto

interface CivCategoriaTipoAttoCustomRepository {

    List<CivCategoriaTipoAtto> findAllByTipoAttoAndParteAndSerieAndNatura(Integer tipoAtto, Integer parte, String serie, ENaturaAtto natura, Map params)
}