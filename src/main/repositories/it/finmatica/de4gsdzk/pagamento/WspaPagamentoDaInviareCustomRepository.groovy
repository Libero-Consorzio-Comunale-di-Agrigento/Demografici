package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.pagamento.WspaPagamentoDaInviare
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface WspaPagamentoDaInviareCustomRepository {
    Page<WspaPagamentoDaInviare> findAllByRicercaCertificato(RicercaCertificato r, Pageable pageable)
}