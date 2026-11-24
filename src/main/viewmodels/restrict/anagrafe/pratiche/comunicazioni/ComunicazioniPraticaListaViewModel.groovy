package restrict.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.Apr4ModelPdfService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaDichiarazioneIscrizioneResService
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.IDichiarazioneRes
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.*
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import it.finmatica.gestionetesti.GestioneTestiService
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.annotation.*
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitComunicazioni

import javax.persistence.criteria.JoinType
import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioniPraticaListaViewModel extends AbstractListaViewModel implements TraitComunicazioni {

    AnaPratica pratica
    Boolean priorita

    List<AnaArchivioComunicazione> lista
    List<AnaArchivioComunicazione> listaComunicazioniSelezionate
    AnaArchivioComunicazione _dettaglio
    AnaComunicazioneProtocollo comunicazioneProtocollo
    List<AnaComunicazioneDestinatario> listaDestinatari
    List<AnaComunicazioneAllegato> listaAllegati

    String managePrincipale
    Boolean firmaRemotaAutomatica

    Boolean massiveCheck
    Boolean showDetailsComunicazione = Boolean.TRUE
    Boolean showDetailsAtto = Boolean.FALSE
    Boolean showMassiveCheck = Boolean.TRUE
    Boolean showDeleteOption = Boolean.TRUE
    Boolean showRecapMessage = Boolean.TRUE

    @Delegate
    ControlBarComunicazioniAttributes cbComList = new ControlBarComunicazioniAttributes()

    @WireVariable
    private GsdService gsdService

    GsdService getGsdService() {
        return gsdService
    }

    @WireVariable
    private GsdFirmaService gsdFirmaService

    GsdFirmaService getGsdFirmaService() {
        return gsdFirmaService
    }

    @WireVariable
    private AnaPraticaService anaPraticaService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnaArchivioComunicazioneService anaArchivioComunicazioneService

    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return anaArchivioComunicazioneService
    }

    @WireVariable
    private AnaComunicazioneProtocolloService anaComunicazioneProtocolloService

    IComunicazioneProtocolloService getComunicazioneProtocolloService() {
        return anaComunicazioneProtocolloService
    }

    @WireVariable
    private AnaComunicazioneDestinatarioService anaComunicazioneDestinatarioService

    IComunicazioneDestinatarioService getComunicazioneDestinatarioService() {
        return anaComunicazioneDestinatarioService
    }

    @WireVariable
    private AnaComunicazioneAllegatoService anaComunicazioneAllegatoService

    IComunicazioneAllegatoService getComunicazioneAllegatoService() {
        return anaComunicazioneAllegatoService
    }

    @WireVariable
    private GestioneTestiService gestioneTestiService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private Apr4ModelPdfService apr4ModelPdfService

    @WireVariable
    private AnaDichiarazioneIscrizioneResService anaDichiarazioneIscrizioneResService

    /*@WireVariable
    private AnaDichiarazioneCancellazioneResService anaDichiarazioneCancellazioneResService*/


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long idPratica, @ExecutionArgParam("priorita") Boolean priorita) {
        self = w

        backFromListComunicazioneEnabled = true
        addComunicazioneEnabled = true
        generaTestoComunicazioneEnabled = true
        goToFascicoloEnabled = false
        goToAllegatiEnabled = true

        List<Map> eList = [Etichette.getEtichetta("adempimenti_tooltip"), Etichette.getEtichetta("SEZIONE_COMUNICAZIONI_PRATICA"), Etichette.getEtichetta("Comunicazioni")]


        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarComunicazioniAttributes.etichetteCbComListDesc)

        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())

        // Aggiungo etichette delle Comunicazioni
        eList.addAll(AnaArchivioComunicazione.etichetteDomain)
        eList.addAll(AnaComunicazioneProtocollo.etichetteDomain)
        eList.addAll(AnaComunicazioneDestinatario.etichetteDomain)
        eList.addAll(AnaComunicazioneAllegato.etichetteDomain)

        eList.addAll([Etichette.getEtichetta("Ask_Modifiche_In_Sospeso"), Etichette.getEtichetta("Ask_Cancellazione_Record"), Etichette.getEtichetta("Errore_file_formato"),
                      Etichette.getEtichetta("Chiusura"), Etichette.getEtichetta("Errore_generazione_testo"), Etichette.getEtichetta("Salvataggio_Completato"),
                      Etichette.getEtichetta("Warn_Nessuna_comunicazione_selezionata"), Etichette.getEtichetta("Numero_Protocollo_Anno"), Etichette.getEtichetta("Ask_Aggiornamento_Testo_Comunicazione")
                      , Etichette.getEtichetta("Numero_Registro_Anno"), Etichette.getEtichetta("RIEPILOGO_ELABORAZIONE"), Etichette.getEtichetta("Errore_inserimento_nome_allegato_pratica")])
        eList.addAll(AbstractListaViewModel.etichetteListaDefault)

        // Aggiungo etichette stato comunicazione
        eList.addAll(Arrays.asList(EStatoProtocollazione.values())*.etichettaDesc)


        this.priorita = priorita
        pratica = anaPraticaService.findById(idPratica)

        leggiParametri()

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)


        msgTitle = getEtichetta(Etichette.getEtichetta("SEZIONE_COMUNICAZIONI_PRATICA")) + (priorita ? " (${getEtichetta(Etichette.getEtichetta("adempimenti_tooltip"))})" : "")
        formLabel = getEtichetta(Etichette.getEtichetta("SEZIONE_COMUNICAZIONI_PRATICA")) + (priorita ? " (${getEtichetta(Etichette.getEtichetta("adempimenti_tooltip"))})" : "")

        resize()

        caricaLista()
    }

    void leggiParametri() {
        managePrincipale = arcParametroService.isModificaAllegatoPrincipaleComunicazionePraticaAttiva()
        firmaRemotaAutomatica = arcParametroService.isFirmaRemotaAutomaticaAttiva()
    }

    AnaArchivioComunicazione getDettaglio() {
        return _dettaglio
    }

    @Override
    void resetDettaglio() {
        setDettaglio(null)
    }


    @Override
    void caricaLista() {
        listaComunicazioniSelezionate = []

        massiveCheck = Boolean.FALSE

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        resetDettaglio()

        setAttributiElaborazione()

        refreshUi()
    }

    void setAttributiElaborazione() {
        protocollaComunicazioneEnabled = false
        for (AnaArchivioComunicazione c : lista) {
            if (c.isDaProtocollare()) {
                protocollaComunicazioneEnabled = true
            }
        }
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        List<AnaArchivioComunicazione> l = anaArchivioComunicazioneService.listAllByUkPratica(pratica.archivioAnagrafe, pratica.tipoPratica, pratica.numero, pratica.anno,
                [priorita: priorita, fetch: [[campo: 'comunicazione.modello', tipo: JoinType.LEFT], [campo: 'anagrafe', tipo: JoinType.LEFT], [campo: 'eventoPratica', tipo: JoinType.LEFT]],
                 order   : SortUtils.dataRegistrazioneAscOnly]) ?: []

        return new Paginazione(l, l.size())
    }

    void setArchivio(IArchivioComunicazione arcCom) {
        _dettaglio = arcCom as AnaArchivioComunicazione
    }

    @Command
    void onBackFromList() {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), getEtichetta(Etichette.getEtichetta("Chiusura")), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())) {
                            Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
                            onChiudi()
                        }
                    }
                }
        )
    }

    @Command
    void onInserisci() {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/comunicazioni/comunicazioniPraticaSelect.zul", self, [pratica: pratica, priorita: priorita])
        w.addEventListener(Events.ON_CLOSE, { event ->
            onRicarica()
        })
        w.doModal()
    }

    @Command
    void onOpenAllegati() {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneAllegatiPratica.zul", self.parent, [id: pratica.id])
        self.setVisible(false)
        w.addEventListener(Events.ON_CLOSE, { event ->
            refreshUi()
            self.setVisible(true)
        })
        w.doEmbedded()
    }

    @Command
    void onSelezionaTutte() {
        selezionaTutte()
    }

    @Command
    void onSelezionaComunicazione(@BindingParam("selected") Boolean selected, @BindingParam("comunicazione") AnaArchivioComunicazione arcCom) {
        seleziona(selected, arcCom, Boolean.TRUE)
    }

    @Command
    void onEliminaComunicazione(@BindingParam("comunicazione") AnaArchivioComunicazione arcCom) {
        if (arcCom?.comunicazione && showDeleteOption) {
            Messagebox.show(arcCom.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaERicaricaComunicazione(arcCom)
                                onRicarica()
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onFascicolaComunicazione(@BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        if (arcCom) {
            fascicolaComunicazioneEAllegati(arcCom, Boolean.TRUE)
        }
    }

    @Command
    void onGeneraTesti() {
        generaTesti()
    }

    void fascicolaComunicazioneEAllegati(IArchivioComunicazione _arcCom, Boolean refreshComunicazione) {
        AnaArchivioComunicazione arcCom = _arcCom as AnaArchivioComunicazione
        int retVal = -1
        try {
            //Salvataggio allegati sul documentale
            retVal = anaComunicazioneAllegatoService.fascicolaAllegati(arcCom, pratica)
        } catch (ErroreDatiFascicoloRuntimeException dfre) {
            Messagebox.show(arcCom.comunicazione.descrizione + "\n" + getEtichetta(dfre.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        }

        if (retVal == 0) {
            Messagebox.show(arcCom.comunicazione.descrizione + ":\n" + "non risultano allegati da inserire", msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else if (retVal > 0) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            onPagina()
            setDettaglio(arcCom)
        } else {
            Messagebox.show(arcCom.comunicazione.descrizione + "\n" + getEtichetta(Etichette.getEtichetta("Errore_inserimento_nome_allegato_pratica")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void showCustomMessagebox(IArchivioComunicazione c) {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/customMessagebox.zul", self, [titolo      : getEtichetta(Etichette.getEtichetta("Comunicazioni")),
                                                                                                             msg         : (c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Aggiornamento_Testo_Comunicazione"))),
                                                                                                             listaOpzioni: [Etichette.getEtichetta("SI"), Etichette.getEtichetta("NO")], params: [arcCom: c]])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data.opzione.codice == Etichette.getEtichetta("SI").codice) {
                generaTestoComunicazione(event.data.params.arcCom, Boolean.TRUE)
            }
        })
        w.doModal()
    }

    void generaTestoComunicazione(IArchivioComunicazione _c, Boolean scaricaDopoGenerazione) {
        AnaArchivioComunicazione c = _c as AnaArchivioComunicazione
        AnaComunicazioneAllegato alleCom = (anaComunicazioneAllegatoService.getPrincipale(c.id) ?: new AnaComunicazioneAllegato(archivioComunicazione: c, principale: Boolean.TRUE))

        // genero la stampa e faccio download
        try {
            Map<?, ?> parametriQuery = [:] // al momento vuoto, i parametri vengono caricati al volo
            GestioneTestiGsdModello g = gestioneTestiModelloRelazioneService.getByIdModelloAnagrafe(c.comunicazione.modello.id)?.modello

            if (g == null) {
                Messagebox.show(c.comunicazione.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Errore_modello_testo_non_trovato")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                return
            }
            log.info("Avvio recupero xml data per comunicazione ${c.id}")

            String queryModello = ""
            if(priorita) {
                queryModello = gsdService.getDataSourceXmlAdempimentoPratica(c)
            } else {
                queryModello = gsdService.getDataSourceXmlComunicazionePratica(c)
            }

            log.info("Recuperato xml data per comunicazione ${c.id}")
            String formato = (g.formatoTesto?.name() ?: g.tipo).toLowerCase()
            alleCom.nomeAllegato = "${c.nomeFileComunicazione}_${c.annoPratica}_${c.numeroPratica}.${formato}"
            ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
            InputStream is = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true, StandardCharsets.UTF_8)
            salvaAllegato(alleCom, Boolean.TRUE, is, Boolean.TRUE, Boolean.TRUE, scaricaDopoGenerazione)
            if(c.eventoPratica != null) {
                gsdService.inserisciAvanzamento(c.archivioAnagrafe, c.tipoPratica, pratica.anno, pratica.numero, c.eventoPratica.codEp)
            }
        } catch (Exception ex) {
            log.error("Errore stampa comunicazione", ex)
            String msg = getEtichetta(Etichette.getEtichetta("Errore_generazione_testo"))
            if (ex instanceof De4gsdzkRuntimeException) {
                msg = ex.message
            }
            Messagebox.show(c.comunicazione.descrizione + ":\n" + msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        refreshLista()
    }

    void scaricaAllegatiComeZip(List<IArchivioComunicazione> comunicazioniGenerate) {
        List<IComunicazioneAllegato> allegati = []
        for (IArchivioComunicazione c : comunicazioniGenerate) {
            IComunicazioneAllegato alle = anaComunicazioneAllegatoService.getPrincipale(c.id)
            if (alle) {
                allegati.add(alle)
            }
        }
        if (!allegati.isEmpty()) {
            gsdFirmaService.scaricaAllegatiZip("comunicazioni_${pratica.idPratica}", allegati)
        }
    }

    @Command
    void onProtocolla() {
        protocolla()
    }

    @Command
    void onInviaAlbo() {
        inviaAlbo()
    }

    String addToRecapMsg(String initStr, ETipoElaborazioneComunicazione tipoElaborazione, IArchivioComunicazione _arcCom) {
        AnaArchivioComunicazione arcCom = _arcCom as AnaArchivioComunicazione
        if (showRecapMessage) {
            AnaComunicazioneProtocollo comProt = (arcCom.id ? anaComunicazioneProtocolloService.get(arcCom.id) : null)
            String msg = arcCom.comunicazione.descrizione + ":\n"
            msg += (tipoElaborazione == ETipoElaborazioneComunicazione.PROTOCOLLAZIONE) ? getEtichetta(Etichette.getEtichetta("Numero_Protocollo_Anno")) : getEtichetta(Etichette.getEtichetta("Numero_Registro_Anno"))
            msg += " : " + comProt?.numeroProtocollo + "/" + comProt?.annoProtocollo
            if (comProt?.dataProtocollo != null) {
                msg += "  " + getEtichetta(Etichette.getEtichetta("Del")) + " " + DataUtils.fromDateToString(comProt.dataProtocollo)
            }
            return initStr + (msg ?: "") + "\n\n"
        } else {
            return ""
        }
    }

    String getDettaglioComunicazioneRecapMsg(IArchivioComunicazione _arcCom) {
        AnaArchivioComunicazione arcCom = _arcCom as AnaArchivioComunicazione
        return arcCom.comunicazione.descrizione + "\n"
    }


    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// PROTOCOLLO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void setComunicazioneProtocollo(IComunicazioneProtocollo protocollo) {
        comunicazioneProtocollo = protocollo as AnaComunicazioneProtocollo
    }

    @Command
    void onSalvaComunicazioneProtocollo(@BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        salvaComunicazioneProtocollo(arcCom)
    }


    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// DESTINATARI ///////////////////////////
    ////////////////////////////////////////////////////////////////////////


    void setListaDestinatari(List<IComunicazioneDestinatario> destinatari) {
        listaDestinatari = destinatari as List<AnaComunicazioneDestinatario>
    }

    @Command
    void onInserisciDestinatario(@BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/comunicazioni/destinatariSelect.zul", self, [idArcCom: arcCom.id])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            AnaComunicazioneDestinatario dest = new AnaComunicazioneDestinatario(archivioComunicazione: arcCom)
            if (event.data.dettaglio instanceof ArcComune) {
                ArcComune comune = event.data.dettaglio
                dest.codiceComuneDestinatario = comune.codiceComune
                dest.codiceProvinciaDestinatario = comune.codiceProvincia
            }
            if (event.data.dettaglio instanceof AnaEnte) {
                AnaEnte ente = event.data.dettaglio
                dest.ente = ente
            }
            salvaERicaricaDestinatari(dest, arcCom)
        })
        w.doModal()
    }


    @Command
    void onEliminaDestinatario(@BindingParam("destinatario") AnaComunicazioneDestinatario destinatario) {
        if (destinatario && (!(destinatario.archivioComunicazione.isProtocollato()))) {
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), getEtichetta(Etichette.getEtichetta("Destinatari")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaERicaricaDestinatari(destinatario.id, destinatario.archivioComunicazione)
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onInviaPecDestinatario(@BindingParam("destinatario") AnaComunicazioneDestinatario destinatario) {
        if (destinatario && destinatario.archivioComunicazione.isProtocollato()) {
            Messagebox.show(destinatario.denominazione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Invio_Pec")), getEtichetta(Etichette.getEtichetta("Destinatari")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                inviaPec(destinatario)
                            }
                        }
                    }
            )
        }
    }


    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// ALLEGATI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    void setListaAllegati(List<IComunicazioneAllegato> allegati) {
        listaAllegati = allegati as List<AnaComunicazioneAllegato>
    }

    @Command
    void onEliminaAllegato(@BindingParam("allegato") AnaComunicazioneAllegato allegato, @BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        if (allegato?.id) {
            Messagebox.show((String) allegato.nomeAllegato + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), getEtichetta(Etichette.getEtichetta("Allegati")), Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaERicaricaAllegati(allegato.id, arcCom)
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onDownloadAllegato(@BindingParam("allegato") AnaComunicazioneAllegato allegato) {
        if (allegato) {
            scaricaAllegato(allegato.id, true)
        }
    }


    void fileNonValido(IComunicazioneAllegato _alleCom, Long id) {
        AnaComunicazioneAllegato alleCom = _alleCom as AnaComunicazioneAllegato
        Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
        String[] buttonsLabel = [getEtichetta(Etichette.getEtichetta("SI")), getEtichetta(Etichette.getEtichetta("NO")), getEtichetta(Etichette.getEtichetta("Annulla"))] as String[]
        Messagebox.show(alleCom.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Sbustamento_File")), getEtichetta(Etichette.getEtichetta("Allegati")), buttons, buttonsLabel, Messagebox.QUESTION, null,
                new EventListener() {
                    void onEvent(Event e) {
                        if (e.getName() == Messagebox.ON_YES) {
                            scaricaAllegato(id, true, false)
                        }
                        if (e.getName() == Messagebox.ON_NO) {
                            scaricaAllegato(id, false, false)
                        }
                    }
                }
        )
    }

    @Command
    void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event, @BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        Media media = event.media
        byte[] _allegato = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        // refs #62971
        Map<String, String> m = FileUtils.checkFile(_allegato, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (m) {
            Messagebox.show(nomeFile + ":\n" + getEtichetta(m), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            AnaComunicazioneAllegato alleCom = new AnaComunicazioneAllegato(archivioComunicazione: arcCom, nomeAllegato: nomeFile)
            InputStream is = new ByteArrayInputStream(_allegato)
            salvaAllegato(alleCom, Boolean.TRUE, is)
        }
    }

    @Command
    void onAllegaCopiaConforme(@BindingParam("arcCom") AnaArchivioComunicazione arcCom) {
        //Entro in questa situazione solo per pratiche RES di tipo Iscrizione o Cancellazione
        //uniche pratiche che prevedono il modello APR/4
        AnaComunicazioneAllegato alleCom = new AnaComunicazioneAllegato(archivioComunicazione: arcCom)
        anaComunicazioneAllegatoService.validaDatiPre(alleCom)

        IDichiarazioneRes dichiarazione
        if(pratica.tipoPratica == ETipoPratica.ISC) {
            dichiarazione = anaDichiarazioneIscrizioneResService.findByPratica(pratica)
        } else if (pratica.tipoPratica == ETipoPratica.CANC) {
            //dichiarazione = anaDichiarazioneCancellazioneResService.findByPratica(pratica)
        }

        int numSoggetti = apr4ModelPdfService.getSubjectsNumber(dichiarazione.numero, dichiarazione.anno)
        Window w = (Window) Executions.createComponents("/restrict/afc/popupUfficialeAnagrafe.zul", self, [sorgente: 'C'])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { event ->
            if (numSoggetti == 1) {
                byte[] allegato = apr4ModelPdfService.generateApr4UnComponenti(pratica.anno, pratica.numero, event.data.ufficialeAnagrafe as String)
                aggiungiModuloApr4(alleCom, allegato, dichiarazione.idDichiarazione, ETipoFile.PDF)
            } else { // > 1
                byte[] allegato = apr4ModelPdfService.generateApr4DueComponenti(pratica.anno, pratica.numero, event.data.ufficialeAnagrafe as String)
                aggiungiModuloApr4(alleCom, allegato, dichiarazione.idDichiarazione, numSoggetti == 2 ? ETipoFile.PDF : ETipoFile.ZIP)
            }
        })
        w.doModal()

    }

    void aggiungiModuloApr4(AnaComunicazioneAllegato alleCom, byte[] allegato, String idDichiarazione, ETipoFile tipoFile) {
        InputStream is = new ByteArrayInputStream(allegato)

        alleCom.nomeAllegato = "MODELLO_APR4_${idDichiarazione}.${tipoFile.estensione}"
        salvaAllegato(alleCom, Boolean.TRUE, is)
    }

    @Command
    void onCambiaPrincipaleAllegato(@BindingParam("allegato") AnaComunicazioneAllegato alleCom) {
        salvaAllegato(alleCom, Boolean.FALSE, null)
    }

    void salvaAllegato(AnaComunicazioneAllegato alleCom, Boolean salvaSuDocumentale, InputStream is,
                       Boolean ignoreStampaEseguita = Boolean.FALSE, Boolean aggiornaStampaEseguita = Boolean.FALSE, Boolean scaricaAllegato = Boolean.FALSE) {

        try {
            anaComunicazioneAllegatoService.save(alleCom, pratica, salvaSuDocumentale, is, Boolean.FALSE, ignoreStampaEseguita, aggiornaStampaEseguita)
            if (scaricaAllegato) {
                onDownloadAllegato(alleCom)
            }
            if (alleCom.archivioComunicazione) {
                if (alleCom.archivioComunicazione.isDaProtocollare() || alleCom.archivioComunicazione.isDaInviareAlbo()) {
                    log.info(alleCom.archivioComunicazione.id + ": non aggiorno il flag stampa_eseguita in quanto comunicazione da protocollare o inviare all'albo")
                } else {
                    for (AnaArchivioComunicazione c : lista) {
                        if (c.id.compareTo(alleCom.archivioComunicazione.id) == 0) {
                            c.stampaEseguita = anaArchivioComunicazioneService.get(alleCom.archivioComunicazione.id).stampaEseguita
                            break
                        }
                    }
                }
            }
            caricaAllegati(alleCom.archivioComunicazione)
            refreshLista()
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)
            Messagebox.show(alleCom.nome + ":\n" + (getEtichetta(Etichette.getEtichetta("Errore_salvataggio_file_documentale")) ?: dre.getMessage()) + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio_Documento")),
                    msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                alleCom.blobAllegato = is.getBytes()
                                salvaAllegato(alleCom, Boolean.FALSE, is, ignoreStampaEseguita, aggiornaStampaEseguita, scaricaAllegato)
                            }
                        }
                    }
            )
        }
    }


}
