package restrict.anagrafe.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaTitoloStudio
import it.finmatica.de4gsdzk.anagrafe.AnaTitoloStudioService
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceTitoloStudio
import it.finmatica.de4gsdzk.anagrafe.EGruppoTitoloStudio
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnpCodiceTitoloStudioService
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
class TitoloStudioDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaTitoloStudio dettaglio

    ETipoOperazione tipoOperazione

    List<EGruppoTitoloStudio> listaGruppo = EGruppoTitoloStudio.values() as List
    List<AnpCodiceTitoloStudio> listaAnpCodici = []

    @WireVariable
    private AnaTitoloStudioService anaTitoloStudioService

    @WireVariable
    private AnpCodiceTitoloStudioService anpCodiceTitoloStudioService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Titolo_Studio")]
        eList.addAll(AnaTitoloStudio.etichetteDomain)

        // Aggiungo etichette gruppo titolo studio
        eList.addAll(EGruppoTitoloStudio.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Titolo_Studio"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaAnpCodici()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaAnpCodici() {
        listaAnpCodici = [null]
        List<AnpCodiceTitoloStudio> l = anpCodiceTitoloStudioService.listAll()
        if (l.size() > 0) {
            listaAnpCodici.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaTitoloStudioService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaTitoloStudio(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaTitoloStudio c = anaTitoloStudioService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.codice)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}