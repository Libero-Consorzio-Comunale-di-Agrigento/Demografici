package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUso
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoService
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioService
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
class AnscCasiUsoArchiviDettaglioViewModel extends DizionarioDettaglioViewModel {

    AnscEndPointServizioArchivio dettaglio

    ETipoOperazione tipoOperazione

    ETipoArchivioAnsc tipoArchivioAnsc

    List<AnscCasoUso> listaCasiUso = []
    AnscCasoUso casoUso

    List<AnscEndPointServizio> listaServizi

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @WireVariable
    private AnscEndPointServizioService anscEndPointServizioService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoArchivioAnsc") ETipoArchivioAnsc tipoArchivioAnsc) {
        self = w

        backFromRecordEnabled = true
        saveRecordEnabled = true
        //deleteRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Casi_Uso_Servizi"), Etichette.getEtichetta("Nessun_dato_disponibile")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_servizio_ANSC"), Etichette.getEtichetta("Ask_Cancellazione_associazione_servizio_ANSC")])

        eList.addAll(AnscEndPointServizio.etichetteDomain)
        eList.addAll(AnscEndPointServizioArchivio.etichetteDomain)

        // Aggiungo etichette tipo archivio
        eList.addAll((Arrays.asList(ETipoArchivioAnsc.values()))*.etichettaDesc)

        doInitEtichette(eList)

        this.tipoArchivioAnsc = tipoArchivioAnsc
        caricaCasiUso()

        listaServizi = anscEndPointServizioService.findAll()

        msgTitle = getEtichetta(Etichette.getEtichetta("Casi_Uso_Servizi"))

        formLabel = msgTitle?.toUpperCase()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([archivio: tipoArchivioAnsc])
        }
    }


    @Command
    void onSalvaRecord() {
        if (dettaglio.servizio) {
            dettaglio.idCasoUso = casoUso.id
            AnscEndPointServizioArchivio c = anscEndPointServizioArchivioService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_servizio_ANSC")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Override
    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anscEndPointServizioArchivioService.get(id as Long)
            tipoOperazione = ETipoOperazione.UPD
            casoUso = listaCasiUso.find { it.id == dettaglio?.idCasoUso }
        }
        refreshUi()
    }

    @Override
    void creaDettaglio(Map params) {
        dettaglio = new AnscEndPointServizioArchivio(params)
        casoUso = listaCasiUso.first()
        tipoOperazione = ETipoOperazione.INS
    }

    void caricaCasiUso() {
        listaCasiUso = anscCasoUsoService.findAllByTipoAtto(tipoArchivioAnsc.tipoAtto.valore)
    }

}
