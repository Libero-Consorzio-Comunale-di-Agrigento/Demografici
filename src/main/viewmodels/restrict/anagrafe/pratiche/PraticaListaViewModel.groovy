package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
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
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi
import restrict.statocivile.TraitStampaCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PraticaListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitStampaCampi {

    //Per la visualizzazione si sceglie di utilizzare una lista di dichiaranti
    //E tramite la relazione di quest'ultimi con la pratica visualizzare i dati mancanti navigando la relazione
    List<AnaDichiarante> lista
    AnaDichiarante selectedDichiarante
    //Per l'editing si utilizza l'oggetto pratica associato
    AnaPratica dettaglio

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaEventoPraticaService anaEventoPraticaService
    @WireVariable
    private AnaDichiaranteService anaDichiaranteService
    @WireVariable
    protected ArcParametroService arcParametroService
    @WireVariable
    private ExportService exportService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()
    List<Map> addPlusList = []
    List<Map<String, String>> filtriList = [[codice: "ESTRAZIONE", descrizione: getEtichetta(Etichette.getEtichetta("Estrazioni"))]]

    RicercaPratica ricercaPratica

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    final List<ETipoAnagrafe> listaTipoArchivioPratica = [ETipoAnagrafe.RESIDENTI, ETipoAnagrafe.AIRE]
    final List<ETipoPratica> listaTipoPratica = ETipoPratica.values().toList()
    List<AnaEventoPratica> statiPratica = []
    List<ETipoNumerazione> tipiNumerazione = [null] + ETipoNumerazione.values().toList()

    String csvCharsetName


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        addEnabled = false
        addPlusEnabled = true
        modifyEnabled = false
        //filtriExtraEnabled = true
        csvExportEnabled = true
        excelExportEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Pratiche")]

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        //Etichette per ricerca
        eList.addAll(RicercaPratica.etichetteRicercaPraticaDesc)
        eList.addAll(AnaPratica.etichetteDomain)
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())
        eList.addAll(ETipoNumerazione.values()*.getEtichettaDesc())
        eList.addAll(Etichette.getEtichetta("Funzione_non_disponibile"))
        eList.addAll(Etichette.getEtichetta("Giorni_Monitoraggio"), Etichette.getEtichetta("Provvisorio"), Etichette.getEtichetta("visualizza_tooltip"))
        eList.addAll(Etichette.getEtichetta("Recupero_Pratiche_Web"), Etichette.getEtichetta("Recupero_Pratiche_ANPR"), Etichette.getEtichetta("Recupero_Esito_Accertamenti"))

        //Etichette per ordinamento
        eList.addAll(etichetteListaDefault)
        eList.addAll([Etichette.getEtichetta("Data_Pratica_decrescente"),
                      Etichette.getEtichetta("Data_Pratica_crescente"),
                      Etichette.getEtichetta("Anno_Numero_Pratica_decrescente"),
                      Etichette.getEtichetta("Anno_Numero_Pratica_crescente"),
                      Etichette.getEtichetta("Giorni_Monitoraggio_decrescente")])


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)


        ricercaPratica = new RicercaPratica()

        msgTitle = getEtichetta(Etichette.getEtichetta("Pratiche"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        popolaAddPlusList()
        //Inserisco voce "Tutti"
        listaTipoArchivioPratica.add(null)
        //Inserisco la voce "Tutte" e Rettifiche
        //listaTipoPratica.add(ETipoPratica.RET)
        listaTipoPratica.add(null)


        //popola Stati pratica
        popolaStatoPratica(null, null)

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Anno_Numero_Pratica_decrescente")), SortUtils.annoNumeroPraticaDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Anno_Numero_Pratica_crescente")), SortUtils.annoNumeroPraticaAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Pratica_decrescente")), SortUtils.dataPraticaDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Pratica_crescente")), SortUtils.dataPraticaAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Giorni_Monitoraggio_decrescente")), SortUtils.giorniMonitoraggio)])

        selectedOrder = listaOrder[0]

        csvCharsetName = arcParametroService.getCsvCharsetName()

    }

    private void popolaAddPlusList() {
        List<Map> subList = []
        for (ETipoAnagrafe archivio : listaTipoArchivioPratica) {
            subList.add([id: archivio, descrizione: getEtichetta(archivio.getEtichettaDesc())])
        }
        for (ETipoPratica p : listaTipoPratica) {
            addPlusList.add([id: p, descrizione: getEtichetta(p.getEtichettaDesc()), tipo: 'P', idDomain: p, subList: subList])
        }

    }


    private void popolaStatoPratica(ETipoAnagrafe tipoArchivio, ETipoPratica tipoPratica) {
        statiPratica.clear()
        statiPratica.add(new AnaEventoPratica(null, etichette['Tutti'])) //oggetto dummy
        statiPratica.addAll(anaEventoPraticaService.findStatiValidi(tipoArchivio, tipoPratica))
        ricercaPratica.statoPratica = statiPratica.first()
        refreshUi()
    }

    @Command
    void filtraStatiPratica() {
        popolaStatoPratica(ricercaPratica.archivioAnagrafe, ricercaPratica.tipoPratica)
        onRicerca()
    }

    @Command
    void onApri() {
        dettaglio = selectedDichiarante.pratica
        Map params = ["id": dettaglio.id, modifica: true, readOnly: (dettaglio.flagPerfezionamento || dettaglio.flagAnnullamento)]
        apriInterfaccia(dettaglio.tipoPratica, dettaglio.archivioAnagrafe, params)
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
    void resetLista() {
        lista = []
        refreshLista()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page p = anaDichiaranteService.listAllByRicercaPratica(ricercaPratica, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        if(p == 'statoPratica') {
            ricercaPratica.statoPratica = statiPratica.first()
        } else {
            cancellaCampo(ricercaPratica, p)
        }
        resetRicerca()
    }

    @Command
    void onInserisciPlus(@BindingParam("idParent") ETipoPratica tipoPratica, @BindingParam("idDomain") ETipoAnagrafe tipoAnagrafe) {
        if (addPlusEnabled) {
            Map params = [modifica: false, readOnly: false]
            apriInterfaccia(tipoPratica, tipoAnagrafe, params)
        }
    }

    private void apriInterfaccia(ETipoPratica tipoPratica, ETipoAnagrafe archivioAnagrafe, params) {
        switch (tipoPratica) {
            case ETipoPratica.ISC:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    apriDettaglio("/restrict/anagrafe/pratiche/praticaIscrizioneResDettaglio.zul", params)
                } else if (archivioAnagrafe == ETipoAnagrafe.AIRE) {
//                        apriDettaglio("/restrict/anagrafe/pratiche/praticaIscrizioneAireDettaglio.zul", params)
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
                break
            case ETipoPratica.CANC:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
//                        apriDettaglio("/restrict/anagrafe/pratiche/praticaCancellazioneResDettaglio.zul", params)
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                } else if (archivioAnagrafe == ETipoAnagrafe.AIRE) {
//                        apriDettaglio("/restrict/anagrafe/pratiche/praticaCancellazioneAireDettaglio.zul", params)
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
                break
            case ETipoPratica.VAR:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
//                    apriDettaglio("/restrict/anagrafe/pratiche/praticaVariazioneResDettaglio.zul", params)
                } else if (archivioAnagrafe == ETipoAnagrafe.AIRE) {
//                        apriDettaglio("/restrict/anagrafe/pratiche/praticaVariazioneAireDettaglio.zul", params)
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
                break
            case ETipoPratica.RET:
                if (archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
//                    apriDettaglio("/restrict/anagrafe/pratiche/praticaRettificaResDettaglio.zul", params)
                } else if (archivioAnagrafe == ETipoAnagrafe.AIRE) {
//                    apriDettaglio("/restrict/anagrafe/pratiche/praticaCancellazioneAireDettaglio.zul", params)
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_disponibile")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
                break
        }
    }

    @Command
    void onSelectTerminalista(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            ricercaPratica.terminalista = (CerTerminalista) event.getData()
        } else {
            ricercaPratica.terminalista = null
        }
        onRicarica()
    }

    @Command
    void onFunzioniAggiuntive(@BindingParam("idParent") ETipoPratica tipoPratica, @BindingParam("archivio") String archivio) {

        switch (archivio) {
            case 'ACC':
                apriDettaglio("/restrict/anagrafe/pratiche/recuperoEsitoAccertamentiLista.zul", [:])
                break
            default: //Web o Anpr
                Map params = [archivio: archivio]
                apriDettaglio("/restrict/anagrafe/pratiche/recuperoPraticheLista.zul", params)
        }
    }

    @Command void onEsportaCsv() {
        esporta(ETipoFile.CSV)
    }

    @Command void onEsportaExcel() {
        esporta(ETipoFile.XLS)
    }

    void esporta(ETipoFile tipo){

        if ( (tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV) ) {
            onRicarica()
            if ((lista == null) || (lista.isEmpty())) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                return
            }

            Paginazione p = eseguiQuery(Boolean.FALSE)
            List<AnaDichiarante> listaExport = p.lista

            if ((listaExport == null) || (listaExport.isEmpty())) {
                return
            }

            List<ExportField> exportFields = []

            exportFields.add(new ExportField("archivioAnagrafe", getEtichetta(Etichette.getEtichetta("Archivio_Anagrafe")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))
            exportFields.add(new ExportField("tipoPratica", getEtichetta(Etichette.getEtichetta("Tipo_Pratica")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))

            exportFields.add(new ExportField("pratica.data", getEtichetta(Etichette.getEtichetta("Data_Pratica")), ExportUtils.DATE_FORMAT, calcolaValoreExportAnnidato))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("annoPratica", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.STRING_FORMAT))
            } else {
                exportFields.add(new ExportField("annoPratica", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.INTEGER_FORMAT))
            }
            exportFields.add(new ExportField("numeroPratica", getEtichetta(Etichette.getEtichetta("Numero")), ExportUtils.STRING_FORMAT, calcolaValoreExportNumeroProvvisorio))

            exportFields.add(new ExportField("cognome", getEtichetta(Etichette.getEtichetta("Cognome_Dichiarante_Pratica"))))
            exportFields.add(new ExportField("nome", getEtichetta(Etichette.getEtichetta("Nome_Dichiarante_Pratica"))))

            exportFields.add(new ExportField("pratica.descrizioneVariazione", getEtichetta(Etichette.getEtichetta("Codice_Variazione")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
            exportFields.add(new ExportField("pratica.statoPratica.descrizione", getEtichetta(Etichette.getEtichetta("Stato_Pratica")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("pratica.giorniMonitoraggio", getEtichetta(Etichette.getEtichetta("Giorni_Monitoraggio")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
            } else {
                exportFields.add(new ExportField("pratica.giorniMonitoraggio", getEtichetta(Etichette.getEtichetta("Giorni_Monitoraggio")), ExportUtils.INTEGER_FORMAT, calcolaValoreExportAnnidato))
            }

            exportFields.add(new ExportField("pratica.terminalista.cognomeNome", getEtichetta(Etichette.getEtichetta("Terminalista")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))

            exportFields.add(new ExportField("pratica.dataDecorrenza", getEtichetta(Etichette.getEtichetta("Data_Decorrenza")), ExportUtils.DATE_FORMAT, calcolaValoreExportAnnidato))


            ExportObject eo = new ExportObject("", exportFields, listaExport, null, null, csvCharsetName)
            InputStream exportStream = exportService.export(tipo, eo)
            Filedownload.save(exportStream, tipo.contentType, ExportService.buildFilename(msgTitle, tipo))

        }
    }


}
