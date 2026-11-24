package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivLuogoMatrimonio
import it.finmatica.de4gsdzk.statocivile.CivLuogoMatrimonioService
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
class LuogoMatrimonioDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivLuogoMatrimonio dettaglio

    @WireVariable
    private CivLuogoMatrimonioService civLuogoMatrimonioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Luogo_Matrimonio"),]
        eList.addAll(CivLuogoMatrimonio.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Luogo_Matrimonio"),)

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
            dettaglio = civLuogoMatrimonioService.get(id)
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivLuogoMatrimonio(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivLuogoMatrimonio c = civLuogoMatrimonioService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
