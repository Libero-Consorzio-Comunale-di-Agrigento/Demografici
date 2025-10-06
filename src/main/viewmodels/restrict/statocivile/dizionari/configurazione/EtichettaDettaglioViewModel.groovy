package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichetta
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EtichettaDettaglioViewModel extends AbstractDettaglioViewModel{

    GsdEtichetta dettaglio

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id){
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.Etichette]
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(GsdEtichetta.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Etichette)

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = gsdEtichettaService.get(id)
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new GsdEtichetta(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            GsdEtichetta c = gsdEtichettaService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
