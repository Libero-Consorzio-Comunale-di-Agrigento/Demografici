package restrict.statocivile.notifiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitInvioComunicazioneAnsc

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class NotificaListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitInvioComunicazioneAnsc {

    List<AnscInfoNotifica> lista
    AnscInfoNotifica _dettaglio

    final List<ETipoEventoAnsc> listaTipiEventoAnsc = Arrays.asList(ETipoEventoAnsc.values()) + [null]
    final List<EStatoFlussoNotifica> listaStatoNotifiche = Arrays.asList(EStatoFlussoNotifica.values()) + [null]
    final List<EGenereNotifica> listaGenereNotifiche = Arrays.asList(EGenereNotifica.values()) + [null]
    final List<ETipoContenutoAnsc> listaTipoContenuto = Arrays.asList(ETipoContenutoAnsc.values()) + [null]

    AnscEndPointServizioArchivio servizioRicercaNotifiche
    AnscEndPointServizioArchivio servizioConsultazioneSoggetto
    AnscEndPointServizioArchivio servizioConsultazioneEvento
    AnscEndPointServizioArchivio servizioConfermaNotifica
    AnscEndPointServizioArchivio servizioRifiutoNotifica

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    RicercaNotifica ricercaNotifica

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscComunicazioneService anscComunicazioneService

    @WireVariable
    private AnscNotificaService anscNotificaService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnscUtenteService anscUtenteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        modifyEnabled = false
        addEnabled = false

        ricercaNotifica = new RicercaNotifica(DataUtils.addDays((new Date()).clearTime(), -1), (new Date()).clearTime())

        List<Map> eList = [Etichette.getEtichetta("Gestione_Notifiche"), Etichette.getEtichetta("Tipo_Atto"),
                           Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Data_decrescente"), Etichette.getEtichetta("Data_crescente")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Ask_conferma_notifica_ANSC"),
                      Etichette.getEtichetta("Errore_ANSC_servizio_notifica"), Etichette.getEtichetta("Errore_ANSC_abilitazione_utente")])

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette notifiche
        eList.addAll(AnscNotifica.etichetteDomain)

        // Aggiungo etichette ricerca
        eList.addAll(RicercaNotifica.etichetteRicercaNotDesc)

        // Aggiungo etichette tipo evento
        eList.addAll(Arrays.asList(ETipoEventoAnsc.values())*.getEtichettaPluralDesc())

        // Aggiungo etichette tipologia ansc
        eList.addAll(ETipologiaAnsc.values()*.etichettaDesc)

        // Aggiungo etichette sullo stato delle notifiche
        eList.addAll(Arrays.asList(EStatoFlussoNotifica.values())*.etichettaDesc)

        // Aggiungo etichette sul genere delle notifiche
        eList.addAll(Arrays.asList(EGenereNotifica.values())*.etichettaDesc)

        // Aggiungo etichette sul tipo di contenuto delle notifiche
        eList.addAll(Arrays.asList(ETipoContenutoAnsc.values())*.etichettaDesc)

        // Aggiungo etichette ordinamento non applicabile
        eList.addAll(Etichette.getEtichetta("Ordinamento_non_applicabile"))

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Notifiche"))

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_crescente")),    SortUtils.validoDalIdAsc ))

        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        servizioRicercaNotifiche = anscEndPointServizioArchivioService.getServizioArchivioNotificaRicerca()
        servizioConsultazioneSoggetto = anscEndPointServizioArchivioService.getServizioArchivioNotificaConsultazioneSoggetto()
        servizioConsultazioneEvento = anscEndPointServizioArchivioService.getServizioArchivioNotificaConsultazioneEvento()
        servizioConfermaNotifica = anscEndPointServizioArchivioService.getServizioArchivioNotificaConferma()
        servizioRifiutoNotifica = anscEndPointServizioArchivioService.getServizioArchivioNotificaRifiuto()

        resize()
    }

    void caricaLista() {
        ricercaNotifiche(null)
    }

    private caricaListaDaQuery() {
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        List<AnscInfoNotifica> l = []
        Page<AnscNotifica> p = eseguiQueryNotifiche(usePaging)
        for (AnscNotifica n : p) {
            AnscInfoSoggetto infoSoggetto = new AnscInfoSoggetto(String.valueOf(n.getIdSoggettoAnsc()), n.nomeSoggettoAnsc, n.cognomeSoggettoAnsc)
            AnscInfoNotifica infoNotifica = new AnscInfoNotifica(n.id, n.idAnsc, n.descrizione, infoSoggetto, n.stato, n.genere, n.validoDal, n.descrizioneComuneFormazione)
            l.add(infoNotifica)
        }
        return new Paginazione(l, p?.getTotalElements()?:0)
    }

    Page<AnscNotifica> eseguiQueryNotifiche(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder.campi))
        Page<AnscNotifica> p = anscNotificaService.listAllByRicerca(ricercaNotifica, pr)
        return p
    }

    AnscInfoNotifica getDettaglio(){
        return _dettaglio
    }

    void setDettaglio(AnscInfoNotifica infoNotifica){
        _dettaglio = infoNotifica
        refreshDettaglio()
    }

    void resetDettaglio(){
        setDettaglio(null)
    }

    @Command void onSelectTipoEventoAnsc() {
        resetRicerca()
    }

    @Command void onSelectStatoNotifica() {
        resetRicerca()
    }

    @Command void onSelectGenereNotifica() {
        resetRicerca()
    }

    @Command void onSelectTipoContenuto() {
        resetRicerca()
    }

    @Command void onChangeDal() {
        resetRicerca()
    }

    @Command void onChangeAl() {
        resetRicerca()
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaNotifica, p)
        resetRicerca()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    void caricaNotifica(Long id){
        if (id){
            for (AnscInfoNotifica inot : lista){
                if (inot.id.compareTo(id) == 0){
                    setDettaglio(inot)
                    break
                }
            }
        } else {
            resetDettaglio()
        }
    }

    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRifNot){
        if (servizioCdu && archivioRif && idRifNot){
            return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu,
                                                     Long idRif, Long idComunicazione, IRicercaAnsc r, IAnscPaginazione paginazione) {
        AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
        recuperaCredenzialiEInviaComunicazione(ansUte, taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione)
    }

    void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu,
                            AnscCredenziali cre, Long idRifNot, Long idComunicazione, IRicercaAnsc rn, IAnscPaginazione paginazione, Boolean skip) {
        AnscEndPointServizio servizio = servizioCdu?.servizio
        AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneNotifica(taRifCom, servizio, idRifNot, idComunicazione, cre, rn, paginazione, skip, (servizio.flagNotificaRicerca || servizio.flagConsultazioneEvento || servizio.flagConsultazioneSoggetto))
        if ((com.getRetVal() ?: "") != "") {
            Messagebox.show(servizio.descrizioneEstesa + " :\n" + com.getRetVal(), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            if (servizio.flagNotificaRicerca){
                AnscPaginazione anscPaginazione = com?.getPaginazione()
                updateCountersByAnscPaginazione(anscPaginazione)
                // se ho fatto una ricerca devo leggere i dati da ansnot
                Page<AnscNotifica> p = eseguiQueryNotifiche(Boolean.FALSE)
                for (AnscNotifica n : p) {
                    if (TestoUtils.isVuoto(n.cognomeSoggettoAnsc) || TestoUtils.isVuoto(n.nomeSoggettoAnsc)){
                        consultaSoggettoNotificaAnsc(n.id, cre)
                    }
                }
                caricaListaDaQuery()
            }
            if (servizio.flagNotificaConferma || servizio.flagNotificaRifiuto){
                resetRicerca()
                ricercaNotifiche(cre)
            }
            if (servizio.flagConsultazioneEvento){
                AnscInfoEvento infoEvento = com.getInfoEvento()
                // ho aggiornato cognome e nome, devo rileggere da ansnot
                caricaListaDaQuery()
                caricaNotifica(idRifNot)
                for (AnscInfoNotifica inot : lista) {
                    if (infoEvento && inot.id.compareTo(idRifNot) == 0 && (inot.idAnsc == infoEvento.idAnsc)) {
                        inot.setInfoEvento(infoEvento)
                        caricaNotifica(inot?.id)
                        break
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////////////
    ////////////////////////////// RICERCA //////////////////////////////
    /////////////////////////////////////////////////////////////////////

    @Command void onRicercaNotificheAnsc(){
        ricercaNotifiche(null)
    }

    void ricercaNotifiche(AnscCredenziali cre){
        if (servizioRicercaNotifiche?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            AnscPaginazione anscPaginazione = getAnscPaginazioneByCounters()
            if (cre == null){
                verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.NOT, servizioRicercaNotifiche, null, null, ricercaNotifica, anscPaginazione)
            } else {
                tentaInvio(ETipoArchivioAnsc.NOT, servizioRicercaNotifiche, cre, null, null, ricercaNotifica, anscPaginazione, Boolean.FALSE)
            }
        }
    }

    /////////////////////////////////////////////////////////////////////
    ////////////////////////////// RIFIUTO //////////////////////////////
    /////////////////////////////////////////////////////////////////////

    @Command void onRifiutaNotificaAnsc(@BindingParam("infoNotifica") AnscInfoNotifica infoNotifica){
        Messagebox.show(infoNotifica.idAnsc + " - " + (infoNotifica.descrizione?:"") + ":\n" + "Si vuole procedere con il rifiuto della notifica selezionata?", msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            rifiutaNotifica(infoNotifica.id)
                        }
                    }
                }
        )
    }

    void rifiutaNotifica(Long idRifNot){
        if (servizioRifiutoNotifica?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.NOT, servizioRifiutoNotifica, idRifNot, null, null, null)
        }
    }

    /////////////////////////////////////////////////////////////////////
    ////////////////////////////// CONFERMA /////////////////////////////
    /////////////////////////////////////////////////////////////////////

    @Command void onConfermaNotificaAnsc(@BindingParam("infoNotifica") AnscInfoNotifica infoNotifica){
        Messagebox.show(infoNotifica.idAnsc + " - " + (infoNotifica.descrizione?:"") + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_conferma_notifica_ANSC")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
            new org.zkoss.zk.ui.event.EventListener() {
                void onEvent(Event e) {
                    if (Messagebox.ON_OK.equals(e.getName())) {
                        confermaNotifica(infoNotifica.id)
                    }
                }
            }
        )
    }

    void confermaNotifica(Long idRifNot){
        if (servizioConfermaNotifica?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.NOT, servizioConfermaNotifica, idRifNot, null, null, null)
        }
    }

    /////////////////////////////////////////////////////////////////////
    /////////////////////// CONSULTAZIONE  EVENTO ///////////////////////
    /////////////////////////////////////////////////////////////////////

    @Command void onConsultaEventoNotificaAnsc(@BindingParam("infoNotifica") AnscInfoNotifica infoNotifica){
        if (servizioConsultazioneEvento?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.NOT, servizioConsultazioneEvento, infoNotifica.id, null, null, null)
        }
    }

    /////////////////////////////////////////////////////////////////////
    /////////////////////// CONSULTAZIONE SOGGETTO //////////////////////
    /////////////////////////////////////////////////////////////////////

    void consultaSoggettoNotificaAnsc(Long idRifNot, AnscCredenziali cre){
        if (servizioConsultazioneSoggetto?.servizio == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_ANSC_servizio_notifica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            if (cre == null){
                verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc.NOT, servizioConsultazioneSoggetto, idRifNot, null, null, null)
            } else {
                tentaInvio(ETipoArchivioAnsc.NOT, servizioConsultazioneSoggetto, cre, idRifNot, null, null, null, Boolean.FALSE)
            }
        }
    }

    /////////////////////////////////////////////////////////////////////
    ///////////////////////// CONTATORI PAGINAZIONE //////////////////////////
    /////////////////////////////////////////////////////////////////////
    private AnscPaginazione getAnscPaginazioneByCounters() {
        return new AnscPaginazione(activePage + 1, pageSize, 0)
    }

    private void updateCountersByAnscPaginazione(AnscPaginazione p) {
        if (p == null) {
            resetActivePage()
            updateTotalSize(0L)
        } else {
            activePage = p.getNumeroPagina() - 1
            pageSize = p.getNumeroRecordPagina()
            updateTotalSize(p.getNumeroRecordTotali())
        }

        refreshUi()
    }
}
