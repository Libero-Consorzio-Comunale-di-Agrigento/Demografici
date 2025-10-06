package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivLuogoNascita
import it.finmatica.de4gsdzk.statocivile.CivLuogoNascitaService
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
class LuogoNascitaDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivLuogoNascita dettaglio

    @WireVariable
    private CivLuogoNascitaService civLuogoNascitaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Luogo_Nascita]
        eList.addAll(CivLuogoNascita.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Luogo_Nascita)

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
            dettaglio = civLuogoNascitaService.get(id)
        }
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivLuogoNascita(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivLuogoNascita c = civLuogoNascitaService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
