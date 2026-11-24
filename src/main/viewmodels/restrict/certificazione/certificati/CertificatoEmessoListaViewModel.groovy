package restrict.certificazione.certificati

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviato
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
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CertificatoEmessoListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    List<CerCertificatoEmesso> lista
    CerCertificatoEmesso dettaglio

    RicercaCertificato ricercaCertificato
    List<CerTipoPagamento> listaTipoPagamento = []

    final List<ETipoSoggetto> listaTipoSoggettoCertificato = [null, ETipoSoggetto.BENEFICIARIO_CERTIFICATO, ETipoSoggetto.RICHIEDENTE_CERTIFICATO]

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<Map<String, String>> filtriList = []

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CerCertificatoEmessoService cerCertificatoEmessoService

    @WireVariable
    private CerTipoPagamentoService cerTipoPagamentoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = true
        modifyEnabled = false
        filtriExtraEnabled = true

        ricercaCertificato = new RicercaCertificato()

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Certificazione")]
        // Aggiungo etichette lista filtri
        eList.addAll([Etichette.getEtichetta("Estrazioni"), Etichette.getEtichetta("Stampa_Diritti")])
        // Aggiungo etichette ordinamento
        eList.addAll([Etichette.getEtichetta("Data_emissione_decrescente"), Etichette.getEtichetta("Data_emissione_crescente")])

        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)
        eList.addAll(WspaPagamentoInviato.etichetteDomain)

        // Aggiungo etichette tooltip stato pagamento
        eList.addAll([Etichette.getEtichetta("Inviato"), Etichette.getEtichetta("info_tooltip")])

        // Aggiungo etichette ricerca
        eList.addAll(RicercaCertificato.etichetteRicercaCerDesc)

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        filtriList = [[codice: "ESTRAZIONE", descrizione: getEtichetta(Etichette.getEtichetta("Estrazioni"))],
                      [codice: "DIRITTI", descrizione: getEtichetta(Etichette.getEtichetta("Stampa_Diritti"))]]

        msgTitle = getEtichetta(Etichette.getEtichetta("Certificazione"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Data_emissione_decrescente")), SortUtils.dataEmissioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_emissione_crescente")), SortUtils.dataEmissioneAsc)])

        //Default: data emissione discendente
        selectedOrder = listaOrder[0]

        resize()

        caricaListaTipiPagamento()

        caricaLista()
    }

    void caricaListaTipiPagamento() {
        listaTipoPagamento = [null] + cerTipoPagamentoService.listAll()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Command
    void onApri() {
        if (dettaglio) {
            Map<String, ?> params = new HashMap<String, ?>()
            params.put("id", dettaglio.id)
            apriDettaglio("/restrict/certificazione/certificati/certificatoEmessoDettaglio.zul", params)
        }
    }

    @Command
    void onInserisci() {
        if (addEnabled) {
            apriDettaglio("/restrict/certificazione/emissione/emissioneCertificato.zul", [:])
        }
    }

    @Command
    void onFiltriPlus(@BindingParam("codice") String codice) {
        if (filtriExtraEnabled) {
            switch (codice) {
                case "ESTRAZIONE":
                    apriDettaglio("stampe/stampaCertificatiLista.zul", [:])
                    break
                case "DIRITTI":
                    apriDettaglio("stampe/stampaDiritti.zul", [:])
                    break
            }
        }
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = cerCertificatoEmessoService.listAllByRicercaCertificato(ricercaCertificato, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    @Command void onResetRicerca(){
        resetRicerca()
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaCertificato, p)
        resetRicerca()
    }

    @Command void onSelectTipoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTipoCertificato) {
            ricercaCertificato.tipoCertificato = (CerTipoCertificato) event.getData()
        } else {
            ricercaCertificato.tipoCertificato = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

    @Command void onSelectTerminalista(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            ricercaCertificato.terminalista = (CerTerminalista) event.getData()
        } else {
            ricercaCertificato.terminalista = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

    @Command void onSelectModalitaRilascio(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerModalitaRilascio) {
            ricercaCertificato.modalitaRilascio = (CerModalitaRilascio) event.getData()
        } else {
            ricercaCertificato.modalitaRilascio = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaCertificato")
    }

}
