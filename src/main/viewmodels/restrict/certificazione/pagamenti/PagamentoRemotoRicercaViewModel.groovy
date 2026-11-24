package restrict.certificazione.pagamenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoRemoto
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoRemotoService
import it.finmatica.de4gsdzk.pagamento.error.VerificaPagamentoRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.MessaggioUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PagamentoRemotoRicercaViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi {

    DepagPagamentoRemoto dettaglio

    String chiaveServizioEsternoRicerca

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private DepagPagamentoRemotoService depagPagamentoRemotoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Ricerca_pagamento"), Etichette.getEtichetta("Pagamento"), Etichette.getEtichetta("Ricerca_Iuv"), 
                                           Etichette.getEtichetta("IP_pagamento"), Etichette.getEtichetta("SV_singolo_versamento")]

        eList.addAll([Etichette.getEtichetta("Info_Verifica_pagamento_successo"), Etichette.getEtichetta("Errore_Verifica_pagamento")])

        eList.addAll(DepagPagamentoRemoto.etichetteDomain)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Ricerca_pagamento"))

        formLabel = msgTitle?.toUpperCase()

        resize()

    }

    @Command
    void onRicerca() {
        if (TestoUtils.isVuoto(chiaveServizioEsternoRicerca)) {
            return
        }

        try {
            depagPagamentoRemotoService.verificaPagamento(chiaveServizioEsternoRicerca)
            caricaDettaglio(chiaveServizioEsternoRicerca)
        } catch (VerificaPagamentoRuntimeException ex) {
            log.error(ex.message, ex)
            resetRicerca()
        }

        caricaDettaglio(chiaveServizioEsternoRicerca)
    }

    void caricaDettaglio(def id) {
        if (id == null) {
            throw new IllegalArgumentException("id non specificato")
        }
        dettaglio = depagPagamentoRemotoService.findById(id as String)
        if (dettaglio == null) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, "Pagamento non trovato")
        }

        refreshUi()
    }

    void creaDettaglio(Map params) {
        throw new UnsupportedOperationException("Not implemented")
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(this, p)
        resetRicerca()
    }

    protected void resetRicerca() {
        dettaglio = null
        refreshUi()
    }


}
