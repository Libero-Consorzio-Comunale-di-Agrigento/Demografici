package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractCommonViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class GestioneAvanzamentoPraticaViewModel extends AbstractCommonViewModel {

    AnaPratica pratica

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private AnaPraticaService anaPraticaService
    @WireVariable
    private AnaEventoPraticaService anaEventoPraticaService
    @WireVariable
    private AnaAvanzamentoPraticaService anaAvanzamentoPraticaService

    List<AnaEventoPratica> listaEventiPratica
    List<EEsito> listaEsiti

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("idAvanzamento") Integer idAvanzamento) {

        self = w

        List<Map<String, String>> eList = AnaAvanzamentoPratica.etichetteDomain
        //Etichette enumerativi
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())
        eList.addAll(EEsito.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("inserisci_avanzamento_tooltip"), Etichette.getEtichetta("Nessun_Avanzamento_Presente"), Etichette.getEtichetta("Ask_Modifiche_In_Sospeso"),
                      Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("Ask_Evento_Pratica"), Etichette.getEtichetta("Chiusura"),
                      Etichette.getEtichetta("salva_tooltip"), Etichette.getEtichetta("Annullamento_Perfezionamento_Presenti"), Etichette.getEtichetta("Impossibile_Inserire_Avanzamento"),
                      Etichette.getEtichetta("comunicazioni_tooltip"), Etichette.getEtichetta("adempimenti_tooltip"), Etichette.getEtichetta("allegati_tooltip")])

        popolaAvanzamenti(id)

        listaEventiPratica = anaEventoPraticaService.findEventiValidi(pratica.archivioAnagrafe, pratica.tipoPratica)
        listaEsiti = [null] + EEsito.values().toList()

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Avanzamento_Pratica"))
        formLabel = msgTitle?.toUpperCase()

        if (idAvanzamento != null) {
            AnaAvanzamentoPratica avanzamento = anaAvanzamentoPraticaService.findById(idAvanzamento)
            onSelectEsito(avanzamento)
        }


    }

    void popolaAvanzamenti(Long id) {
        pratica = anaPraticaService.findAvanzamentiById(id)
        pratica?.avanzamentiPratica?.sort { it.sequenza }
    }

    @Command
    void onBackFromList() {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), getEtichetta(Etichette.getEtichetta("Chiusura")), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())) {
                            if (pratica.avanzamentiPratica.any { it.eventoPratica?.flagAnnullamento && it?.inserito} && !pratica.flagAnnullamento ) {
                                Events.postEvent(Events.ON_CLOSE, self, [annulla: true])
                                return
                            } else if (pratica.avanzamentiPratica.any { it.eventoPratica?.flagPerfezionamento && it?.inserito} && !pratica.flagPerfezionamento) {
                                Events.postEvent(Events.ON_CLOSE, self, [perfeziona: true])
                                return
                            }
                            Events.postEvent(Events.ON_CLOSE, self, [:])
                        }
                    }
                }
        )
    }

    @Command
    void onSalva() {
        checkDatiObbligatori()

        for (AnaAvanzamentoPratica a : pratica.avanzamentiPratica) {
            if (a.id == null) {
                a.id = gsdService.getIntegerIdFromSequence(a, a.getTableName())
            }
        }

        anaPraticaService.saveAvanzamenti(pratica)

        onChiudi()
    }

    private void checkDatiObbligatori() {
        String sezione = "Avanzamento Pratica"
        for (AnaAvanzamentoPratica a : pratica.avanzamentiPratica) {
            if (a.eventoPratica == null || a.dataEvento == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            if (pratica.numero < 0 && (a.eventoPratica.flagAnnullamento || a.eventoPratica.flagPerfezionamento)) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Impossibile_Inserire_Avanzamento")))
            }
        }

        if (pratica.avanzamentiPratica.any { it.eventoPratica.flagAnnullamento && it.inserito} && pratica.avanzamentiPratica.any { it.eventoPratica.flagPerfezionamento && it.inserito}) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Annullamento_Perfezionamento_Presenti")))
        }
    }

    @Command
    void onInserisciAvanzamento() {
        inserisciAvanzamento(null)
    }

    private void inserisciAvanzamento(AnaEventoPratica evento) {

        if (pratica.numero < 0 && evento != null && (evento?.flagAnnullamento || evento?.flagPerfezionamento)) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Impossibile_Inserire_Avanzamento")))
        }

        AnaAvanzamentoPratica avanzamentoPratica = new AnaAvanzamentoPratica()
        avanzamentoPratica.archivioAnagrafe = pratica.archivioAnagrafe
        avanzamentoPratica.tipoPratica = pratica.tipoPratica
        avanzamentoPratica.pratica = pratica
        avanzamentoPratica.idPratica = pratica.idPratica
        avanzamentoPratica.numeroPratica = pratica.numero
        avanzamentoPratica.annoPratica = pratica.anno
        avanzamentoPratica.eventoPratica = evento
        avanzamentoPratica.inserito = true
        if (evento) {
            avanzamentoPratica.sequenza = gsdService.getSequenzaAvanzamento(avanzamentoPratica)
        }
        pratica.avanzamentiPratica.add(avanzamentoPratica)
        refreshUi()
    }

    @Command
    void onEliminaAvanzamento(@BindingParam("avanzamento") AnaAvanzamentoPratica avanzamento) {
        pratica.avanzamentiPratica.remove(avanzamento)
        avanzamento.pratica = null
        avanzamento.idPratica = null
        refreshUi()
    }

    @Command
    void onSelectEvento(@BindingParam("avanzamento") AnaAvanzamentoPratica avanzamento) {
        if (pratica.numero < 0 && (avanzamento.eventoPratica.flagAnnullamento || avanzamento.eventoPratica.flagPerfezionamento)) {
            avanzamento.eventoPratica == null
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Impossibile_Inserire_Avanzamento")))
        }
        if (!avanzamento.eventoPratica.flagOnline) {
            avanzamento.flagOnline = false
        }

        if (!avanzamento.eventoPratica.flagEsito) {
            avanzamento.esito = null
        }

        avanzamento.sequenza = gsdService.getSequenzaAvanzamento(avanzamento)

        refreshUi()
    }

    @Command
    void onSelectEsito(@BindingParam("avanzamento") AnaAvanzamentoPratica avanzamento) {
        AnaEventoPratica evento = null

        if (avanzamento.eventoPratica && avanzamento.esito) {
            evento = anaEventoPraticaService.findNextEvento(avanzamento.eventoPratica, avanzamento.esito, pratica.archivioAnagrafe, pratica.tipoPratica)
        }
        if (evento) {
            Messagebox.show("${getEtichetta(Etichette.getEtichetta("Ask_Evento_Pratica"))} ${evento.descrizione}?", msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                inserisciAvanzamento(evento)
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                log.info("Si è scelto di non inserire l'evento")
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onOpenComunicazioni(@BindingParam("priorita") Boolean priorita) {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/comunicazioni/comunicazioniPraticaLista.zul", self.parent, [id: pratica.id, priorita: priorita])
        self.setVisible(false)
        w.addEventListener(Events.ON_CLOSE, { event ->
            popolaAvanzamenti(pratica.id)
            refreshUi()
            self.setVisible(true)
        })
        w.doEmbedded()
    }

    @Command
    void onOpenAllegati() {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneAllegatiPratica.zul", self.parent, [id: pratica.id])
        self.setVisible(false)
        w.addEventListener(Events.ON_CLOSE, { event ->
            popolaAvanzamenti(pratica.id)
            refreshUi()
            self.setVisible(true)
        })
        w.doEmbedded()
    }



}
