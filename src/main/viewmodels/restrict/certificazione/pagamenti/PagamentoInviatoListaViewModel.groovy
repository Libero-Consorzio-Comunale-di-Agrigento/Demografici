package restrict.certificazione.pagamenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.pagamento.*
import it.finmatica.de4gsdzk.pagamento.error.AnnullaPagamentoRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.VerificaPagamentoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zk.ui.util.Clients
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PagamentoInviatoListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    final List<EStatoInvio> listaStato = [null, EStatoInvio.INVIATO_CON_SUCCESSO, EStatoInvio.INVIO_NON_RIUSCITO]

    List<WspaPagamentoInviato> lista
    WspaPagamentoInviato dettaglio

    FunzioniPresentation<EFunzionePagamentoInviato> funzioniDettaglio = new FunzioniPresentation<>(EFunzionePagamentoInviato.class)

    RicercaPagamentoInviato ricercaPagamentoInviato
    List<OrderBy> listaOrder = []

    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private WspaPagamentoInviatoServiceFactory wspaPagamentoInviatoServiceFactory

    private WspaPagamentoInviatoService wspaPagamentoInviatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        wspaPagamentoInviatoService = wspaPagamentoInviatoServiceFactory.getService()

        addEnabled = false
        modifyEnabled = false
        filtriExtraEnabled = false

        ricercaPagamentoInviato = new RicercaPagamentoInviato()

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Pagamenti_inviati"), Etichette.getEtichetta("Pagamento"), Etichette.getEtichetta("Inviato"), Etichette.getEtichetta("info_tooltip")]
        eList.addAll(WspaPagamentoInviato.etichetteDomain)
        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)

        // Aggiungo etichette ricerca
        eList.addAll(RicercaPagamentoInviato.etichetteRicercaCerDesc)
        eList.addAll(EStatoInvio.values()*.getEtichettaDesc())

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette order
        eList.addAll([Etichette.getEtichetta("Data_Invio_decrescente"), Etichette.getEtichetta("Data_Invio_crescente")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato")])

        // Aggiungo etichette funzioni dettaglio
        eList.addAll(EFunzionePagamentoInviato.values()*.getEtichettaDesc())

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([Etichette.getEtichetta("Info_Invio_pagamento_successo"), Etichette.getEtichetta("Errore_Invio_pagamento"),
                      Etichette.getEtichetta("Info_Verifica_pagamento_successo"), Etichette.getEtichetta("Errore_Verifica_pagamento"),
                      Etichette.getEtichetta("Info_Annullamento_pagamento_successo"), Etichette.getEtichetta("Errore_Annulla_pagamento"), Etichette.getEtichetta("Ask_Annulla_pagamento")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Pagamenti_inviati"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Invio_decrescente")), SortUtils.dataPagamentoDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Invio_crescente")), SortUtils.dataPagamentoAsc)])

        //Default: data emissione discendente
        selectedOrder = listaOrder[0]

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = wspaPagamentoInviatoService.listAll(ricercaPagamentoInviato, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onSelectDettaglio() {
        funzioniDettaglio.setFunzioni(wspaPagamentoInviatoService.getFunzioniPagamentoInviato(dettaglio))
        refreshUi()
    }

    @Command
    void onResetRicerca() {
        resetRicerca()
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaPagamentoInviato, p)
        resetRicerca()
    }

    @Command
    void onRipetiInvio() {
        try {
            wspaPagamentoInviatoService.inviaPagamento(dettaglio)

            // Ricarico il dettaglio perché l'invio dovrebbe aver valorizzato i dati del pagamento (es. chiave esterna o url servizio esterno)
            ricaricaDettaglio()

            openUrlPagamento()
        } catch (InvioPagamentoRuntimeException ex) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, String.format(getEtichetta(ex.etichetta), ex.additionalInfo))
        }
        onRicarica()
    }

    private void ricaricaDettaglio() {
        Integer anno = dettaglio.anno
        Integer progressivo = dettaglio.progressivo
        dettaglio = wspaPagamentoInviatoService.findByAnnoAndProgressivo(anno, progressivo)
        if (dettaglio == null) {
            throw new InvioPagamentoRuntimeException("Pagamento non trovato per l'anno $anno e il progressivo $progressivo")
        }
        refreshUi()
    }

    private void openUrlPagamento() {
        String url = wspaPagamentoInviatoService.getUrl(dettaglio)
        if (!TestoUtils.isVuoto(url)) {
            Clients.evalJavaScript("window.open('" + url + "', '_blank');")
        }
    }

    @Command
    void onConfermaPagamento() {
        openUrlPagamento()
    }

    @Command
    void onVerificaPagamento() {
        try {
            wspaPagamentoInviatoService.verificaPagamento(dettaglio)
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.I, getEtichetta(Etichette.getEtichetta("Info_Verifica_pagamento_successo")))
        } catch (VerificaPagamentoRuntimeException ex) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, String.format(getEtichetta(ex.etichetta), ex.additionalInfo))
        }
        onRicarica()
    }

    @Command
    void onAnnullaPagamento() {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Annulla_pagamento")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())) {
                            try {
                                wspaPagamentoInviatoService.annullaPagamento(dettaglio)
                                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.I, getEtichetta(Etichette.getEtichetta("Info_Annullamento_pagamento_successo")))
                            } catch (AnnullaPagamentoRuntimeException ex) {
                                MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, String.format(getEtichetta(ex.etichetta), ex.additionalInfo))
                            }
                            onRicarica()
                        }
                    }
                }
        )
    }

}
