package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumento
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumentoService
import it.finmatica.de4gsdzk.pagamento.depag.DepagServizio
import it.finmatica.de4gsdzk.pagamento.depag.DepagServizioService
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoDettaglioViewModel extends DizionarioDettaglioViewModel {

    DepagDocumento dettaglio

    ETipoOperazione tipoOperazione

    List<DepagServizio> listaServizio

    @WireVariable
    private DepagServizioService depagServizioService

    @WireVariable
    private DepagDocumentoService depagDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Documento]
        eList.addAll(DepagDocumento.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)
        eList.addAll(DepagServizio.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Documento)

        formLabel = msgTitle?.toUpperCase()

        resize()

        listaServizio = depagServizioService.listAll()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = depagDocumentoService.get(id)

            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new DepagDocumento()

        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            DepagDocumento c = depagDocumentoService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onSelectTipoCertificato(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTipoCertificato) {
            dettaglio.tipoCertificato = (CerTipoCertificato) event.getData()
        } else {
            dettaglio.tipoCertificato = null
        }
        refreshUi()
    }

}
