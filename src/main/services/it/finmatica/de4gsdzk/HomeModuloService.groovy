package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EModulo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class HomeModuloService {

    private final CompetenzaService competenzaService

    HomeModuloService(CompetenzaService competenzaService) {
        this.competenzaService = competenzaService
    }

    List<EModulo> listModuliAbilitati() {
        List<EModulo> l = []
        if (competenzaService.isCerAny()) {
            l.add(EModulo.CERTIFICAZIONE)
        }
        if (competenzaService.isAnaAny()) {
            l.add(EModulo.ANAGRAFE)
        }
        if (competenzaService.isCivAny()) {
            l.add(EModulo.STATO_CIVILE)
        }
        if (competenzaService.isEleAny()) {
            l.add(EModulo.ELETTORALE)

        }
        if (competenzaService.isLevAny()) {
            l.add(EModulo.LEVA_MILITARE)
        }
        if (competenzaService.isTopAny()) {
            l.add(EModulo.TOPONOMASTICA)
        }
        l.add(EModulo.SMART_STATS)
        return l
    }
}
