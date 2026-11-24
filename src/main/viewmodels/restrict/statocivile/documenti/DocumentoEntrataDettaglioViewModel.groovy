package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.gestionetesti.GestioneTestiService
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkmax.zul.Filedownload
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitGestioneCaseCampi

import java.nio.charset.StandardCharsets

/**
 * Documento in Entrata
 */
@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoEntrataDettaglioViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneCaseCampi, TraitComune {

    final String urlTemplateSoggettoDAT = "documenti/templateSoggettoDAT.zul"

    Map<String,Boolean> minuscole = [:]

    final List<ETipoSN> listaSN = ETipoSN.values().toList()

    List<CivDisposizioniAnticipateTrattamentoTipoAtto> listaTipiAttoDAT = []

    List<Map<String, ?>> printList = []

    CivDisposizioniAnticipateTrattamento dettaglio

    CivNumerazioneDocumentiEntrata numerazioneDocumentiEntrata

    CivRegistroDocumentiEntrata registroDocumentiEntrata

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private CivDisposizioniAnticipateTrattamentoService civDisposizioniAnticipateTrattamentoService

    @WireVariable
    private CivDisposizioniAnticipateTrattamentoTipoAttoService civDisposizioniAnticipateTrattamentoTipoAttoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivRegistroDocumentiEntrataService civRegistroDocumentiEntrataService

    @WireVariable
    private CivNumerazioneDocumentiEntrataService civNumerazioneDocumentiEntrataService

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    @WireVariable
    private GestioneTestiService gestioneTestiService

    @WireVariable
    private UtenteCustomService utenteCustomService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id,
               @ExecutionArgParam("registro") CivRegistroDocumentiEntrata registro) {

        self = w

        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("DOCUMENTO_ENTRATA"), Etichette.getEtichetta("SEZIONE_DISPONENTE"), Etichette.getEtichetta("SEZIONE_FIDUCIARIO_1"),
                                           Etichette.getEtichetta("SEZIONE_FIDUCIARIO_2"), Etichette.getEtichetta("SEZIONE_NOTAIO"), Etichette.getEtichetta("Numera"), Etichette.getEtichetta("Minuscole"),
                                           Etichette.getEtichetta("Gestione_Documenti_Entrata")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Warn_Trattamento_Dati"), Etichette.getEtichetta("Ask_Cancellazione_Record"),
                      Etichette.getEtichetta("Errore_generazione_testo"), Etichette.getEtichetta("Errore_modello_testo_non_trovato")])
        eList.addAll(etichetteDettaglioDefault)
        eList.addAll(CivDisposizioniAnticipateTrattamento.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette SI/NO
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Documenti_Entrata"))

        formLabel = getEtichetta(Etichette.getEtichetta("DOCUMENTO_ENTRATA"))

        minuscole = [notaio:Boolean.FALSE]
        arcParametroService.checkMinuscoleOn(minuscole)

        this.registroDocumentiEntrata = registro
        if (registroDocumentiEntrata == null){
            List<CivRegistroDocumentiEntrata> l = civRegistroDocumentiEntrataService.listAll()
            if (l.size() == 1){
                registroDocumentiEntrata = l[0]
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_Operazione_non_consentita")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                onChiudi()
                return
            }
        }

        Page<GestioneTestiGsdProjection> p = gestioneTestiGsdModelloService.listByGruppoAndAmbito(EGruppo.CIV, EAmbito.TB, new PageRequest(0, Integer.MAX_VALUE, new Sort(SortUtils.descrizioneAsc)))
        for (GestioneTestiGsdProjection gp:p?.getContent()){
            printList.add(id: gp.id, descrizione: gp.descrizione)
        }
        printRecordPlusEnabled = (printList.size() > 0)

        if (id) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }

        listaTipiAttoDAT = civDisposizioniAnticipateTrattamentoTipoAttoService.listAll(new Sort(SortUtils.idAsc))
    }

    @Override void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = civDisposizioniAnticipateTrattamentoService.get((Integer) id)

            DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

            initNumerazioneDocumenti()

            Events.postEvent(CustomEvents.ON_REFRESH_INNER_COMPONENT, self, [dat:dettaglio])

            refreshUi()
        } else {
            onChiudi()
        }
    }

    @Override void creaDettaglio(Map params) {
        dettaglio = new CivDisposizioniAnticipateTrattamento(params)

        Events.postEvent(CustomEvents.ON_REFRESH_INNER_COMPONENT, self, [dat:dettaglio])
    }

    void initNumerazioneDocumenti(){
        if ( (dettaglio.protocollo.anno != null) ) {
            numerazioneDocumentiEntrata = civNumerazioneDocumentiEntrataService.getByAnnoAndRegistro(dettaglio.protocollo.anno, registroDocumentiEntrata)
        }
    }

    @Command void onCancellaCampoDAT(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CC_NOTAIO:
                riempiComune(dettaglio.comuneNotaio, c)
                break
            case ETipoComuneAtto.CC_COLLEGIO:
                riempiComune(dettaglio.comuneCollegioNotarile, c)
                break
        }
    }

    @Command void onSelectTipoAttoDAT() {
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio && saveRecordEnabled) {
            CivDisposizioniAnticipateTrattamento c = civDisposizioniAnticipateTrattamentoService.save(dettaglio, numerazioneDocumentiEntrata)
            if (dettaglio.disponente.consensoTrattamento == ETipoSN.N){
                Messagebox.show(String.format(getEtichetta(Etichette.getEtichetta("Warn_Trattamento_Dati")), getEtichetta(Etichette.getEtichetta("SEZIONE_DISPONENTE"))),
                        msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
            if (dettaglio.fiduciario1.consensoTrattamento == ETipoSN.N) {
                Messagebox.show(String.format(getEtichetta(Etichette.getEtichetta("Warn_Trattamento_Dati")), getEtichetta(Etichette.getEtichetta("SEZIONE_FIDUCIARIO_1"))),
                        msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
            if (dettaglio.fiduciario2.consensoTrattamento == ETipoSN.N){
                Messagebox.show(String.format(getEtichetta(Etichette.getEtichetta("Warn_Trattamento_Dati")), getEtichetta(Etichette.getEtichetta("SEZIONE_FIDUCIARIO_2"))),
                        msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            if (c) {
                caricaDettaglio(c.id)
            }
        }
    }

    @Command void onEliminaRecord() {
        if (deleteRecordEnabled) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            civDisposizioniAnticipateTrattamentoService.delete(dettaglio)
                            onChiudi()
                        }
                    }
                }
            )
        }
    }

    @Command void onNumeraProtocolloDAT() {
        if ( (dettaglio.protocollo.numero == null) ) {
            // Prima verifico se ci sono le condizioni per valorizzare la data
            if (dettaglio.protocollo.anno == null){
                dettaglio.protocollo.data = (new Date()).clearTime()
            }
            // e dopo controllo l'anno
            if (dettaglio.protocollo.anno == null){
                dettaglio.protocollo.anno = DataUtils.getAnnoCorrente()
            }
            numerazioneDocumentiEntrata = civNumerazioneDocumentiEntrataService.getOrCreateByAnnoAndRegistro(dettaglio.protocollo.anno, registroDocumentiEntrata)
            numerazioneDocumentiEntrata.numero = numerazioneDocumentiEntrata.numero+1
            dettaglio.protocollo.numero = numerazioneDocumentiEntrata.numero
            refreshUi()
        }
    }

    @Command void onStampaPlus(@BindingParam("id") Long id) {
        if (printRecordPlusEnabled) {
            GestioneTestiGsdModello g = null
            try {
                Map<?, ?> parametriQuery =  [ 'idDat' : dettaglio.id, codUtente: utenteCustomService.loggedUserId]
                g = gestioneTestiGsdModelloService.get(id)

                if (g == null){
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_modello_testo_non_trovato")), msgTitle, Messagebox.OK, Messagebox.ERROR)
                    return
                }

                String queryModello = new String (g.tipoModello.query)
                String formato = (g.formatoTesto?:g.tipo)
                String nomeFile = "${g.descrizione}.${formato}"
                ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
                InputStream is = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true, StandardCharsets.UTF_8)
                byte[] allegato = is.getBytes()
                Filedownload.save(allegato, FileUtils.getMimeType(formato), nomeFile)
                is.close()
            } catch (Exception ex){
                log.error("Errore stampa DAT", ex)
                Messagebox.show(g.descrizione + ":\n" +  getEtichetta(Etichette.getEtichetta("Errore_generazione_testo")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }
    }

}
