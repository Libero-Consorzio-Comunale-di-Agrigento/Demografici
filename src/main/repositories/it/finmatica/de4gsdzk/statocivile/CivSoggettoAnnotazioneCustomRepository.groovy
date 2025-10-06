package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import org.springframework.data.domain.Page

interface CivSoggettoAnnotazioneCustomRepository {

    Page<CivSoggettoAnnotazione> listByParams(Map params)

    List<CivSoggettoAnnotazione> findAllByIdAttoAndTipoFormula(String identificativoAtto, String tipoFormula)

}