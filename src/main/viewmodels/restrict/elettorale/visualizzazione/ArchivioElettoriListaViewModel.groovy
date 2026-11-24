package restrict.elettorale.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.elettorale.*
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
class ArchivioElettoriListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi, TraitStampaCampi {

    List<EleArchivio> lista
    EleArchivio dettaglio

    RicercaElettore ricercaElettore

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<EStatoElettore> listaStatiElettore = [null] + EStatoElettore.values().toList()

    List<EleTipoLista> listaTipoLista
    List<ETipoSiNo> listaTipoGiacenza = [null] + ETipoSiNo.values().toList()

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<Map<String, String>> filtriList = []

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private EleArchivioService eleArchivioService
    @WireVariable
    private EleTipoListaService eleTipoListaService
    @WireVariable
    protected ArcParametroService arcParametroService
    @WireVariable
    private ExportService exportService


    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    String csvCharsetName

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        backEnabled = false
        modifyEnabled = false
        addEnabled = false
        filtriExtraEnabled = true
        csvExportEnabled = true
        excelExportEnabled = true

        caricaTipiLista()

        List<Map<String, String>> eList = [Etichette.getEtichetta("Archivio_Elettori")]

        // Aggiungo etichette standard
        eList.addAll(etichetteListaDefault)
        // Aggiungo etichette domain
        eList.addAll(EleArchivio.etichetteDomain)
        // Aggiungo etichette ricerca
        eList.addAll(RicercaElettore.etichetteRicercaDesc)

        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll(EStatoElettore.values()*.getEtichettaDesc())
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        eList.addAll([Etichette.getEtichetta("Ordina_per"), Etichette.getEtichetta("Generalita_decrescente"), Etichette.getEtichetta("Generalita_crescente"),
                      Etichette.getEtichetta("Stampa_Lista_Generale"), Etichette.getEtichetta("Stampa_Lista_Sezionale"),
                      Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Stampa_Estratto_Sezionale"), Etichette.getEtichetta("Nessun_record_trovato")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)


        msgTitle = getEtichetta(Etichette.getEtichetta("Archivio_Elettori"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        filtriList = [[codice: "GENERALE", descrizione: getEtichetta(Etichette.getEtichetta("Stampa_Lista_Generale"))],
                      [codice: "SEZIONALE", descrizione: getEtichetta(Etichette.getEtichetta("Stampa_Lista_Sezionale"))],
                      [codice: "ESTRATTO_SEZIONALE", descrizione: getEtichetta(Etichette.getEtichetta("Stampa_Estratto_Sezionale"))]
        ]

        ricercaElettore = new RicercaElettore()

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_crescente")), SortUtils.cognomeNomeAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_decrescente")), SortUtils.cognomeNomeDesc)])

        selectedOrder = listaOrder[0]
        resize()

        csvCharsetName = arcParametroService.getCsvCharsetName()
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

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        Page p = eleArchivioService.listAllByRicercaElettore(ricercaElettore, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(ricercaElettore, p)
        resetRicerca()
    }

    @Command
    void onFiltriPlus(@BindingParam("codice") String codice) {
        switch (codice) {
            case "GENERALE":
                apriDettaglio("visualizzazione/stampaListaGenerale.zul", [:])
                break
            case "SEZIONALE":
                apriDettaglio("visualizzazione/stampaListaSezionale.zul", [:])
                break
            case "ESTRATTO_SEZIONALE":
                apriDettaglio("visualizzazione/stampaEstrattoListaSezionale.zul", [:])
                break
        }
    }

    private void caricaTipiLista() {
        listaTipoLista = [null] + eleTipoListaService.findAll()
    }

    @Command
    void onEsportaCsv() {
        esporta(ETipoFile.CSV)
    }

    @Command
    void onEsportaExcel() {
        esporta(ETipoFile.XLS)
    }

    void esporta(ETipoFile tipo) {

        if ((tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV)) {
            onRicarica()
            if ((lista == null) || (lista.isEmpty())) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                return
            }

            Paginazione p = eseguiQuery(Boolean.FALSE)
            List<EleArchivio> listaExport = p.lista

            if ((listaExport == null) || (listaExport.isEmpty())) {
                return
            }

            List<ExportField> exportFields = []

            exportFields.add(new ExportField("tipoLista.descrizioneBreve", getEtichetta(Etichette.getEtichetta("Tipo_Lista")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))

            exportFields.add(new ExportField("cognome", getEtichetta(Etichette.getEtichetta("Cognome")), ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("nome", getEtichetta(Etichette.getEtichetta("Nome")), ExportUtils.STRING_FORMAT))

            exportFields.add(new ExportField("sesso", getEtichetta(Etichette.getEtichetta("Sesso")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))
            exportFields.add(new ExportField("stato", getEtichetta(Etichette.getEtichetta("Stato")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("fascicolo", getEtichetta(Etichette.getEtichetta("Fascicolo")), ExportUtils.STRING_FORMAT))
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.STRING_FORMAT))
                exportFields.add(new ExportField("sezione", getEtichetta(Etichette.getEtichetta("Sezione")), ExportUtils.STRING_FORMAT))
                exportFields.add(new ExportField("progressivoGenerale", getEtichetta(Etichette.getEtichetta("Progressivo_Generale")), ExportUtils.STRING_FORMAT))
                exportFields.add(new ExportField("progressivoSezionale", getEtichetta(Etichette.getEtichetta("Progressivo_Sezionale")), ExportUtils.STRING_FORMAT))
                exportFields.add(new ExportField("tessera", getEtichetta(Etichette.getEtichetta("Tessera")), ExportUtils.STRING_FORMAT))
            } else {
                exportFields.add(new ExportField("fascicolo", getEtichetta(Etichette.getEtichetta("Fascicolo")), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("sezione", getEtichetta(Etichette.getEtichetta("Sezione")), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("progressivoGenerale", getEtichetta(Etichette.getEtichetta("Progressivo_Generale")), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("progressivoSezionale", getEtichetta(Etichette.getEtichetta("Progressivo_Sezionale")), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("tessera", getEtichetta(Etichette.getEtichetta("Tessera")), ExportUtils.INTEGER_FORMAT))
            }

            exportFields.add(new ExportField("flagGiacenza", getEtichetta(Etichette.getEtichetta("Giacenza")), ExportUtils.STRING_FORMAT, calcolaValoreExportFlag))
            exportFields.add(new ExportField("dataTessera", getEtichetta(Etichette.getEtichetta("Data_Tessera")), ExportUtils.DATE_FORMAT))


            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("matricola", getEtichetta(Etichette.getEtichetta("Matricola")), ExportUtils.STRING_FORMAT))
            } else {
                exportFields.add(new ExportField("matricola", getEtichetta(Etichette.getEtichetta("Matricola")), ExportUtils.INTEGER_FORMAT))
            }


            ExportObject eo = new ExportObject("", exportFields, listaExport, null, null, csvCharsetName)
            InputStream exportStream = exportService.export(tipo, eo)
            Filedownload.save(exportStream, tipo.contentType, ExportService.buildFilename(msgTitle, tipo))

        }
    }
}
