package restrict.afc

import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel
import restrict.TraitCancellazioneCampi

@VariableResolver(DelegatingVariableResolver)
class PopupImportAllegatiViewModel extends AbstractSelectViewModel implements TraitCancellazioneCampi {

    List<IDocumentoEsterno> lista = []
    List<IDocumentoEsterno> dettagli

    IDocumentoEsterno dettaglio

    RicercaProtocollo ricercaProtocollo

    @WireVariable
    private IntegrazioneDocumentaleService integrazioneDocumentaleService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {

        this.self = w

        ricercaProtocollo = new RicercaProtocollo()
        ricercaProtocollo.anno = DataUtils.getAnnoCorrente()

        List<Map<String, String>> eList = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Protocolli"), Etichette.getEtichetta("Importa"),
                                           Etichette.getEtichetta("Oggetto"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Da"), 
                                           Etichette.getEtichetta("A"), Etichette.getEtichetta("Data")]
        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Protocolli"))
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    void resetDettaglio(){
        dettagli = null
        BindUtils.postNotifyChange(null, null, this, "dettagli")
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null), ricercaProtocollo:ricercaProtocollo]
        return integrazioneDocumentaleService.listProtocolli(params)
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(ricercaProtocollo, p)
    }

    @Command onImportaDocumenti() {
        if (dettagli){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, dettagli)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
