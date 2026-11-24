package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicoloService
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscCasiUsoAllegatiDettaglioViewModel extends DizionarioDettaglioViewModel {

    AnscEndPointServizioAllegato dettaglio

    ETipoOperazione tipoOperazione

    ETipoArchivioAnsc tipoArchivioAnsc

    List<AnscCasoUso> listaCasiUso = []
    AnscCasoUso casoUso

    List<AnscEndPointServizio> listaServizi
    List<CivTipoDocumentoFascicolo> listaAllegati

    @WireVariable
    private AnscEndPointServizioAllegatoService anscEndPointServizioAllegatoService

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @WireVariable
    private AnscEndPointServizioService anscEndPointServizioService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoArchivioAnsc") ETipoArchivioAnsc tipoArchivioAnsc) {
        self = w

        backFromRecordEnabled = true
        saveRecordEnabled = true
        //deleteRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Archivio"), Etichette.getEtichetta("Casi_Uso_Allegati"), Etichette.getEtichetta("Nessun_dato_disponibile")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_servizio_ANSC"), Etichette.getEtichetta("Ask_Cancellazione_associazione_servizio_ANSC")])

        eList.addAll(AnscEndPointServizioAllegato.etichetteDomain)

        // Aggiungo etichette tipo archivio
        eList.addAll((Arrays.asList(ETipoArchivioAnsc.values()))*.etichettaDesc)

        doInitEtichette(eList)

        this.tipoArchivioAnsc = tipoArchivioAnsc
        caricaCasiUso()

        listaServizi = anscEndPointServizioService.findAll()
        listaAllegati = civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoArchivioAnsc.tipoAtto)?.getContent() ?: []

        msgTitle = getEtichetta(Etichette.getEtichetta("Casi_Uso_Allegati"))

        formLabel = msgTitle?.toUpperCase()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }


    @Command
    void onSalvaRecord() {
        if (dettaglio.servizio) {
            dettaglio.idCasoUso = casoUso.id
            AnscEndPointServizioAllegato c = anscEndPointServizioAllegatoService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_servizio_ANSC")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Override
    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anscEndPointServizioAllegatoService.get(id as Long)
            tipoOperazione = ETipoOperazione.UPD
            casoUso = listaCasiUso.find { it.id == dettaglio?.idCasoUso }
        }
        refreshUi()
    }

    @Override
    void creaDettaglio(Map params) {
        dettaglio = new AnscEndPointServizioAllegato()
        casoUso = listaCasiUso.first()
        tipoOperazione = ETipoOperazione.INS
    }

    void caricaCasiUso() {
        listaCasiUso = anscCasoUsoService.findAllByTipoAtto(tipoArchivioAnsc.tipoAtto.valore)
    }

}
