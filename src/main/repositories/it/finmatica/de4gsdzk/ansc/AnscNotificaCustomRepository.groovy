package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.ansc.AnscNotifica
import it.finmatica.de4gsdzk.utils.RicercaNotifica
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface AnscNotificaCustomRepository {

    Page<AnscNotifica> listAllByRicerca (RicercaNotifica ricerca, Pageable pageable)
}