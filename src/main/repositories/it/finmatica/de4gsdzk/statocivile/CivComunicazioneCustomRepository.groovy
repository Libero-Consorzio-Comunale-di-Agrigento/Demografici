package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import org.springframework.data.domain.Page

interface CivComunicazioneCustomRepository {

    Page<CivComunicazione> listByParams(Map params)

}