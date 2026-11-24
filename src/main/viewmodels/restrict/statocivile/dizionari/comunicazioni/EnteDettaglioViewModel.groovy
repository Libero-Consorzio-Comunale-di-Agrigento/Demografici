package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivEnte
import it.finmatica.de4gsdzk.statocivile.CivEnteService
import it.finmatica.de4gsdzk.utils.ESiglaEnteStatoCivile
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
class EnteDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivEnte dettaglio

    ETipoOperazione tipoOperazione

    final List<ESiglaEnteStatoCivile> listaSigle = ESiglaEnteStatoCivile.values().toList()

    @WireVariable
    private CivEnteService civEnteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Ente")]
        eList.addAll(CivEnte.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Ente"))

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
            dettaglio = civEnteService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        tipoOperazione = ETipoOperazione.INS
        dettaglio = new CivEnte(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivEnte c = civEnteService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
