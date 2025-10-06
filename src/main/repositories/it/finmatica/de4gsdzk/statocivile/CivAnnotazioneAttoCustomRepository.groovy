package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import org.springframework.data.domain.Page

interface CivAnnotazioneAttoCustomRepository {

    Page<CivAnnotazioneAtto> listByParams(Map params)
}