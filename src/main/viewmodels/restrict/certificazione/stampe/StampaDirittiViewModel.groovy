package restrict.certificazione.stampe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.certificazione.CerDettaglioIncassoService
import it.finmatica.de4gsdzk.certificazione.CerStatisticaCertificatoEmessoService
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamento
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamentoService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractCommonViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaDirittiViewModel extends AbstractCommonViewModel {

    Date dal
    Date al
    private Map<Integer, String> labelPagamento

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private CerTipoPagamentoService cerTipoPagamentoService
    @WireVariable
    private CerDettaglioIncassoService cerDettaglioIncassoService
    @WireVariable
    private CerStatisticaCertificatoEmessoService cerStatisticaCertificatoEmessoService
    @WireVariable
    private ExportService exportService
    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private GsdService gsdService

    private static final List<ExportField> EXPORT_FIELDS = [
            new ExportField("tipoDato", "Tipo Dato", ExportUtils.STRING_FORMAT),
            new ExportField("descrizione", "Descrizione", ExportUtils.STRING_FORMAT),
            new ExportField("certificatiEmessi", "Certificati Emessi", ExportUtils.INTEGER_FORMAT),
            new ExportField("totale", "Totale", ExportUtils.NUMBER_FORMAT),
            new ExportField("contanti", "Contanti", ExportUtils.NUMBER_FORMAT),
            new ExportField("pos", "POS", ExportUtils.NUMBER_FORMAT),
            new ExportField("pagopa", "PagoPA", ExportUtils.NUMBER_FORMAT),
            new ExportField("mastercard", "Mastercard", ExportUtils.NUMBER_FORMAT),
            new ExportField("tipoPagamento5", "tipoPagamento5", ExportUtils.NUMBER_FORMAT),
            new ExportField("differito", "Differito", ExportUtils.NUMBER_FORMAT),
            new ExportField("altro", "Altro", ExportUtils.NUMBER_FORMAT),
            new ExportField("dirittiSegreteria", "Diritti Segreteria", ExportUtils.NUMBER_FORMAT),
            new ExportField("dirittiStatoCivile", "Diritti Stato Civile", ExportUtils.NUMBER_FORMAT),
            new ExportField("dirittiCartaIdentita", "Diritti Carta Identità", ExportUtils.NUMBER_FORMAT),
            new ExportField("rimborsoStampati", "Rimborso Stampati", ExportUtils.NUMBER_FORMAT),
            new ExportField("diversi1", "Diversi 1", ExportUtils.NUMBER_FORMAT),
            new ExportField("diversi2", "Diversi 2", ExportUtils.NUMBER_FORMAT),
            new ExportField("bolli", "Bolli", ExportUtils.NUMBER_FORMAT)
    ]

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pagingEnabled = false
        pdfExportEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Stampa_Diritti")]
        eList.addAll([Etichette.getEtichetta("Data"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al")])
        eList.addAll([Etichette.getEtichetta("Errore_Operazione_non_consentita"), Etichette.getEtichetta("Compilare_campi_obbligatori"), Etichette.getEtichetta("Nessun_record_trovato")])


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Stampa_Diritti"))

        formLabel = msgTitle?.toUpperCase()

        labelPagamento = cerTipoPagamentoService.listAll()
                .collectEntries { [(it.id): it.descrizione?.toUpperCase()] }


    }

    @Command
    void onEsportaPDF() {

        if (dal == null || al == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }

        // Caricamento dettagli incassi (prima tabella)
        List<Map<String, Object>> listaExport = cerDettaglioIncassoService.findAllDettaglioIncasso(dal, al)

        // Caricamento dettagli terminalisti (seconda tabella)
        List<Map<String, Object>> dettaglioTerminalisti = cerStatisticaCertificatoEmessoService.findAllDettaglioTerminalisti(dal, al)

        listaExport.addAll(dettaglioTerminalisti)

        if ( listaExport.isEmpty() ) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Map reportParams = [
                ENTE                     : gsdService.getComuneCliente().getDescrizioneComune(),
                DAL                      : dal.format("dd/MM/yyyy"),
                AL                       : al.format("dd/MM/yyyy"),
                TOTALE_CERTIFICATI_EMESSI: dettaglioTerminalisti.sum { it.certificatiEmessi ?: 0 } as Integer,
                CONTANTI_LABEL           : labelPagamento[CerTipoPagamento.ID_CONTANTI],
                POS_LABEL                : labelPagamento[CerTipoPagamento.ID_POS],
                PAGOPA_LABEL             : labelPagamento[CerTipoPagamento.ID_PAGOPA],
                MASTERCARD_LABEL         : labelPagamento[CerTipoPagamento.ID_MASTERCARD],
                TIPO_PAGAMENTO5_LABEL    : labelPagamento[CerTipoPagamento.ID_TIPO_PAGAMENTO_5],
                DIFFERITO_LABEL          : labelPagamento[CerTipoPagamento.ID_DIFFERITO],
                ALTRO_LABEL              : labelPagamento[CerTipoPagamento.ID_ALTRO]
        ]

        StringBuilder filename = new StringBuilder("Diritti_${dal.format('dd-MM-yyyy')}_${al.format('dd-MM-yyyy')}")

        ExportObject eo = new ExportObject("stampa_diritti", EXPORT_FIELDS, listaExport, reportParams, null, null)

        InputStream exportStream = exportService.export(ETipoFile.PDF, eo)
        Filedownload.save(exportStream, ETipoFile.PDF.contentType, ExportService.buildFilename(filename.toString(), ETipoFile.PDF))
    }

    @Command
    void onCancellaCampo() {
        dal = null
        al = null
        refreshUi()
    }

    @Command
    void onBackFromList() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }
}