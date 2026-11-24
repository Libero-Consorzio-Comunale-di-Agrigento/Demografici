package restrict.certificazione.dizionari.pagamento


import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.CerTariffaDirittoService
import it.finmatica.de4gsdzk.certificazione.EDiritto
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.pagamento.IWspaVoceCostoService
import it.finmatica.de4gsdzk.pagamento.WspaVoceCosto
import it.finmatica.de4gsdzk.pagamento.WspaVoceCostoServiceFactory
import it.finmatica.de4gsdzk.pagamento.depag.DepagVoceCosto
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
class VoceCostoDettaglioViewModel extends DizionarioDettaglioViewModel {

    WspaVoceCosto dettaglio

    ETipoOperazione tipoOperazione

    List<CerTariffaDiritto> listaTariffaDiritto = []
    Boolean showDepagColumns

    @WireVariable
    private ArcParametroService arcParametroService
    @WireVariable
    private WspaVoceCostoServiceFactory wspaVoceCostoServiceFactory
    private IWspaVoceCostoService wspaVoceCostoService
    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id) {

        wspaVoceCostoService = wspaVoceCostoServiceFactory.getService()

        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Voce_di_costo")]
        eList.addAll(WspaVoceCosto.etichetteDomain)
        eList.addAll(DepagVoceCosto.etichetteDomain)
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(EDiritto.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Voce_di_costo"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        listaTariffaDiritto = cerTariffaDirittoService.listAll()
        showDepagColumns = arcParametroService.getServizioPagamento() == EServizioPagamento.DEPAG

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = wspaVoceCostoService.get(id)

            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = wspaVoceCostoService.create()

        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            WspaVoceCosto c = wspaVoceCostoService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
