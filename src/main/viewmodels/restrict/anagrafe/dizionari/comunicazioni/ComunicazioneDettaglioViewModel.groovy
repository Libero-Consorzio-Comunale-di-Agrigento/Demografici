package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumentoService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneDettaglioViewModel extends DizionarioDettaglioViewModel {

    AnaComunicazione dettaglio

    ETipoOperazione tipoOperazione

    final List<ETipoComunicazioneAnagrafe> listaTipiComunicazione = Arrays.asList(ETipoComunicazioneAnagrafe.values())
    List<AnaModello> listaModelli = []
    List<AnaEnte> listaEnti = []
    List<AnaTipoDocumento> listaTipiDocumento = []

    @WireVariable
    private AnaComunicazioneService anaComunicazioneService

    @WireVariable
    private AnaModelloService anaModelloService

    @WireVariable
    private AnaEnteService anaEnteService

    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazioni")]
        eList.addAll(AnaComunicazione.etichetteDomain)
        eList.addAll(AnaCondizioneComunicazione.etichetteDomain)

        // Aggiungo etichette tipo comunicazione
        eList += ETipoComunicazioneAnagrafe.values()*.getEtichettaDesc() as Map

        // Etichette aggiuntive
        eList.addAll([
            Etichette.getEtichetta("Tipi_Pratica"),
            Etichette.getEtichetta("Condizioni"),
            Etichette.getEtichetta("Associazioni")
        ])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        listaEnti = anaEnteService.findAllByCdfIsFalse()
        listaTipiDocumento = anaTipoDocumentoService.findAllByFlagConvivenzaDiFattoNull()

        if (id != null) {
            caricaDettaglio(id)
            popolaListaModelli()
        } else {
            creaDettaglio([:])
        }

    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaComunicazioneService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaComunicazione(params)
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    void popolaListaModelli() {
        listaModelli = anaModelloService.findAllByTipoModello(ETipoModello.valueOf(dettaglio.tipoComunicazione.id))
    }

    @Command
    void onSelectTipoComunicazione(){
        dettaglio.modello = null
        dettaglio.codiceModello = null
        popolaListaModelli()
        refreshUi()
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            dettaglio.codiceModello = dettaglio.modello.codModello
            AnaComunicazione c = anaComunicazioneService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    String getUriPraticaLista(){
        String uri = ""
        if (tipoOperazione.isUpdate() && (dettaglio.id?.intValue() > 0) ) {
            uri = "dizionari/comunicazioni/comunicazionePraticaLista.zul"
        }
        return uri
    }

    String getUriCondizioneLista(){
        String uri = ""
        if (tipoOperazione.isUpdate() && (dettaglio.id?.intValue() > 0) ) {
            uri = "dizionari/comunicazioni/comunicazioneCondizioneLista.zul"
        }
        return uri
    }



}