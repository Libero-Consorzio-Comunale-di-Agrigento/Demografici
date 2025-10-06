package restrict.certificazione.pagamenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerModalitaRilascio
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.RicercaCertificato
import it.finmatica.de4gsdzk.pagamento.*
import it.finmatica.de4gsdzk.pagamento.depag.DepagPagamentoDaInviare
import it.finmatica.de4gsdzk.pagamento.error.InvioPagamentoRuntimeException
import it.finmatica.de4gsdzk.pagamento.error.ServizioNonCoerenteRuntimeException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
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
class PagamentoDaInviareListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    List<WspaPagamentoDaInviare> lista
    List<WspaPagamentoDaInviare> listaSelezionati
    WspaPagamentoDaInviare dettaglio

    RicercaCertificato ricercaCertificato

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    Boolean massiveCheck
    Boolean showMassiveCheck = Boolean.TRUE
    Boolean showDepagColumns = Boolean.FALSE

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private WspaPagamentoDaInviareServiceFactory wspaPagamentoDaInviareServiceFactory
    private WspaPagamentoDaInviareService wspaPagamentoDaInviareService

    @WireVariable
    private WspaPagamentoInviatoServiceFactory wspaPagamentoInviatoServiceFactory
    private WspaPagamentoInviatoService wspaPagamentoInviatoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        wspaPagamentoDaInviareService = wspaPagamentoDaInviareServiceFactory.getService()

        wspaPagamentoInviatoService = wspaPagamentoInviatoServiceFactory.getService()

        showDepagColumns = arcParametroService.getServizioPagamento() == EServizioPagamento.DEPAG

        additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonPagoPa.zul"

        addEnabled = false
        modifyEnabled = false
        filtriExtraEnabled = false

        ricercaCertificato = new RicercaCertificato()

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Pagamenti_da_inviare]
        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)
        eList.addAll(DepagPagamentoDaInviare.etichetteDomain)

        // Aggiungo etichette ricerca
        eList.addAll(RicercaCertificato.etichetteRicercaCerDesc)

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette order
        eList.addAll([Etichette.Data_emissione_decrescente, Etichette.Data_emissione_crescente])

        eList.addAll()

        // Aggiungo etichette per messaggi restituiti da funzioni invio
        eList.addAll([EtichetteMessaggi.Info_Invio_pagamento_successo, EtichetteMessaggi.Errore_Invio_pagamento,
                      EtichetteMessaggi.Errore_Invio_pagamento_servizi_non_coerenti, EtichetteMessaggi.Warn_Nessun_elemento_selezionato])

        // Aggiungo etichette per bottone aggiuntivo
        eList.addAll(Etichette.invia_pagamento_tooltip)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Pagamenti_da_inviare)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.Data_emissione_decrescente), SortUtils.dataEmissioneDesc),
                           new OrderBy(getEtichetta(Etichette.Data_emissione_crescente), SortUtils.dataEmissioneAsc)])

        //Default: data emissione discendente
        selectedOrder = listaOrder[0]

        resize()

        caricaLista()
    }

    void caricaLista() {
        listaSelezionati = []
        massiveCheck = Boolean.FALSE

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = wspaPagamentoDaInviareService.listAll(ricercaCertificato, pr)

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
    void onResetRicerca() {
        resetRicerca()
    }

    @Command
    void onRicerca() {
        onRicarica()
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaCertificato, p)
        resetRicerca()
    }

    @Command
    void onSelectTipoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTipoCertificato) {
            ricercaCertificato.tipoCertificato = (CerTipoCertificato) event.getData()
        } else {
            ricercaCertificato.tipoCertificato = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

    @Command
    void onSelectTerminalista(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            ricercaCertificato.terminalista = (CerTerminalista) event.getData()
        } else {
            ricercaCertificato.terminalista = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

    @Command
    void onSelectModalitaRilascio(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerModalitaRilascio) {
            ricercaCertificato.modalitaRilascio = (CerModalitaRilascio) event.getData()
        } else {
            ricercaCertificato.modalitaRilascio = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

    @Command
    void onSelezionaTutte() {
        for (WspaPagamentoDaInviare c : lista) {
            seleziona(massiveCheck, c)
        }
        refreshUi()
    }

    @Command
    void onSelezionaPagamentoDaInviare(@BindingParam("selected") Boolean selected, @BindingParam("pagamentoDaInviare") WspaPagamentoDaInviare pagamentoDaInviare) {
        seleziona(selected, pagamentoDaInviare, Boolean.TRUE)
    }

    void seleziona(Boolean selected, WspaPagamentoDaInviare pagamentoDaInviare, Boolean updateDettaglio = false) {
        if (selected) {
            if (!(isSelezionata(pagamentoDaInviare))) {
                listaSelezionati.add(pagamentoDaInviare)
                if (updateDettaglio) {
                    setDettaglio(pagamentoDaInviare)
                }
            }
        } else {
            if (isSelezionata(pagamentoDaInviare)) {
                listaSelezionati.remove(pagamentoDaInviare)
            }
        }
        BindUtils.postNotifyChange(null, null, this, "listaSelezionati")
    }

    Boolean isSelezionata(WspaPagamentoDaInviare pagamentoDaInviare) {
        for (WspaPagamentoDaInviare c : listaSelezionati) {
            if (c.id.compareTo(pagamentoDaInviare.id) == 0) {
                return Boolean.TRUE
            }
        }
        return Boolean.FALSE
    }

    @Command
    void onInviaPagamento() {
        if (listaSelezionati.size() == 0) {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Nessun_elemento_selezionato), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }
        try {
            wspaPagamentoDaInviareService.inviaPagamento(listaSelezionati)

            Integer anno = listaSelezionati.first().anno
            Integer progressivo = listaSelezionati.first().progressivo
            WspaPagamentoInviato pagamentoInviato = wspaPagamentoInviatoService.findByAnnoAndProgressivo(anno, progressivo)
            if (pagamentoInviato == null) {
                throw new InvioPagamentoRuntimeException("Pagamento non trovato per l'anno $anno e il progressivo $progressivo")
            }

            String url = wspaPagamentoInviatoService.getUrl(pagamentoInviato)
            if (!TestoUtils.isVuoto(url)) {
                Clients.evalJavaScript("window.open('" + url + "', '_blank');")
            }

        } catch (ServizioNonCoerenteRuntimeException ex) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(ex.etichetta))
        } catch (InvioPagamentoRuntimeException ex) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, String.format(getEtichetta(ex.etichetta), ex.additionalInfo))
        }
        onRicarica()
    }

}
