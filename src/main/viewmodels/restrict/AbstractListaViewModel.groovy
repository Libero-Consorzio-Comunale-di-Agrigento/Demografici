package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
abstract class AbstractListaViewModel extends AbstractCommonViewModel {

    String filtro

    int activePage = Paginazione.activePage
    int pageSize = Paginazione.pageSize
    long totalSize = 0
    String totalSizeLabel

    Boolean wOpen = Boolean.FALSE

    abstract void caricaLista()
    abstract void resetDettaglio()
    abstract Paginazione eseguiQuery(Boolean usePaging)

    @Command void onRicarica(){
        resetActivePage()
        resetDettaglio()
        caricaLista()
    }

    @Command void onPagina() {
        resetDettaglio()
        caricaLista()
    }

    @Command void onResetFiltro() {
        filtro = ""
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "filtro")
    }

    @Command void onFiltro(@ContextParam(ContextType.TRIGGER_EVENT)Event event) {
        if (event?.getName() == Events.ON_CHANGING){
            filtro = event.value
        }
        onRicarica()
    }

    @Command void onRicerca() {
        onRicarica()
    }

    void resetLista(){}

    protected void resetRicerca(){
        resetLista()
        updateTotalSize(0L)
        resetActivePage()
        resetDettaglio()
        refreshUi()
    }

    void resetActivePage(){
        activePage = 0
        BindUtils.postNotifyChange(null, null, this, "activePage")
    }

    void apriDettaglio(String uri, Map params){
        apriDettaglio(uri, self, params)
    }

    void apriDettaglio(String uri, Component opener, Map params){
        if (!wOpen){
            Window w
            try{
                wOpen = Boolean.TRUE
                w = (Window) Executions.createComponents(uri, opener?.parent, params)
                opener.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    opener.setVisible(true)
                    wOpen = Boolean.FALSE
                    resetDettaglio()
                    //Se ho già effettuato una ricerca
                    if (totalSizeLabel){
                        reloadOnClose()
                    }
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura record", ex)
                Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_apertura_record), getEtichetta(Etichette.Modifica), Messagebox.OK, Messagebox.EXCLAMATION)
                wOpen = Boolean.FALSE
            }
        }
    }

    void reloadOnClose(){
        caricaLista()
    }

    protected void refreshLista(){
        BindUtils.postNotifyChange(null, null, this, "lista")
    }

    protected void refreshDettaglio(){
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    protected void refreshDettagli(){
        BindUtils.postNotifyChange(null, null, this, "dettagli")
    }

    void updateTotalSize(long v){
        totalSize = v
        totalSizeLabel = (getEtichetta(Etichette.Numero_record_trovati)?:"") + totalSize
        BindUtils.postNotifyChange(null, null, this, "totalSize")
        BindUtils.postNotifyChange(null, null, this, "totalSizeLabel")
    }

    String getEtichettaEnum(Enum e, String etichettaDefault=null) {
        return e ? getEtichetta(e.getEtichettaDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichettaPluralEnum(Enum e, String etichettaDefault=null) {
        return e ? getEtichetta(e.getEtichettaPluralDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichetta(Map<String, String> etichetta) {
        return etichetta ? getEtichetta((String) etichetta.codice) : ""
    }

    String getEtichetta(String codice) {
        return codice ? etichette[codice] : ""
    }

    String getEtichettaCustom(String codice) {
        return codice ? etichetteCustom[codice] : ""
    }

    static final List<Map<String, String>> etichetteListaDefault = [EtichetteMessaggi.Errore_apertura_record, EtichetteMessaggi.Ask_Cancellazione_Record,
                                                                    Etichette.Numero_record_trovati, Etichette.Nessun_dato_disponibile, Etichette.Nessun_record_trovato,
                                                                    Etichette.Funzione_non_abilitata, Etichette.Modifica]

}
