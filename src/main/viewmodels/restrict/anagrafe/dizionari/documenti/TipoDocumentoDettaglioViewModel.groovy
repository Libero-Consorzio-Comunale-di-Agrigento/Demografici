package restrict.anagrafe.dizionari.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumentoService
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceTipoDocumento
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceTipoDocumentoService
import it.finmatica.de4gsdzk.anagrafe.EFlagCdf
import it.finmatica.de4gsdzk.anagrafe.ETipoAcquisizione
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
class TipoDocumentoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaTipoDocumento dettaglio

    ETipoOperazione tipoOperazione

    List<ETipoAcquisizione> listaTipoAcquisizione = ETipoAcquisizione.values() as List
    List<EFlagCdf> listaFlagCdf = EFlagCdf.values() as List
    List<AnpCodiceTipoDocumento> listaAnpCodici = []

    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService

    @WireVariable
    private AnpCodiceTipoDocumentoService anpCodiceTipoDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Tipo_Documento")]
        eList.addAll(AnaTipoDocumento.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Doc_Soggiorno_tooltip"), Etichette.getEtichetta("Doc_Identita_tooltip"),
                      Etichette.getEtichetta("Doc_Riconoscimento_tooltip")])

        // Aggiungo etichette enum
        eList.addAll(ETipoAcquisizione.values()*.getEtichettaDesc())
        eList.addAll(EFlagCdf.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Tipo_Documento"))

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
        List<AnpCodiceTipoDocumento> l = anpCodiceTipoDocumentoService.listAll()
        if (l.size() > 0) {
            listaAnpCodici.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaTipoDocumentoService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaTipoDocumento(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    @NotifyChange("dettaglio")
    void onToggleFlagArchiviazione() {
        // Se viene deselezionato FLAG_ARCHIVIAZIONE, resetta TIPO_ACQUISIZIONE
        if (!dettaglio.flagArchiviazione) {
            dettaglio.tipoAcquisizione = null
        }
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaTipoDocumento c = anaTipoDocumentoService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}