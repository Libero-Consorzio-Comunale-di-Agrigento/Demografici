package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.StampaAttoService
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zhtml.Filedownload
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitInvioComunicazioneAnsc

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnnotazioniAttoListaViewModel extends RiferimentiAttoListaParentViewModel implements TraitInvioComunicazioneAnsc, TraitComune, TraitCancellazioneCampi {

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]
    ETipoSiNo selectedForzaIdAttoAnsc = ETipoSiNo.NO

    List<CivAnnotazioneAtto> lista = []
    CivAnnotazioneAtto _dettaglio

    List<EStatoAnnotazione> listaStatoAnnotazione

    List<ETipoAnnotazione> listaTipoAnnotazione

    Boolean showDeleteOption = Boolean.TRUE

    List<AnscInfoStepInvio> listaStepInvioAnsc = []
    Map<ETabComunicazioniAnsc, List<AnscInfoStepInvio>> tabListaStepInvioAnsc = [(ETabComunicazioniAnsc.Allegati)   : [],
                                                                                 (ETabComunicazioniAnsc.Obbligatori): [],
                                                                                 (ETabComunicazioniAnsc.Aggiuntivi) : []]
    SelectedTabComunicazioneAnsc selectedTab = new SelectedTabComunicazioneAnsc(new IPredicate<ETabComunicazioniAnsc>() {
        @Override
        boolean test(ETabComunicazioniAnsc tab) {
            switch (tab) {
                case ETabComunicazioniAnsc.Allegati: return tabListaStepInvioAnsc[ETabComunicazioniAnsc.Allegati].size() > 0
                case ETabComunicazioniAnsc.Obbligatori: return true
                case ETabComunicazioniAnsc.Aggiuntivi: return true
            }
        }
    })

    LinkedHashMap<String, AnscInfoArchivioRifIdRifs > mappaServiziArchiviIdRif = [:]

    List<EGenereAnnotazione> listaGenereAnnotazione = []

    LinkedHashMap<String, Long> mappaGenereCdu = [:]

    Boolean wPreviewModelloIstatOpen = Boolean.FALSE

    @Delegate
    ControlBarAnnotazioniAttributes cbAnnList = new ControlBarAnnotazioniAttributes()

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscComunicazioneService anscComunicazioneService

    @WireVariable
    private  AnscCasoUsoService anscCasoUsoService

    @WireVariable
    private StampaAttoService stampaAttoService

    @WireVariable
    private AnscUtenteService anscUtenteService

    @WireVariable
    private AnscAllegatoService anscAllegatoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
               @ExecutionArgParam("pkAnnotazione") Long pkAnnotazione){
        self = w

        backFromListAnnotazioneEnabled = true
        modifyAnnotazioneEnabled = false
        goToComunicazioniEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Data_Redazione_Atto_Originale"), Etichette.getEtichetta("Del"), Etichette.getEtichetta("Annotazione"), Etichette.getEtichetta("Modello_Personalizzato"),
                           Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("SEZIONE_ANNOTAZIONI_ATTO"), Etichette.getEtichetta("Annulla")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Ask_Formato_etichette"), Etichette.getEtichetta("Ask_Cancellazione_Annotazione"), Etichette.getEtichetta("Errore_modello_etichetta_non_trovato")])
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAnnotazioniAttributes.etichetteCbAnnListDesc)

        // Aggiungo etichette della comunicazioni ad ANSC
        eList.addAll(AnscComunicazione.etichetteDomain)

        // Aggiungo etichette delle Annotazioni
        eList.addAll(CivAnnotazioneAtto.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette sullo stato delle Annotazioni
        listaStatoAnnotazione = Arrays.asList(EStatoAnnotazione.values())
        eList.addAll(listaStatoAnnotazione*.etichettaDesc)

        // Aggiungo etichette sul tipo delle Annotazioni
        listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
        eList.addAll(listaTipoAnnotazione*.etichettaDesc)

        // Aggiungo etichette sul genere delle Annotazioni
        eList.addAll(Arrays.asList(EGenereAnnotazione.values())*.etichettaDesc)

        // Aggiungo etichette invio ANSC
        eList.addAll(etichetteIcomANSCDefault)

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())
        // Aggiungo etichette forzatura id atto ansc
        eList.addAll(Etichette.getEtichetta("Forza_Id_Atto_Ansc"), Etichette.getEtichetta("Reminder_Rettifica_Atto"))

        doInit(eList, pkAtto, tipoAttoEnum) //carica anche atto e dati provenienza

        msgTitle = getEtichetta(Etichette.getEtichetta("Annotazioni"))
        formLabel = getEtichetta(Etichette.getEtichetta("SEZIONE_ANNOTAZIONI_ATTO"))

        resize()

        if (anscOn) {
            for (EGenereAnnotazione ga : EGenereAnnotazione.values()) {
                if (ga) {
                    String ctg = SqlUtils.beginsAndEndsLike(ga.name())
                    List<AnscCasoUsoBaseDomain> lCdu = anscCasoUsoService.listAllByCategoriaLikeAndTipoAttoAnscAndFlagVisibileIsTrueAndDescrizioneLike(atto.getTipoAttoEnum(), ctg, ETipoAttoAnsc.Annotazione, "%")
                    if (lCdu?.size() == 1) {
                        mappaGenereCdu[ga.name()] = lCdu[0].id
                    }
                }
            }
        }

        caricaLista()
        selectedTab.initialize()

        if (pkAnnotazione && lista?.size() > 0){
            caricaAnnotazione(pkAnnotazione)
        }
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.dataRegistrazioneDesc) )
        Page<CivAnnotazioneAtto> p = civAnnotazioneAttoService.listAllByUkAttoAndTipoAttoAndTipoIn(atto.idAtto, atto.tipoAtto, listaTipoAnnotazione, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    CivAnnotazioneAtto getDettaglio(){
        return _dettaglio
    }

    void setDettaglio(CivAnnotazioneAtto annotazioneAtto){
        _dettaglio = annotazioneAtto

        caricaListaGenereAnnotazione(annotazioneAtto)
        caricaListaStepInvioAnsc(annotazioneAtto)

        refreshUi()
    }

    void resetDettaglio(){
        setDettaglio(null)
    }

    boolean getLoadOnCloseData(){
        return true
    }

    void caricaAnnotazione(Long id){
        if (id){
            for (CivAnnotazioneAtto ca : lista){
                if (ca.id.compareTo(id) == 0){
                    setDettaglio(ca)
                    break
                }
            }
        } else {
            resetDettaglio()
        }
    }

    private void stampaEtichetta(String formato) {
        onSalvaAnnotazione()

        stampaAttoService.downloadEtichetta(formato, getDettaglio(), atto)
    }

    @Command void onStampaEtichetta() {
        if (getDettaglio()?.id) {

            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.RETRY, Messagebox.Button.CANCEL]
            String[] buttonLabels = [TestoUtils.formatoA4, TestoUtils.formatoA3, getEtichetta(Etichette.getEtichetta("Modello_Personalizzato")), getEtichetta(Etichette.getEtichetta("Annulla"))]

            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Formato_etichette")), msgTitle, buttons, buttonLabels , Messagebox.QUESTION, null,
                new EventListener() {
                    void onEvent(Event e){
                        switch (e.getName()) {
                            case Messagebox.ON_YES:
                                stampaEtichetta(TestoUtils.formatoA4)
                                break
                            case Messagebox.ON_NO:
                                stampaEtichetta(TestoUtils.formatoA3)
                                break
                            case Messagebox.ON_RETRY:
                                stampaEtichetta(TestoUtils.formatoCustom)
                                break
                        }
                    }
                }
            )

        }
    }

    @Command void onSalvaAnnotazione() {
        if (getDettaglio()){
            getDettaglio().bloccato = Boolean.TRUE
            CivAnnotazioneAtto aSaved = civAnnotazioneAttoService.save(ETipoOperazione.UPD, getDettaglio(), atto)
            onPagina()
            caricaAnnotazione(aSaved?.id)
        }
    }

    @Command void onBloccaSbloccaTesto() {
        if (getDettaglio().flagFirmatoUscAnsc) {
            Messagebox.show("Testo bloccato: l'annotazione risulta firmata", msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            getDettaglio().bloccato = (!(getDettaglio().bloccato))
            refreshDettaglio()
        }
    }

    @Command void onEliminaAnnotazione(@BindingParam("annotazione") CivAnnotazioneAtto annotazione) {
        if ( (annotazione?.id != null) && showDeleteOption){
            Messagebox.show(annotazione.formulaDfa.descrizioneEstesa + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Annotazione")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new EventListener(){
                    void onEvent(Event e){
                        if (Messagebox.ON_OK.equals(e.getName())){
                            civAnnotazioneAttoService.delete(annotazione)
                            onRicarica()
                        }
                    }
                }
            )
        }
    }

    @Command void onInserisci() {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/annotazioniAttoSelect.zul", self, [atto: atto])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            onRicarica()
            if (event.data.idAnnotazione instanceof Long){
                Long idAnnotazione = event.data.idAnnotazione
                caricaAnnotazione(idAnnotazione)
            }
        })
        w.doModal()
    }

    @Command void onPreviewComunicazioni() {
        Events.postEvent(Events.ON_CLOSE, self, [goToComunicazioni:Boolean.TRUE])
    }

    @Command void onPreviewModelloIstat() {
        if (wPreviewModelloIstatOpen || (!(getDettaglio().flagIstat)) ){
            return
        }
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
            new EventListener(){
                void onEvent(Event e){
                    if (Messagebox.ON_YES.equals(e.getName())){
                        apriPreviewModelloIstat()
                    }
                }
            }
        )
    }

    void apriPreviewModelloIstat(){
        String uriModelloIstat = "/restrict/statocivile/annotazioneSDSUDettaglio.zul"
        if (getDettaglio() && (!(wPreviewModelloIstatOpen)) ) {
            try{
                wPreviewModelloIstatOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents(uriModelloIstat, self.parent, [pkAnnotazione: getDettaglio().id, pkAtto: getAtto().id, tipoAttoEnum: getAtto().getTipoAttoEnum()])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    getDettaglio().bloccato = Boolean.TRUE
                    Long idAnnotazione = getDettaglio().id
                    onPagina()
                    caricaAnnotazione(idAnnotazione)
                    self.setVisible(true)
                    wPreviewModelloIstatOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura modello istat", ex)
                wPreviewModelloIstatOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    void caricaListaGenereAnnotazione(CivAnnotazioneAtto annotazioneAtto){
        listaGenereAnnotazione = [null] + [EGenereAnnotazione.RET, EGenereAnnotazione.EMA, EGenereAnnotazione.COM, EGenereAnnotazione.AMM]
        if (annotazioneAtto?.flagIstat){
            //listaGenereAnnotazione = [null] + [EGenereAnnotazione.COM, EGenereAnnotazione.AMM]
            null
            //gestire opzioni in base al flag
        }
        switch (atto.getTipoAttoEnum()) {
            case ETipoAtto.NAS:
                listaGenereAnnotazione.addAll([EGenereAnnotazione.AMD, EGenereAnnotazione.AMS, EGenereAnnotazione.AMA])
                break
            case ETipoAtto.MAT:
                if (isAttoDivorzioScioglimento(atto)){
                    // solo rettifica o errore materiale
                    listaGenereAnnotazione = [null] + [EGenereAnnotazione.RET, EGenereAnnotazione.EMA]
                } else {
                    listaGenereAnnotazione.addAll([EGenereAnnotazione.AMD, EGenereAnnotazione.AMX, EGenereAnnotazione.AMA])
                }
                break
            case ETipoAtto.UCI:
                if (isAttoDivorzioScioglimento(atto)){
                    // solo rettifica o errore materiale
                    listaGenereAnnotazione = [null] + [EGenereAnnotazione.RET, EGenereAnnotazione.EMA]
                } else {
                    listaGenereAnnotazione.addAll([EGenereAnnotazione.AMS, EGenereAnnotazione.AMA])
                }
                break
        }
        BindUtils.postNotifyChange(null, null, this, "listaGenereAnnotazione")
    }

    @Command void onSelectGenereAnnotazione() {
        if ( (getDettaglio() != null) && getDettaglio()?.isModificativa() ) {
            getDettaglio().stampaSuEstratto = Boolean.FALSE
        }
        setDettaglio(getDettaglio())
    }

    Boolean getCasiUsoEnabled(){
        if (getDettaglio()){
            return TestoUtils.isVuoto(getDettaglio().getIdAttoAnsc())
        }
        return Boolean.FALSE
    }

    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRif){
        AnscEndPointServizio servizio = servizioCdu?.servizio
        if (servizio && anscComunicazioneService.isUltimaComunicazioneByArchivioRifAndServizioAndIdRifNonInviataCausaHttpError(archivioRif, servizio, idRif)) {
            return Boolean.TRUE
        }
        if (servizio && (!(servizio.flagRipetizione))){
            return anscComunicazioneService.esisteComunicazioneByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        if (servizio && (servizio.flagRipetizione)){
            return anscComunicazioneService.esisteComunicazioneNonInviataByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        return Boolean.TRUE
    }

    void caricaListaStepInvioAnsc(CivAnnotazioneAtto annotazioneAtto){
        listaStepInvioAnsc = []
        Long idAnnotazione = annotazioneAtto?.id
        Long idCdu = null
        if (annotazioneAtto?.genere){
            idCdu = mappaGenereCdu.get(annotazioneAtto.genere.name())
        }
        if (anscOn && idAnnotazione && idCdu) {
            ETipoArchivioAnsc taComAnnotazione = ETipoArchivioAnsc.ANN
            List<AnscEndPointServizioArchivio> listaServiziCdu = anscEndPointServizioArchivioService.listAllServiziAnnotazioneByArchivioAndCasoUsoAndFlagVisibileIsTrueOrderBySequenza(taComAnnotazione, idCdu, null)
            int sequenza = 0
            for (AnscEndPointServizioArchivio servizioCdu : listaServiziCdu) {
                AnscEndPointServizio se = servizioCdu.servizio
                if (se.flagAllegati) {
                    log.info("not implemented - not necessary")
                } else {
                    // Comunicazioni inviate ad ANSC associate al servizio
                    List<IAnscComunicazione> listaComServizioAtto = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(taComAnnotazione, se, idAnnotazione) ?: [])
                    List<AnscInfoServizioCdu> listaOggettiInvio = [new AnscInfoServizioCdu(servizioCdu, taComAnnotazione, idAnnotazione, listaComServizioAtto)]
                    listaStepInvioAnsc.add(new AnscInfoStepInvio(AnscInfoStepInvio.TIPO_BASE, (se.flagObbligatorio ? ++sequenza : 1), servizioCdu, listaOggettiInvio))
                    AnscInfoArchivioRifIdRifs m = new AnscInfoArchivioRifIdRifs(taComAnnotazione, [idAnnotazione])
                    mappaServiziArchiviIdRif[se.id] = m
                    if(se.flagAlertAttoRettificato && anscOn && atto.isAttoAnsc() && atto.idAttoAnsc != null) {
                        Messagebox.show(getEtichetta(Etichette.getEtichetta("Reminder_Rettifica_Atto")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    }
                }
            }
        }
        updateTabListaStepInvioAnsc()
    }

    private void updateTabListaStepInvioAnsc() {
        tabListaStepInvioAnsc[ETabComunicazioniAnsc.Allegati].clear()
        tabListaStepInvioAnsc[ETabComunicazioniAnsc.Obbligatori].clear()
        tabListaStepInvioAnsc[ETabComunicazioniAnsc.Aggiuntivi].clear()
        listaStepInvioAnsc.each {
            AnscInfoStepInvio step = (AnscInfoStepInvio) it
            switch (step.servizioCdu.servizio.tabComunicazione) {
                case ETabComunicazioniAnsc.Allegati:
                    tabListaStepInvioAnsc[ETabComunicazioniAnsc.Allegati] << step
                    break
                case ETabComunicazioniAnsc.Obbligatori:
                    tabListaStepInvioAnsc[ETabComunicazioniAnsc.Obbligatori] << step
                    break
                case ETabComunicazioniAnsc.Aggiuntivi:
                    tabListaStepInvioAnsc[ETabComunicazioniAnsc.Aggiuntivi] << step
                    break
            }
        }
    }

    List<AnscInfoStepInvio> getProperLista(String tabComunicazione) {
        return tabListaStepInvioAnsc[ETabComunicazioniAnsc.valueOf(tabComunicazione)]
    }

    void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, AnscCredenziali cre,
                            Long idRif, Long idComunicazione, IRicercaAnsc r, IAnscPaginazione paginazione, Boolean skip){
        onSalvaAnnotazione()
        AnscEndPointServizio servizio = servizioCdu?.servizio
        AnscEndPointServizio servizioPrec = servizioCdu?.servizioPrecedente
        ETipoArchivioAnsc taRifComPrec = null
        List<Long> idRifPrecs = null
        if (servizioPrec != null) {
            AnscInfoArchivioRifIdRifs m = mappaServiziArchiviIdRif.get(servizioPrec.id)
            taRifComPrec = m.getTipoArchivioRif()
            idRifPrecs = m.getIdRifs()
        }
        Long idCasoUso = servizioCdu?.idCasoUso
        if (taRifCom && servizio && idRif && cre) {
            AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneAnnotazione(taRifComPrec, servizioPrec, idRifPrecs, ETipoArchivioAnsc.ANN, servizio, idRif, idCasoUso, null, atto, idComunicazione, cre, skip)
            if ((com.getRetVal() ?: "") != "") {
                Messagebox.show(servizio.descrizioneEstesa + " :\n" + com.getRetVal(), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else if (servizio.flagDownloadAllegato) {
                onDownloadAllegatoAnsc(com.getIdComunicazione(), servizio)
            }
            onPagina()
            caricaAnnotazione(idRif)
            Events.sendEvent(CustomEvents.ON_REFRESH_DETAILS, self, null)
        }
    }

    void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu,
                                                     Long idRif, Long idComunicazione, IRicercaAnsc r, IAnscPaginazione paginazione) {
        AnscEndPointServizio servizioPrec = servizioCdu?.servizioPrecedente
        ETipoArchivioAnsc taRifComPrec = null
        List<Long> idRifPrecs = null
        if (servizioPrec != null) {
            AnscInfoArchivioRifIdRifs m = mappaServiziArchiviIdRif.get(servizioPrec.id)
            taRifComPrec = m.getTipoArchivioRif()
            idRifPrecs = m.getIdRifs()
        }
        Long idCasoUso = servizioCdu?.idCasoUso
        String msg = anscComunicazioneService.verificaSequenzaServizi(taRifComPrec, servizioPrec, idRifPrecs, servizioCdu?.servizio, idCasoUso, null, null)
        if (msg){
            Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
            recuperaCredenzialiEInviaComunicazione(ansUte, taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione)
        }
    }

    @Command void onOpenStoricoComunicazioni(@BindingParam("oggettoInvio") IAnscOggettoInvio oggettoInvio) {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/anscComunicazioniOggettoLista.zul", self, [oggettoInvio: oggettoInvio])
        w.addEventListener(CustomEvents.ON_SKIP_CHECK, { event ->
            AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
            recuperaCredenzialiEInviaComunicazione(ansUte, oggettoInvio.tipoArchivioComunicazione, oggettoInvio.servizioCdu, oggettoInvio.idDomain, null, null, null, Boolean.TRUE)
        })
        w.addEventListener(CustomEvents.ON_SKIP_HTTP_ERROR, { event ->
            AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
            recuperaCredenzialiEInviaComunicazione(ansUte, oggettoInvio.tipoArchivioComunicazione, oggettoInvio.servizioCdu, oggettoInvio.idDomain, null, null, null, Boolean.TRUE)
        })
        w.doModal()
    }

    @Command void onDownloadAllegatoAnsc(@BindingParam("idAllegatoAnsc") Long idAllegatoAnsc, @BindingParam("servizio") AnscEndPointServizio servizio) {
        if (servizio.flagDownloadAllegato) {
            AnscAllegato anscAllegato = anscAllegatoService.get(idAllegatoAnsc)
            if (anscAllegato) {
                Filedownload.save(anscAllegato.blobAllegato, null, anscAllegato.nomeFile)
            } else {
                Messagebox.show("Errore in recupero file allegato", msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        if (tca == ETipoComuneAtto.CP_ANN) {
            riempiComune(dettaglio.comuneProvenienza, c)
        }
    }

    @Command void onCancellaCampoAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(this, p)
    }

    @Command
    void onForzaIdAttoAnsc() {
        if (selectedForzaIdAttoAnsc == ETipoSiNo.SI) {
            String uri = "/restrict/statocivile/popupCollegaIdAnsc.zul"
            Window w = (Window) Executions.createComponents(uri, self.parent, [entitaAnsc: dettaglio])
            w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
                caricaAnnotazione(_dettaglio.id)
                refreshUi()
            })
            w.addEventListener(Events.ON_CLOSE, { e ->
                selectedForzaIdAttoAnsc = ETipoSiNo.NO
                refreshUi()
            })
            w.doModal()
        }
    }

    boolean getCanSaveRecord() {
        return true
    }
}