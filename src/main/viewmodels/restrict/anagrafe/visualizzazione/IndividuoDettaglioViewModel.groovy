package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.LogGsd
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.LogsService
import it.finmatica.de4gsdzk.statocivile.embed.DocumentoIdentita
import it.finmatica.de4gsdzk.statocivile.embed.DocumentoSoggiorno
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoComuneAtto
import it.finmatica.de4gsdzk.utils.ETipoLog
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitControlBarCapable
import restrict.statocivile.DizionarioDettaglioViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class IndividuoDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi, TraitComune, TraitControlBarCapable, TraitIndividuoCorrente {

    AnaAnagrafe dettaglio
    AnpAnagrafe anpDettaglio

    List<AnaMessaggio> messaggioList = []

    boolean convivenzaButtonEnabled = true
    boolean famigliaAdsButtonEnabled = true
    boolean famigliaAnprButtonEnabled = true
    boolean documentiButtonEnabled = true
    boolean statoCivileButtonEnabled = true
    boolean storicoAnagrafeButtonEnabled = true
    boolean variazioniButtonEnabled = true
    boolean provvedimentiButtonEnabled = true

    Boolean anscOn = Boolean.FALSE

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private AnpAnagrafeService anpAnagrafeService

    @WireVariable
    private AnaMessaggioService anaMessaggioService

    @WireVariable
    private AnaEventoStatoCivileService anaEventoStatoCivileService

    @WireVariable
    private AnaEventoAnagrafeService anaEventoAnagrafeService

    @WireVariable
    private AnaDocumentoService anaDocumentoService

    @WireVariable
    private AnaVariazioneAnagrafeService anaVariazioneAnagrafeService

    @WireVariable
    private AnaProvvedimentoAnagrafeService anaProvvedimentoAnagrafeService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private LogsService logsService

    Date dataRiferimento

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("soggetto") AnaAnagrafeBaseDomain soggetto) {
        self = w

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.addEnabled = false
        controlBarAttributes.modifyEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("INDIVIDUO")]
        // Aggiungo etichette controlbar
        eList.addAll([Etichette.getEtichetta("Storico_Stato_Civile_tooltip"), Etichette.getEtichetta("Storico_anagrafe_tooltip"),
                      Etichette.getEtichetta("Famiglia_tooltip"), Etichette.getEtichetta("Famiglia_Anpr_tooltip"),
                      Etichette.getEtichetta("Convivenza_di_fatto_tooltip"), Etichette.getEtichetta("Storico_tooltip"),
                      Etichette.getEtichetta("Variazioni_tooltip"), Etichette.getEtichetta("Documenti_tooltip"),
                      Etichette.getEtichetta("allegati_tooltip"), Etichette.getEtichetta("Provvedimenti_tooltip"),
                      Etichette.getEtichetta("Altri_Dati_ANPR_tooltip"), Etichette.getEtichetta("Dati_Elettore_ANPR_tooltip")])
        // Aggiungo etichette per sezioni
        eList.addAll([Etichette.getEtichetta("Anagrafe"), Etichette.getEtichetta("ANPR"), Etichette.getEtichetta("Matricola_Non_Trovata"),
                      Etichette.getEtichetta("Individuo")])
        // Aggiungo etichette entita
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnpAnagrafe.etichetteDomain)
        eList.addAll(DocumentoIdentita.etichetteDomain)
        eList.addAll(DocumentoSoggiorno.etichetteDomain)
        eList.addAll(IndirizzoResidenteFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteEsteroFamiglia.etichetteDomain)
        eList.addAll(IndirizzoNonResidenteFamiglia.etichetteDomain)
        // Aggiungo etichette fascia
        eList.addAll(EFascia.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("Per")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("INDIVIDUO"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        if (soggetto) {
            caricaDettaglio(soggetto)
        } else {
            creaDettaglio([:])
        }

    }

    private void calcolaBottoni() {
        convivenzaButtonEnabled = dettaglio.convivenzaDiFatto != null
        famigliaAdsButtonEnabled = dettaglio.famiglia != null
        famigliaAnprButtonEnabled = anpDettaglio?.idFamigliaAnpr != null
        documentiButtonEnabled = anaDocumentoService.existsRecentiByAnagrafe(dettaglio) || anaDocumentoService.existsStoriciByAnagrafe(dettaglio)
        statoCivileButtonEnabled = anaEventoStatoCivileService.existsByAnagrafe(dettaglio)
        storicoAnagrafeButtonEnabled = anaEventoAnagrafeService.existsByAnagrafe(dettaglio)
        variazioniButtonEnabled = anaVariazioneAnagrafeService.existsByAnagrafe(dettaglio)
        provvedimentiButtonEnabled = anaProvvedimentoAnagrafeService.existsByAnagrafe(dettaglio)
    }

    void caricaDettaglio(def soggetto) {
        if (soggetto == null) {
            throw new IllegalArgumentException("id non specificato")
        }
        dataRiferimento = null

        try {
            anpDettaglio = anpAnagrafeService.findBySoggetto(soggetto as AnagrafeBaseDomain, true)

            logsService.save(ETipoLog.Gsd, LogGsd.createLogGsdVisualizzazioneIndividuoAnp(anpDettaglio))
        } catch (Exception e) {
            log.error(e.getMessage(), e)
            anpDettaglio = null
        }
        setAnprIndividuoCorrente(anpDettaglio)

        dettaglio = anaAnagrafeService.get((soggetto as AnagrafeBaseDomain).matricola ?: anpDettaglio.matricola, [fetch: [
                [campo: 'nazionalita', tipo: JoinType.LEFT],
                [campo: 'stato', tipo: JoinType.LEFT],
                [campo: 'famiglia', tipo: JoinType.LEFT],
                //[campo: 'coabitante', tipo: JoinType.LEFT],
                [campo: 'coabitante.capoFamiglia', tipo: JoinType.LEFT],
                [campo: 'padre', tipo: JoinType.LEFT],
                [campo: 'madre', tipo: JoinType.LEFT],
                //[campo: 'coniuge.anagrafe', tipo: JoinType.LEFT],
                [campo: 'coniuge.anagrafe.nazionalita', tipo: JoinType.LEFT],
                [campo: 'convivenzaDiFatto', tipo: JoinType.LEFT],]])

        logsService.save(ETipoLog.Gsd, LogGsd.createLogGsdVisualizzazioneIndividuoAna(dettaglio))

        setIndividuoCorrente(dettaglio)

        messaggioList = anaMessaggioService.listAllForAnagrafeByAnagrafe(dettaglio)
        if (!messaggioList.isEmpty()) {
            openMessaggiIndividuo()
        }

        calcolaBottoni()
        refreshUi()
    }

    void creaDettaglio(Map params) {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Matricola_Non_Trovata")), msgTitle, Messagebox.OK, Messagebox.ERROR)
        throw new IllegalStateException("Non implementato")
    }

    @Command
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_RECORD, self, [:])
        onChiudi()
    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        throw new IllegalStateException("Non implementato")
    }

    @Command
    void onOpenIndividuo(@BindingParam("soggetto") AnagrafeBaseDomain soggetto, @BindingParam("id") Integer id) {
        if(id) {
            soggetto = anaAnagrafeService.get(id)
        }
        caricaDettaglio(soggetto)
    }

    @Command
    void onOpenDocumenti() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/documentoIndividuoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form documenti individuo", ex)
            throw ex
        }
    }

    @Command
    void onOpenFamiglia(@BindingParam("tipo") String tipo) {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/famigliaLista.zul", self.parent, [dataRiferimento : tipo == 'A' ? dataRiferimento : null])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data.soggetto instanceof AnagrafeBaseDomain) {
                    caricaDettaglio(event.data.soggetto as AnagrafeBaseDomain)
                }
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia", ex)
            throw ex
        }
    }

    @Command
    void onOpenConvivenzaDiFatto() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/convivenzaDiFattoDettaglio.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data.soggetto instanceof AnagrafeBaseDomain) {
                    caricaDettaglio(event.data.soggetto as AnagrafeBaseDomain)
                }
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form famiglia", ex)
            throw ex
        }
    }

    @Command
    void onOpenAllegati() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/individuoAllegatiLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form individuo allegati", ex)
            throw ex
        }
    }

    @Command
    void onOpenStatoCivile() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/statoCivileStoricoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data.soggetto instanceof AnagrafeBaseDomain) {
                    caricaDettaglio(event.data.soggetto as AnagrafeBaseDomain)
                }
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form storico stato civile", ex)
            throw ex
        }
    }

    @Command
    void onOpenAnagrafeStorico() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/anagrafeStoricoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data.soggetto instanceof AnagrafeBaseDomain) {
                    caricaDettaglio(event.data.soggetto as AnagrafeBaseDomain)
                }
            })
            w.doEmbedded()
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form storico anagrafe", ex)
            throw ex
        }
    }

    @Command
    void onOpenVariazioni() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/variazioneLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form variazioni anagrafe", ex)
            throw ex
        }
    }

    @Command
    void onOpenProvvedimenti() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/provvedimentoLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form provvedimenti anagrafe", ex)
            throw ex
        }
    }


    private openMessaggiIndividuo() {
        Window popupScansione = (Window) Executions.createComponents('/restrict/afc/popupAvvisi.zul', self, [listaMessaggi: messaggioList])
        popupScansione.doModal()
    }

    String getUltimoEventoDesc() {
        String result = "${getEtichettaEnum(dettaglio.fascia)} per ${dettaglio.stato.descrizione}"
        if(dettaglio.dataUltimoEvento != null) {
            result += " in data ${dettaglio.dataUltimoEvento.format('dd/MM/yyyy')}"
        }
        return result
    }

    @Command
    void onOpenAltriDatiAnpr() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/altriDatiAnprLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data.anpSoggetto instanceof AnpAnagrafe) {
                    anpDettaglio = event.data.anpSoggetto
                    dataRiferimento = event.data.dataRiferimento
                    setAnprIndividuoCorrente(anpDettaglio)
                    refreshUi()
                }

            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form Altri dati ANPR", ex)
            throw ex
        }
    }

    @Command
    void onOpenDatiElettoreAnpr() {
        try {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/visualizzazione/datiElettoreAnprLista.zul", self.parent, [:])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                self.setVisible(true)
            })
            w.doEmbedded()
        } catch (Exception ex) {
            log.error("Errore apertura form provvedimenti Dati Elettore ANPR", ex)
            throw ex
        }
    }
}
