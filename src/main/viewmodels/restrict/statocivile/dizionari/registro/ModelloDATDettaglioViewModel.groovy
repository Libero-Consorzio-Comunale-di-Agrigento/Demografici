package restrict.statocivile.dizionari.registro

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.TraitGestioneTestiModello
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModelloDATDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneTestiModello{

    GestioneTestiGsdModello dettaglio

    final List<EFormatoTesto> listaFormatiTesto = [null] + EFormatoTesto.values().toList()

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Modello_DAT]
        eList.addAll(GestioneTestiGsdModello.etichetteDomain)
        eList.addAll(FileUtils.etichetteFileUtils)

        // Aggiungo etichette modello
        eList.addAll(etichetteGteModelloDefault)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Modello_DAT)

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([ambito: EAmbito.TB, gruppo: EGruppo.CIV])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = gestioneTestiGsdModelloService.get(id)
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new GestioneTestiGsdModello(params)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            GestioneTestiGsdModello c = gestioneTestiGsdModelloService.customSave(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        uploadModello(event, dettaglio)
    }

    @Command void onDownloadAllegato() {
        downloadModello(dettaglio)
    }

}
