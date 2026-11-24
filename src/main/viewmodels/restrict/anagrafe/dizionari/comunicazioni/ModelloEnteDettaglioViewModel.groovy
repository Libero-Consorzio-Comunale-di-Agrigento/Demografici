package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloEnteService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloService
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
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
class ModelloEnteDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaModelloEnte dettaglio

    ETipoOperazione tipoOperazione

    List<AnaEnte> listaEnti
    List<AnaModello> listaModelli
    List<ETipoModello> listaTipiModello = [ETipoModello.C, ETipoModello.P]

    @WireVariable
    private AnaModelloEnteService anaModelloEnteService

    @WireVariable
    private AnaEnteService anaEnteService

    @WireVariable
    private AnaModelloService anaModelloService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam('tipoModello') ETipoModello tipoModello) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Modelli_Ente")]
        eList.addAll(AnaModelloEnte.etichetteDomain)
        eList.addAll(ETipoModello.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modelli_Ente"))

        formLabel = msgTitle?.toUpperCase()

        // Carica liste per combobox
        listaEnti = anaEnteService.findAll()

        resize()

        if (id != null) {
            caricaDettaglio(id)
            popolaListaModelli()
        } else {
            creaDettaglio([tipoModello: tipoModello])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaModelloEnteService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaModelloEnte(params)
        onSelectTipoModello()
        tipoOperazione = ETipoOperazione.INS
    }

    void popolaListaModelli() {
        listaModelli = anaModelloService.findAllByTipoModello(dettaglio.tipoModello)
        refreshUi()
    }

    @Command
    void onSelectTipoModello(){
        popolaListaModelli()
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            dettaglio.codModello = dettaglio.modello.codModello
            AnaModelloEnte c = anaModelloEnteService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}