package it.finmatica.de4gsdzk.pagamento

import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

abstract class WspaPagamentoDaInviareService {
    protected GsdService gsdService
    protected UtenteCustomService utenteCustomService

    WspaPagamentoDaInviareService(GsdService gsdService, UtenteCustomService utenteCustomService) {
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    abstract Page<WspaPagamentoDaInviare> listAll(RicercaCertificato ricercaCertificato, PageRequest p)

    void updateNumeroDocumento(Collection<WspaPagamentoDaInviare> daInviareList) {
        daInviareList = daInviareList as Collection<DepagPagamentoDaInviare>
        Integer anno = DataUtils.getAnnoCorrente()
        Integer progressivo = gsdService.getNumeroPagamento(anno)

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


        WspaPagamentoDaInviare primo = collection.first()
        String response = gsdService.invioPagamentoWspa(primo.anno, primo.progressivo, utenteCustomService.loggedUserId)
        if (!TestoUtils.isVuoto(response)) {
            throw new InvioPagamentoRuntimeException(response)
        }
    }
}