package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import org.springframework.data.domain.Page

interface CivFormulaAnnotazioneCustomRepository {

    Page<CivFormulaAnnotazione> listByParams(Map params)

}