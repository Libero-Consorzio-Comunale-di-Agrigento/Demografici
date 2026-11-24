package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RecuperoEsitoAccertamentiListaViewModel extends AbstractListaViewModel {

    List<AnaEsitoAccertamento> lista
    AnaEsitoAccertamento dettaglio

    final List<ETipoAnagrafe> listaTipoArchivioPratica = [ETipoAnagrafe.RESIDENTI]
    final List<ETipoPratica> listaTipoPratica = [ETipoPratica.ISC, ETipoPratica.CANC, ETipoPratica.VAR, null]
    ETipoPratica tipoPratica

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaEsitoAccertamentoService anaEsitoAccertamentoService
    @WireVariable
    private AnaAvanzamentoPraticaService anaAvanzamentoPraticaService
    @WireVariable
    private AnaPraticaAllegatoService anaPraticaAllegatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map<String, String>> eList = [Etichette.getEtichetta("Recupero_Esito_Accertamenti")]
        eList.addAll(AnaEsitoAccertamento.etichetteDomain)
        eList.addAll(AnaPratica.etichetteDomain)
        eList.addAll(EEsito.values()*.getEtichettaDesc())
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Nessun_Accertamento_Presente"), Etichette.getEtichetta("Ask_Modifiche_In_Sospeso"), Etichette.getEtichetta("Aggiornamento_Avanzamento_Effettuato_Con_Successo"),
                      Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("seleziona_tooltip"), Etichette.getEtichetta("scarica_documento_tooltip"),
                      Etichette.getEtichetta("Chiusura"), Etichette.getEtichetta("Numero_record_trovati"),
                      Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Funzione_non_disponibile"),
                      Etichette.getEtichetta("Inserimento_Pratica_Effettuato_Con_Successo"),
                      Etichette.getEtichetta("Trasferimeto_File_Eseguito_Con_Successo")])

        eList.addAll([Etichette.getEtichetta("Ordina_per"),
                      Etichette.getEtichetta("Data_Esito_decrescente"),
                      Etichette.getEtichetta("Data_Esito_crescente"),
                      Etichette.getEtichetta("Anno_Numero_Pratica_decrescente"),
                      Etichette.getEtichetta("Anno_Numero_Pratica_crescente")])


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Recupero_Esito_Accertamenti"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Esito_crescente")), SortUtils.dataEsitoAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Esito_decrescente")), SortUtils.dataEsitoDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Anno_Numero_Pratica_crescente")), [new Sort.Order(Sort.Direction.ASC, "annoPratica"), new Sort.Order(Sort.Direction.ASC, "pratica")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Anno_Numero_Pratica_decrescente")), [new Sort.Order(Sort.Direction.DESC, "annoPratica"), new Sort.Order(Sort.Direction.DESC, "pratica")])
        ])

        selectedOrder = listaOrder[0]

        caricaLista()

        if (lista.size() == 0) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_Accertamento_Presente")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                onBackFromList()
                            }
                        }
                    })
        }

    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = anaEsitoAccertamentoService.findAllByTipoPratica(tipoPratica, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onBackFromList() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void selectTipoPratica() {
        caricaLista()
    }

    @Command
    void onDownloadDocumenti(@BindingParam("accertamento") AnaEsitoAccertamento accertamento) {
        anaEsitoAccertamentoService.downloadDocumenti(accertamento)
    }

    @Command
    void onSeleziona(@BindingParam("accertamento") AnaEsitoAccertamento accertamento) {
        if(accertamento.avanzamento.pratica.tipoPratica != ETipoPratica.ISC) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }
        accertamento.avanzamento.esito = accertamento.esito
        accertamento.avanzamento.dataRestituzione = accertamento.dataEsito
        accertamento.avanzamento.note = accertamento.note

        anaAvanzamentoPraticaService.save(accertamento.avanzamento)

        String msg = "Pratica: ${ETipoAnagrafe.RESIDENTI.getEtichettaDesc().defaultValue} - ${accertamento.avanzamento.pratica.tipoPratica.etichettaDesc.defaultValue} - ${accertamento.pratica > 0 ? accertamento.pratica : getEtichetta(Etichette.getEtichetta("Provvisorio"))} / ${accertamento.annoPratica}\n"
        //Copia nel fascicolo il verbale
        if(accertamento.blobAllegato != null) {
            if(salvaAllegato(accertamento)) {
                msg += "${getEtichetta(Etichette.getEtichetta("Trasferimeto_File_Eseguito_Con_Successo"))}\n"
            } else {
                msg += "Fascicolo della pratica: il trasferimento del verbale nel fascioclo della pratica è fallito\n"
            }
        }

        Messagebox.show("${msg}\n${getEtichetta(Etichette.getEtichetta("Aggiornamento_Avanzamento_Effettuato_Con_Successo"))}", msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES == e.getName()) {
                            AnaPratica pratica = accertamento.avanzamento.pratica
                            Map params = ["id": pratica.id, modifica: true, idAvanzamento: accertamento.avanzamento.id, readOnly: (pratica.flagPerfezionamento || pratica.flagAnnullamento)]
                            switch (pratica.tipoPratica) {
                                case ETipoPratica.ISC:
                                    apriDettaglio("/restrict/anagrafe/pratiche/praticaIscrizioneResDettaglio.zul", params)
                                    break
                                case ETipoPratica.CANC:
                                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
//                                    apriDettaglio("/restrict/anagrafe/pratiche/praticaCancellazioneResDettaglio.zul", params)
                                    break
                                case ETipoPratica.VAR:
                                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
//                                    apriDettaglio("/restrict/anagrafe/pratiche/praticaVariazioneResDettaglio.zul", params)
                                    break
                            }
                        }
                    }
                })

    }

    private boolean salvaAllegato(AnaEsitoAccertamento accertamento) {
        AnaPratica pratica = accertamento.avanzamento.pratica
        AnaPraticaAllegato allegato = anaPraticaAllegatoService.create(pratica, accertamento.nomeAllegato)
        anaPraticaAllegatoService.save(allegato)

        try {
            anaPraticaAllegatoService.saveAllegatoDocumentale(allegato, accertamento.blobAllegato)
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)
            anaPraticaAllegatoService.saveAllegatoLocale(allegato, accertamento.blobAllegato)
            return true
        } catch (Exception ex) {
            log.error(ex.message, ex)
            anaPraticaAllegatoService.delete(allegato)
            return false
        }
        return true
    }
}
