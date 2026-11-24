package restrict.anagrafe.dizionari

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceEnte
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceEnteService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.utils.ESiglaEnteAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
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
import restrict.TraitComune
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EnteDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitComune {

    AnaEnte dettaglio

    ETipoOperazione tipoOperazione

    List<AnpCodiceEnte> listaCodiceEnte = []
    List<ESiglaEnteAnagrafe> listaSigle

    @WireVariable
    private AnaEnteService anaEnteService

    @WireVariable
    private AnpCodiceEnteService anpCodiceEnteService

    boolean sezioneComunicazioni

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id, @ExecutionArgParam('comunicazioni') Boolean comunicazioni) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Enti_Emissione"), Etichette.getEtichetta("Enti")]
        eList.addAll(AnaEnte.etichetteDomain)

        doInitEtichette(eList)

        sezioneComunicazioni = comunicazioni

        msgTitle = sezioneComunicazioni ? getEtichetta(Etichette.getEtichetta("Enti")) : getEtichetta(Etichette.getEtichetta("Enti_Emissione"))
        formLabel = msgTitle?.toUpperCase()

        if(sezioneComunicazioni) {
            listaSigle = ESiglaEnteAnagrafe.values().toList()
        }

        resize()

        caricaListaCodiceEnte()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaCodiceEnte() {
        listaCodiceEnte = [null]
        List<AnpCodiceEnte> l = anpCodiceEnteService.listAll()
        if (l.size() > 0) {
            listaCodiceEnte.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaEnteService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaEnte(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaEnte c = anaEnteService.save(tipoOperazione, dettaglio, sezioneComunicazioni)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.codice)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        switch (tc) {
            case ETipoComuneAtto.ENTE:
                riempiComune(dettaglio.comune, c)
                break
        }
        refreshUi()
    }

}