package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import org.springframework.dao.EmptyResultDataAccessException
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
import restrict.AbstractDettaglioViewModel
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RegistrazioneAnnotazioniDettaglioViewModel extends AbstractDettaglioViewModel{

    List<Integer> listaUffici = []

    CivAnnotazioneAtto dettaglio

    List<ETipoAnnotazione> listaTipoAnnotazione
    final List<EStatoAnnotazione> listaStatoAnnotazione = Arrays.asList(EStatoAnnotazione.values())

    ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue

    CivSoggettoAnnotazione soggettoAnnotazione
    CivAttoBaseDomain atto

    String nominativoAtto

    @Delegate
    ControlBarAnnotazioniAttributes cbAnnList = new ControlBarAnnotazioniAttributes()

    String labelAttoAltroComune

    Boolean wPreviewComunicazioniOpen = Boolean.FALSE

    ETipoOperazione tipoOperazione

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private CivAttoService civAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("soggettoAnnotazione") CivSoggettoAnnotazione soggettoAnnotazione) {
        self = w

        //deleteAnnotazioneEnabled = true
        if (soggettoAnnotazione){
            deleteAnnotazioneEnabled = (soggettoAnnotazione.tipoComune == 0)
        }
        saveRecordAnnotazioneEnabled = true
        backFromRecordAnnotazioneEnabled = true
        goToComunicazioniEnabled = true
        addAnnotazioneEnabled = false
        modifyAnnotazioneEnabled = false

        List<Map> eList = [Etichette.Annotazioni, Etichette.Generata_da, Etichette.Generata_su, Etichette.Cognome_Nome,
                           Etichette.Atto_non_in_Archivio, Etichette.Effettua_Ricerca,Etichette.Atto_altro_comune,
                           Etichette.SEZIONE_ANNOTAZIONE_ATTO, Etichette.SEZIONE_ANNOTAZIONI_ATTO, Etichette.SEZIONE_ESTREMI_ATTO]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Ask_Inserimento_Annotazione_Su_Atto, EtichetteMessaggi.Ask_Cancellazione_Annotazione,
                      EtichetteMessaggi.Errore_Operazione_non_consentita, EtichetteMessaggi.Errore_apertura_record])
        eList.addAll(AbstractListaViewModel.etichetteListaDefault)
        eList.addAll(etichetteDettaglioDefault)
        // Aggiungo etichette delle Annotazioni
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)
        eList.addAll(CivAnnotazioneAtto.etichetteDomain)

        // Aggiungo etichette sul tipo delle Annotazioni
        listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
        eList.addAll(listaTipoAnnotazione*.etichettaDesc)

        // Aggiungo etichette sullo stato delle Annotazioni
        eList.addAll(listaStatoAnnotazione*.etichettaDesc)

        // Aggiungo etichette tipo annotazione
        List<ETipoOrdinamentoAnnotazione> listaTipoOrdinamento = Arrays.asList(ETipoOrdinamentoAnnotazione.values())
        eList.addAll(listaTipoOrdinamento*.etichettaDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAnnotazioniAttributes.etichetteCbAnnListDesc)

        eList.addAll(CivSoggettoAnnotazione.etichetteDomain)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        listaUffici = statoCivileService.listUffici()

        msgTitle = getEtichetta(Etichette.Annotazioni)

        this.soggettoAnnotazione = soggettoAnnotazione

        tipoOrdinamentoDefaultValue = ETipoOrdinamentoAnnotazione.Nuovo_Ordinamento

        formLabel = getEtichetta(Etichette.SEZIONE_ANNOTAZIONI_ATTO)

        labelAttoAltroComune = String.format(getEtichetta(Etichette.Atto_altro_comune), getEtichettaEnum(soggettoAnnotazione.getTipoAttoAnnotazioneEnum()))

        if (soggettoAnnotazione.id != null){
            caricaDettaglio(soggettoAnnotazione.annotazioneDomainId)
        } else {
            creaDettaglio([stato: EStatoAnnotazione.E])
        }
    }

    void caricaDettaglio(def id){
        if (id != null){
            dettaglio = civAnnotazioneAttoService.get(id)
            try {
                tipoOperazione = ETipoOperazione.UPD
                atto = civAttoService.getAttoFromAnnotazione(dettaglio.getTipoAtto(), dettaglio.ufficio, dettaglio.anno, dettaglio.atto, dettaglio.parte, dettaglio.serie)
                nominativoAtto = atto.getNominativoEstremiAtto(dettaglio.tipoFormula, dettaglio.tipoAttoAnnotazione)
            } catch (EmptyResultDataAccessException e){
                log.error(e.getMessage())
                Messagebox.show(getEtichetta(Etichette.Atto_non_in_Archivio), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        } else {
            onChiudi()
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        Boolean stampaSuAtto = arcParametroService.iStampaAnnotazioneSuAttoAttiva()
        Boolean stampaSuEstratto = arcParametroService.iStampaAnnotazioneSuEstrattoAttiva()
        dettaglio = civAnnotazioneAttoService.create(params.stato, stampaSuAtto, stampaSuEstratto)
        atto = civAttoService.create(soggettoAnnotazione.getTipoAttoRifEnum())
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onSelectFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivFormulaAnnotazione) {
            CivFormulaAnnotazione formulaSelezionata = (CivFormulaAnnotazione) event.getData()

            dettaglio.formulaDfa = formulaSelezionata
            dettaglio.sequenza = (civAnnotazioneAttoService.getMaxSequenzaByUkAtto(atto.idAtto)?:new Integer(1))
            dettaglio.testo = civFormulaAnnotazioneService.getTestoAnnotazioneDecodificato(dettaglio.formulaDfa.id, atto, (soggettoAnnotazione.tipoComune == 0))
        } else {
            dettaglio.formulaDfa = null
            dettaglio.testo = ""
        }
        refreshUi()
    }

    @Command void onCancellaFormulaAnnotazione() {
        onSelectFormulaAnnotazione(null)
    }

    @Command void onSalvaRecord() {
        if (dettaglio){

            Boolean found = Boolean.FALSE
            if ( tipoOperazione.isInsert() && (atto.id == null) && (soggettoAnnotazione.tipoComune == 1)) {
                try{
                    found = civAttoService.existsByUkAtto(atto)
                } catch (EmptyResultDataAccessException e){
                    found = Boolean.FALSE
                }
            }

            if (found){
                Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Inserimento_Annotazione_Su_Atto), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new EventListener(){
                            void onEvent(Event e){
                                if (Messagebox.ON_YES.equals(e.getName())){
                                    salvaAnnotazione()
                                }
                            }
                        }
                )
            } else {
                salvaAnnotazione()
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private salvaAnnotazione(){
        if (dettaglio){
            dettaglio.formula = dettaglio.formulaDfa?.id
            DomainUtils.initFromAtto(dettaglio, atto)
            if (soggettoAnnotazione.tipoComune == 0){
                if (soggettoAnnotazione.getTipoAttoAnnotazioneEnum() == ETipoAtto.NAS){
                    DomainUtils.cambiaTipoAttoAnnotazioneSuAttoNascita(dettaglio, atto)
                    DomainUtils.cambiaFormulaAnnotazione(dettaglio, dettaglio.formulaDfa?.id, soggettoAnnotazione.tipoFormula)
                } else {
                    DomainUtils.cambiaTipoAttoAnnotazioneSuAttoMatrimonio(dettaglio, atto)
                }
            }
            CivAnnotazioneAtto aa = civAnnotazioneAttoService.save(tipoOperazione, dettaglio, atto)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(aa.id)
        }
    }

    @Command void onPreviewComunicazioni(){
        if (atto.id != null) {
            if (!(wPreviewComunicazioniOpen)){
                Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Modifiche_In_Sospeso), getEtichetta(Etichette.comunicazioni_tooltip), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new EventListener(){
                            void onEvent(Event e){
                                if (Messagebox.ON_YES.equals(e.getName())){
                                    apriPreviewComunicazioni()
                                }
                            }
                        }
                )
            }
        }
    }

    void apriPreviewComunicazioni(){
        if (atto.id != null) {
            if (!(wPreviewComunicazioniOpen)) {
                try {
                    wPreviewComunicazioniOpen = Boolean.TRUE
                    Window w = (Window) Executions.createComponents("/restrict/statocivile/comunicazioniAttoLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum()])
                    self.setVisible(false)
                    w.addEventListener(Events.ON_CLOSE, { event ->
                        caricaDettaglio(dettaglio.id)
                        self.setVisible(true)
                        wPreviewComunicazioniOpen = Boolean.FALSE
                    })
                    w.doEmbedded()
                } catch (Exception ex) {
                    log.error(ex.getMessage())
                    wPreviewComunicazioniOpen = Boolean.FALSE
                    throw ex
                }
            }
        }
    }

    @Command void onSelectUfficio(){
        if (tipoOperazione.isUpdate()){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_Operazione_non_consentita), msgTitle, Messagebox.OK, Messagebox.ERROR)
            onChiudi()
        }
    }

    @Command void onSelectAnno(){
        if (tipoOperazione.isUpdate()){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_Operazione_non_consentita), msgTitle, Messagebox.OK, Messagebox.ERROR)
            onChiudi()
        }
    }

    @Command void onCheckAtto(){
        nominativoAtto = ""
        try {
            nominativoAtto = civAttoService.getAttoFromAnnotazione(soggettoAnnotazione.tipoAttoRif, atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie)?.getNominativoEstremiAtto(soggettoAnnotazione.tipoFormula, soggettoAnnotazione.tipoAttoAnnotazione)
        } catch (Exception e){
            log.error(e.getMessage())
            Messagebox.show(getEtichetta(Etichette.Atto_non_in_Archivio), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        refreshUi()
    }

    @Command void onEliminaRecord() {
        if (dettaglio) {
            Messagebox.show(dettaglio.formulaDfa.descrizioneEstesa + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Annotazione), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaAnnotazione(dettaglio)
                            }
                        }
                    }
            )
        }
    }

    void eliminaAnnotazione(CivAnnotazioneAtto annotazione){
        if (deleteAnnotazioneEnabled) {
            civAnnotazioneAttoService.delete(annotazione)
            onChiudi()
        }
    }
}
