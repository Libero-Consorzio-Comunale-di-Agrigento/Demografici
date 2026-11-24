package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.pagamento.WspaParametro
import it.finmatica.de4gsdzk.pagamento.IWspaParametroService
import it.finmatica.de4gsdzk.pagamento.WspaParametroServiceFactory
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ParametroDettaglioViewModel extends DizionarioDettaglioViewModel {

    WspaParametro dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private WspaParametroServiceFactory wspaParametroServiceFactory
    private IWspaParametroService wspaParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {

        wspaParametroService = wspaParametroServiceFactory.getService()

        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametro")]
        eList.addAll(ArcParametro.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametro"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = wspaParametroService.get(id)

            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = wspaParametroService.create()

        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            WspaParametro c = wspaParametroService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
