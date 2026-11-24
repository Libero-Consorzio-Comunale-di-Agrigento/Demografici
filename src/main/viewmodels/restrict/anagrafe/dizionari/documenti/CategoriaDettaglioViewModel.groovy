package restrict.anagrafe.dizionari.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaCategoria
import it.finmatica.de4gsdzk.anagrafe.AnaCategoriaService
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumentoService
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CategoriaDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaCategoria dettaglio

    ETipoOperazione tipoOperazione

    List<AnaTipoDocumento> listaTipoDocumento = []

    @WireVariable
    private AnaCategoriaService anaCategoriaService

    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Categoria")]
        eList.addAll(AnaCategoria.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Categoria"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaTipoDocumento()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaTipoDocumento() {
        listaTipoDocumento = [null]
        List<AnaTipoDocumento> l = anaTipoDocumentoService.findAll()
        if (l.size() > 0) {
            listaTipoDocumento.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaCategoriaService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaCategoria(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaCategoria c = anaCategoriaService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.codice)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}