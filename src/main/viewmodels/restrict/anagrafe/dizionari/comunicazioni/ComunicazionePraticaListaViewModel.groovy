package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneService
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazionePraticaListaViewModel extends DizionarioListaViewModel{

    Component opener
    AnaComunicazione comunicazione

    List<AnaComunicazionePratica> lista = []
    AnaComunicazionePratica dettaglio


    // Enum per le combobox
    final List<ETipoAnagrafe> listaTipiAnagrafe = [ETipoAnagrafe.RESIDENTI, ETipoAnagrafe.AIRE]
    final List<ETipoPratica> listaTipiPratica = ETipoPratica.values().toList()

    List<Map> addPlusList = []

    @WireVariable
    private AnaComunicazioneService anaComunicazioneService

    @WireVariable
    private AnaComunicazionePraticaService anaComunicazionePraticaService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("comunicazione") AnaComunicazione comunicazione,
               @ExecutionArgParam("opener") Component opener) {
        self = w

        addEnabled = false
        addPlusEnabled = true
        pagingEnabled = false
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazione")]

        eList.addAll(AnaComunicazionePratica.etichetteDomain)

        eList += ETipoAnagrafe.values()*.getEtichettaDesc() as Map
        eList += ETipoPratica.values()*.getEtichettaDesc() as Map


        doInitEtichette(eList)

        // Devo ricaricare la comunicazione perché l'include prende in maniera statica i parametri
        this.comunicazione = anaComunicazioneService.get(comunicazione.id)
        this.opener = opener

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazione"))

        totalSizeLabel = ""

        caricaLista()

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        popolaAddPlusList()
        refreshUi()
    }

    void resetDettaglio() {
        dettaglio = null
        caricaLista()
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info ("usePaging: " + usePaging)
        List<AnaComunicazionePratica> l = anaComunicazionePraticaService.findAllByComunicazione(comunicazione)


        return new Paginazione(l, l.size())
    }

    private void popolaAddPlusList() {
        addPlusList = []

        // Crea un Set delle coppie (archivio, pratica) già presenti per lookup veloce
        Set<List> coppieEsistenti = lista.collect {
            [it.archivioAnagrafe, it.tipoPratica]
        } as Set

        // Per ogni pratica del primo livello
        for (ETipoPratica pratica : listaTipiPratica) {
            // Filtra gli archivi del secondo livello escludendo quelli già associati
            List<Map> subList = listaTipiAnagrafe
                    .findAll { archivio ->
                        !coppieEsistenti.contains([archivio, pratica])
                    }
                    .collect { archivio ->
                        [id: archivio, descrizione: getEtichetta(archivio.getEtichettaDesc())]
                    }

            // Aggiungi la voce al menu solo se ci sono archivi disponibili
            if (subList) {
                addPlusList.add([
                        id: pratica,
                        descrizione: getEtichetta(pratica.getEtichettaDesc()),
                        tipo: 'P',
                        idDomain: pratica,
                        subList: subList
                ])
            }
        }
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazioni/comunicazionePraticaDettaglio.zul"
    }

    @Command
    void onInserisciPlus(@BindingParam("idParent") ETipoPratica tipoPratica, @BindingParam("idDomain") ETipoAnagrafe archivioAnagrafe) {
        if (comunicazione?.id) {
            apriDettaglio("/restrict/anagrafe/dizionari/comunicazioni/comunicazionePraticaDettaglio.zul", opener, [comunicazione: comunicazione, archivioAnagrafe: archivioAnagrafe, tipoPratica: tipoPratica])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvare_prima_la_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onModifica() {
        if (comunicazione) {
            apriDettaglio("/restrict/anagrafe/dizionari/comunicazioni/comunicazionePraticaDettaglio.zul", opener, [id: dettaglio.id])
        }
    }

    @Command
    void onElimina() {
        if (dettaglio) {
            Messagebox.show(
                    getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")),
                    msgTitle,
                    Messagebox.OK | Messagebox.CANCEL,
                    Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                anaComunicazionePraticaService.delete(dettaglio)
                                dettaglio = null
                                caricaLista()
                            }
                        }
                    }
            )
        }
    }

}
