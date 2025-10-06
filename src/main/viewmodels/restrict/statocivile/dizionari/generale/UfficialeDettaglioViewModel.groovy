package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivUfficiale
import it.finmatica.de4gsdzk.statocivile.CivUfficialeService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class UfficialeDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivUfficiale dettaglio

    @WireVariable
    private CivUfficialeService civUfficialeService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = []
        eList.addAll(CivUfficiale.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Ufficiale)

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
            dettaglio = civUfficialeService.get(id)
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivUfficiale(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivUfficiale c = civUfficialeService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
