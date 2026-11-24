package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.statocivile.embed.SoggettoDAT
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.AbstractRecuperoSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoListaSelectViewModel extends AbstractRecuperoSelectViewModel {

    List<Map> lista = []
    Map dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("matricola") Integer matricola){
        self = w

        pagingEnabled = false
        addEnabled = false
        modifyEnabled = false

        if (matricola != null){
            this.lista = gsdService.listDocumentoDAT(matricola)
        } else {
            this.lista = []
        }

        List<Map> eList = [Etichette.getEtichetta("Documenti")]
        eList.addAll(SoggettoDAT.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Documenti"))

        if (lista.size() == 0){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }

        updateTotalSize(lista.size())
    }

    void caricaLista(){
        log.info ("not implemented")
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)
        return null
    }

    @Command void onSeleziona() {
        if (dettaglio){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [documento: dettaglio] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

}
