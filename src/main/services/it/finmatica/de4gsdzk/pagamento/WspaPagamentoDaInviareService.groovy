package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

abstract class WspaPagamentoDaInviareService {
    protected StatoCivileService statoCivileService
    protected UtenteCustomService utenteCustomService

    WspaPagamentoDaInviareService(StatoCivileService statoCivileService, UtenteCustomService utenteCustomService) {
        this.statoCivileService = statoCivileService
        this.utenteCustomService = utenteCustomService
    }

    abstract Page<WspaPagamentoDaInviare> listAll(RicercaCertificato ricercaCertificato, PageRequest p)

    void updateNumeroDocumento(Collection<WspaPagamentoDaInviare> daInviareList) {
        daInviareList = daInviareList as Collection<DepagPagamentoDaInviare>
        Integer anno = DataUtils.getAnnoCorrente()
        Integer progressivo = statoCivileService.getNumeroPagamento(anno)

        daInviareList.each { WspaPagamentoDaInviare wspaPagamentoDaInviare ->
            wspaPagamentoDaInviare.anno = anno
            wspaPagamentoDaInviare.progressivo = progressivo
        }

        saveAll(daInviareList)
    }

    abstract void saveAll(Collection<WspaPagamentoDaInviare> pagamentiDaInviare)

    abstract void validaInvioPagamento(Collection<WspaPagamentoDaInviare> collection)

    void inviaPagamento(Collection<WspaPagamentoDaInviare> collection) {
        validaInvioPagamento(collection)

        updateNumeroDocumento(collection)

        List<String> responses = []
        collection.each {
            String response = statoCivileService.invioPagamentoWspa(it.anno, it.progressivo, utenteCustomService.loggedUserId)
            if (!TestoUtils.isVuoto(response)) {
                responses.add(response)
            }
        }
        if (!responses.isEmpty()) {
            throw new InvioPagamentoRuntimeException(responses.join("\n"))
        }
    }
}