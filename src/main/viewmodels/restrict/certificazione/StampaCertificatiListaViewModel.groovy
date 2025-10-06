package restrict.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.error.DataRiepilogoNonValidaException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.xel.fn.CommonFns
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.AbstractStampaListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaCertificatiListaViewModel extends AbstractStampaListaViewModel {

    RicercaCertificatoStampa ricerca

    List<CerTipoPagamento> listaTipoPagamento = []

    List<CerCertificatoEmesso> lista

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CerCertificatoEmessoStampaService cerCertificatoEmessoStampaService

    @WireVariable
    private CerTipoPagamentoService cerTipoPagamentoService

    @WireVariable
    private ExportService exportService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pagingEnabled = true
        excelExportEnabled = true
        csvExportEnabled = true
        pdfExportEnabled = true

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Certificazione, Etichette.Estrazioni, Etichette.Certificati_emessi]
        // Aggiungo etichette ordinamento
        eList.addAll([Etichette.Data_emissione_decrescente, Etichette.Data_emissione_crescente])
        // Aggiungo etichette domains
        eList.addAll(CerCertificatoEmesso.etichetteDomain)
        eList.addAll(CerTipoCertificato.etichetteDomain)
        // Aggiungo etichette ricerca
        eList.addAll(RicercaCertificatoStampa.etichetteRicercaCerDesc)
        eList.addAll(RicercaCertificatoStampaRiepilogo.etichetteRicercaCerStampaRiepilogoDesc)
        // Aggiungo etichette lista default
        eList.addAll(AbstractListaViewModel.etichetteListaDefault)
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        // Aggiungo etichette per messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_estrazione_certificati, EtichetteMessaggi.Warn_Data_Riepilogo_Non_Valida])
        // Aggiungo etichette per nome esportazione
        eList.addAll(Etichette.Data, Etichette.Dal, Etichette.Al)
        // Aggiungo etichette per report
        eList.addAll(Etichette.Totale_Riepilogo, Etichette.Totale_Diritti, Etichette.Totale_Tipo_Pagamento, Etichette.Totale_Generale, Etichette.ANNULLATO,
                Etichette.Totale_Certificati_Annullati, Etichette.Totale_Certificati_Validi, Etichette.Fondo_Cassa, Etichette.Totale_Cassa)
        doInit(eList)

        msgTitle = getEtichetta(Etichette.Certificazione)

        formLabel = msgTitle?.toUpperCase() + " (" + getEtichetta(Etichette.Estrazioni)?.toUpperCase() + ")"

        ricerca = new RicercaCertificatoStampa()

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.Data_emissione_decrescente), SortUtils.dataEmissioneDesc),
                           new OrderBy(getEtichetta(Etichette.Data_emissione_crescente), SortUtils.dataEmissioneAsc)])

        //Default: data emissione discendente
        selectedOrder = listaOrder[0]

        caricaListaTipiPagamento()
    }

    void caricaListaTipiPagamento() {
        listaTipoPagamento = [null] + cerTipoPagamentoService.listAll()
    }

    @Override
    void caricaLista() {
        try {
            ricerca.riepilogo.calculateDateRiepilogo()
        } catch (DataRiepilogoNonValidaException ex) {
            log.warn(ex.message, ex)
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, getEtichetta(ex.etichetta) ?: getEtichetta(EtichetteMessaggi.Warn_Data_Riepilogo_Non_Valida))
        } finally {
            refreshUi()
        }

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    private Map getParams(Boolean usePaging = false) {
        Map params = [activePage: (usePaging ? activePage : null), pageSize: (usePaging ? pageSize : null),
                      order     : selectedOrder?.campi]
        return params
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        Page<CerCertificatoEmesso> p = null
        try {
            PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
            p = cerCertificatoEmessoStampaService.listAllByRicercaCertificatoStampa(ricerca, pr)
        } catch (CampoMandatoryRuntimeException ex) {
            resetRicerca()
            Messagebox.show((getEtichetta(ex.getEtichetta()) ?: getEtichetta(EtichetteMessaggi.Compilare_campi_estrazione_certificati)), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onSelectTerminalista(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerTerminalista) {
            ricerca.terminalista = (CerTerminalista) event.getData()
        } else {
            ricerca.terminalista = null
        }
        onRicarica()
    }

    @Command
    void onSelectModalitaRilascio(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerModalitaRilascio) {
            ricerca.modalitaRilascio = (CerModalitaRilascio) event.getData()
        } else {
            ricerca.modalitaRilascio = null
        }
        onRicarica()
    }

    void esporta(ETipoFile tipo) {
        // Popolo la lista nella form
        onRicarica()
        if ((lista == null) || (lista.isEmpty())) {
            Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<CerCertificatoEmesso> listaExport = p?.lista as List<CerCertificatoEmesso>
        if ((listaExport == null) || (listaExport.isEmpty())) {
            return
        }

        List<ExportField> exportFields = []

        if (tipo in [ETipoFile.XLS, ETipoFile.CSV]) {
            exportFields.add(new ExportField("dataEmissione", getEtichetta(Etichette.Data_emissione), ExportUtils.DATE_FORMAT))
        } else {
            exportFields.add(new ExportField("dataEmissione", getEtichetta(Etichette.Data_emissione), ExportUtils.STRING_FORMAT, formateDateToString))
        }

        if (tipo == ETipoFile.XLS) {
            exportFields.add(new ExportField("progressivoEmissione", getEtichetta(Etichette.Progressivo_emissione), ExportUtils.INTEGER_FORMAT))
        } else {
            exportFields.add(new ExportField("progressivoEmissione", getEtichetta(Etichette.Progressivo_emissione), ExportUtils.STRING_FORMAT, formatIntegerToString))
        }

        if(tipo in [ETipoFile.XLS, ETipoFile.CSV]) {
            exportFields.add(new ExportField("annullato", getEtichetta(Etichette.Annullato), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.annullato ? ETipoSN.S.toString() : ETipoSN.N.toString() }))
        } else {
            exportFields.add(new ExportField("annullato", getEtichetta(Etichette.Annullato), ExportUtils.STRING_FORMAT, formatBooleanToString))
        }

        exportFields.add(new ExportField("tipoCertificato", getEtichetta(Etichette.Descrizione), ExportUtils.STRING_FORMAT, getDescrizione))
        exportFields.add(new ExportField("nominativoBeneficiario", getEtichetta(Etichette.Beneficiario), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.beneficiario?.cognomeNome ?: '' }))

        if (tipo == ETipoFile.XLS) {
            exportFields.add(new ExportField("segreteria", getEtichetta(Etichette.Diritti_segreteria_abbr), ExportUtils.NUMBER_FORMAT))
            exportFields.add(new ExportField("statoCivile", getEtichetta(Etichette.Diritti_stato_civile_abbr), ExportUtils.NUMBER_FORMAT))
            exportFields.add(new ExportField("cartaIdentita", getEtichetta(Etichette.Diritti_carta_identita_abbr), ExportUtils.NUMBER_FORMAT))
            exportFields.add(new ExportField("rimborsoStampati", getEtichetta(Etichette.Rimborso_stampati_abbr), ExportUtils.NUMBER_FORMAT))
            exportFields.add(new ExportField("bollo", getEtichetta(Etichette.Bollo), ExportUtils.NUMBER_FORMAT))
            exportFields.add(new ExportField("totale", getEtichetta(Etichette.Totale), ExportUtils.NUMBER_FORMAT))
        } else {
            exportFields.add(new ExportField("segreteria", getEtichetta(Etichette.Diritti_segreteria_abbr), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
            exportFields.add(new ExportField("statoCivile", getEtichetta(Etichette.Diritti_stato_civile_abbr), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
            exportFields.add(new ExportField("cartaIdentita", getEtichetta(Etichette.Diritti_carta_identita_abbr), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
            exportFields.add(new ExportField("rimborsoStampati", getEtichetta(Etichette.Rimborso_stampati_abbr), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
            exportFields.add(new ExportField("bollo", getEtichetta(Etichette.Bollo), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
            exportFields.add(new ExportField("totale", getEtichetta(Etichette.Totale), ExportUtils.STRING_FORMAT, formatBigDecimalToString))
        }

        Map reportParams = [:]
        if (tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("tipoPagamento", getEtichetta(Etichette.Tipo_pagamento), ExportUtils.STRING_FORMAT, getDescrizione))
            exportFields.add(new ExportField("modalitaRilascio", getEtichetta(Etichette.Modalita_rilascio), ExportUtils.STRING_FORMAT, getDescrizione))
            exportFields.add(new ExportField("nominativoBeneficiario", getEtichetta(Etichette.Beneficiario), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.beneficiario?.cognomeNome ?: '' }))
            exportFields.add(new ExportField("codiceFiscaleBeneficiario", getEtichetta(Etichette.Codice_Fiscale), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.beneficiario?.codiceFiscale ?: '' }))
            exportFields.add(new ExportField("nominativoRichiedente", getEtichetta(Etichette.Richiedente), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.richiedente?.cognomeNome ?: '' }))
            exportFields.add(new ExportField("codiceFiscaleRichiedente", getEtichetta(Etichette.Codice_Fiscale), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.richiedente?.codiceFiscale ?: '' }))
            exportFields.add(new ExportField("dataNascitaRichiedente", getEtichetta(Etichette.Data_Nascita), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.richiedente?.dataNascita == null ? '' : DataUtils.fromDateToString(it?.richiedente?.dataNascita as Date) }))
            exportFields.add(new ExportField("noteAnnullamento", getEtichetta(Etichette.Note_Annullamento), ExportUtils.STRING_FORMAT))

            DirittiRiepilogoReport totRiepilogo = cerCertificatoEmessoStampaService.getDirittiRiepilogoByRicercaCertificatoStampa(ricerca)

            DirittiReport totDiritti = cerCertificatoEmessoStampaService.getDirittiByRicercaCertificatoStampa(ricerca)

            DirittiReport totGenerale = null
            if (totRiepilogo != null) {
                totGenerale = DirittiReport.sum(totDiritti, totRiepilogo)
            }

            List<DirittiTipoPagamentoReport> totTipoPagamentoList = cerCertificatoEmessoStampaService.getDirittiTipoPagamentoByRicercaCertificatoStampa(ricerca)


            FondoCassaReport fondoCassa = null
            if (ricerca.stampaFondoCassa) {
                fondoCassa = cerCertificatoEmessoStampaService.getFondoCassaByRicercaCertificatoStampaAndDiritti(ricerca, totDiritti)
            }

            reportParams = [ENTE                        : statoCivileService.getComuneCliente().getDescrizioneComune(),
                            TITOLO                      : getEtichetta(Etichette.Certificati_emessi),
                            PARAMETRI                   : buildRicercaLabel(ricerca.getLabelBuilderParams()),
                            ANNULLATO                   : "*** ${getEtichetta(Etichette.ANNULLATO)} ***",
                            RIEPILOGO: ricerca.riepilogo.stampaRiepilogo,
                            ESCLUDI_ANNULLATI           : ricerca.escludiAnnullati,
                            TOTALE_CERTIFICATI_ANNULLATI: "Certificati Annullati",
                            TOTALE_CERTIFICATI_VALIDI   : "Certificati Validi",
                            TOTALE_RIEPILOGO            : getEtichetta(Etichette.Totale_Riepilogo),
                            TOTALE_DIRITTI              : getEtichetta(Etichette.Totale_Diritti),
                            TOTALE_TIPOPAGAMENTO        : getEtichetta(Etichette.Totale_Tipo_Pagamento),
                            TOTALE_GENERALE             : getEtichetta(Etichette.Totale_Generale),
                            FONDO_CASSA           : getEtichetta(Etichette.Fondo_Cassa),
                            TOTALE_CASSA          : getEtichetta(Etichette.Totale_Cassa),
                            TERMINALISTA_OBJECT         : ricerca.terminalista,
                            TOTALE_RIEPILOGO_OBJECT     : totRiepilogo,
                            TOTALE_DIRITTI_OBJECT       : totDiritti,
                            TOTALE_TIPOPAGAMENTO_OBJECT : totTipoPagamentoList,
                            TOTALE_GENERALE_OBJECT: totGenerale,
                            FONDO_CASSA_OBJECT    : fondoCassa]
        }

        StringBuilder filename = new StringBuilder(msgTitle)
        filename.append(getNomeFileXData(getEtichetta(Etichette.Data), ricerca.dataEmissioneDal, ricerca.dataEmissioneAl))

        ExportObject eo = new ExportObject("stampa_certificati", exportFields, listaExport, reportParams, null, csvCharsetName)

        exportService.export(tipo, eo, filename.toString())
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    Closure<?> formatBooleanToString = { def e, String propertyName ->
        def out = e?."$propertyName"
        if (out == null) {
            return ""
        }
        if (!(out instanceof Boolean)) {
            return ""
        }
        return String.valueOf(out as Boolean)
    }

    Closure<?> formatIntegerToString = { def e, String propertyName ->
        def out = e?."$propertyName"
        if (out == null) {
            return ""
        }
        if (!(out instanceof Integer)) {
            return ""
        }
        return String.valueOf(out as Integer)
    }

    Closure<?> formateDateToString = { def e, String propertyName ->
        def out = e?."$propertyName"
        if (out == null) {
            return ""
        }
        if (!(out instanceof Date)) {
            return ""
        }
        return DataUtils.fromDateToString(out as Date)
    }

    Closure<?> formatBigDecimalToString = { def e, String propertyName ->
        def out = e?."$propertyName"
        if (out == null) {
            return ""
        }
        if (!(out instanceof BigDecimal)) {
            return ""
        }
        return CommonFns.formatNumber(out as BigDecimal, '#,##0.00')
    }

    Closure<?> getDescrizione = { def e, String propertyName ->
        def parent = e?."$propertyName"
        if (parent == null) {
            return ""
        }
        def out = parent.descrizione
        if (out == null) {
            return ""
        }
        if (!out instanceof String) {
            return ""
        }
        return out as String
    }

    private String buildRicercaLabel(List<Map> params) {
        StringBuilder b = new StringBuilder("")
        params.eachWithIndex { param, i ->
            b.append(getEtichetta(param.etichetta as Map<String, String>))
            b.append(": ")
            if (param.isRange) {
                b.append(getEtichetta(param.etichettaFrom as Map<String, String>))
                b.append(" ")
                b.append(DataUtils.toString(param.fromDate))
                b.append(" ")
                b.append(getEtichetta(param.etichettaTo as Map<String, String>))
                b.append(" ")
                b.append(DataUtils.toString(param.toDate))
            } else {
                b.append(param.value)
            }
            if (i < params.size() - 1) {
                if (param.isRangeStart) {
                    b.append(" ")
                } else {
                    b.append(" - ")
                }
            }
        }
        return b.toString()
    }

}