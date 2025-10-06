package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.CerTariffaDirittoService
import it.finmatica.de4gsdzk.certificazione.EDiritto
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TariffaDirittoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi{
    final List<EDiritto> listaDiritto = EDiritto.values()

    CerTariffaDiritto dettaglio

    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Tariffe_Diritti]
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(EDiritto.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tariffe_Diritti)

        formLabel = msgTitle?.toUpperCase()

        resize()

        self.addEventListener(CustomEvents.ON_SAVE_DETAIL, { event ->
            if (event.data?.tarrifaDirittoId != null) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)

                Long tarrifaDirittoId = event.data?.tarrifaDirittoId as Long
                caricaDettaglio(tarrifaDirittoId)
            }
        })

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = cerTariffaDirittoService.get(id)
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CerTariffaDiritto(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            Events.postEvent(CustomEvents.ON_SAVE_MASTER, self, [dettaglio: dettaglio])
        }
    }

    @Command void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

}
