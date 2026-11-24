package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivUfficio
import it.finmatica.de4gsdzk.statocivile.CivUfficioService
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
class UfficioDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivUfficio dettaglio

    @WireVariable
    private CivUfficioService civUfficioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = []
        eList.addAll(CivUfficio.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Ufficio"))

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
            dettaglio = civUfficioService.get(id)
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivUfficio(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivUfficio c = civUfficioService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
