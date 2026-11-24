package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.EGruppo
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

    ArcParametro dettaglio
    EGruppo gruppo

    ETipoOperazione tipoOperazione

    List<EGruppo> listaGruppi = EGruppo.values().toList()

    @WireVariable
    private ArcParametroService arcParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id, @ExecutionArgParam("gruppo") EGruppo g) {
        self = w
        gruppo = g

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametro")]
        eList.addAll(ArcParametro.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametro"))

        formLabel = msgTitle?.toUpperCase()

        resize()
        listaGruppi.remove(EGruppo.XXX)

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([flagVisibile: Boolean.TRUE])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = arcParametroService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new ArcParametro(flagVisibile: params.flagVisibile, gruppo: gruppo)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            ArcParametro c = arcParametroService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
