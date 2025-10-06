package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscServiziArchiviDettaglioViewModel extends DizionarioDettaglioViewModel{

    List<AnscEndPointServizioArchivio> listaServiziArchiviAssociati
    List<AnscEndPointServizio> listaServiziNonAssociati

    AnscEndPointServizioArchivio dettaglio

    ETipoArchivioAnsc tipoArchivioAnsc

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoArchivioAnsc") ETipoArchivioAnsc tipoArchivioAnsc){
        self = w

        backFromRecordEnabled = true
        saveRecordEnabled = true
        //deleteRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Servizi_Ansc, Etichette.Nessun_dato_disponibile]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_servizio_ANSC, EtichetteMessaggi.Ask_Cancellazione_associazione_servizio_ANSC])

        eList.addAll(AnscEndPointServizio.etichetteDomain)
        eList.addAll(AnscEndPointServizioArchivio.etichetteDomain)

        // Aggiungo etichette tipo archivio
        eList.addAll(Arrays.asList(ETipoArchivioAnsc.values())*.etichettaDesc)

        doInitEtichette(eList)

        this.tipoArchivioAnsc = tipoArchivioAnsc

        msgTitle = getEtichetta(Etichette.Servizi_Ansc)

        formLabel = msgTitle?.toUpperCase()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([archivio: tipoArchivioAnsc])
        }

        caricaListe()
    }

    void caricaListaServiziArchiviAssociati() {
        listaServiziArchiviAssociati = []
    }

    void caricaListaServiziNonAssociati() {
        List<AnscEndPointServizio> l = [dettaglio.servizio]
        listaServiziNonAssociati = l?.sort{it?.servizio}
    }

    void caricaListe(){
        caricaListaServiziArchiviAssociati()
        caricaListaServiziNonAssociati()
        refreshUi()
    }

    @Command void onSalvaRecord(){
        if (dettaglio.servizio){
            AnscEndPointServizioArchivio c = anscEndPointServizioArchivioService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
            caricaListe()
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_servizio_ANSC), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Override
    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anscEndPointServizioArchivioService.get(id)
        }
        refreshUi()
    }

    @Override
    void creaDettaglio(Map params) {
        dettaglio = new AnscEndPointServizioArchivio(params)
    }

}
