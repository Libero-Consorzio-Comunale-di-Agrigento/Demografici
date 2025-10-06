package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.ISoggettoAtto1
import it.finmatica.de4gsdzk.ISoggettoAtto2
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.export.ExportUtils.INTEGER_FORMAT
import static it.finmatica.de4gsdzk.export.ExportUtils.STRING_FORMAT

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaIndiciListaViewModel extends AbstractStampaAttiListaViewModel {

    ETipoAtto tipoAttoEnum

    List<CivAttoBaseDomain> lista

    List<ETipoEvento> listaTipiEvento

    List<Integer> listaUffici

    final List<ETipoMargineLaterale> listaMargineLaterale = ETipoMargineLaterale.values().toList()
    ETipoMargineLaterale tipoMargineLateraleSelezionato

    final List<ETipoOrdinamentoIndice> listaTipiOrdinamentoIndice = ETipoOrdinamentoIndice.values().toList()
    ETipoOrdinamentoIndice tipoOrdinamentoIndiceSelezionato

    ETipoIndice tipoIndiceEnum

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private ExportService exportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window window, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum, @ExecutionArgParam("tipoIndiceEnum") ETipoIndice tipoIndiceEnum) {

        self = window

        backFromListEnabled = true
        pagingEnabled = true
        excelExportEnabled = true
        csvExportEnabled = true
        pdfExportEnabled = ((tipoAttoEnum != ETipoAtto.PVU) && (tipoAttoEnum != ETipoAtto.PUB))

        this.tipoAttoEnum = tipoAttoEnum
        this.tipoIndiceEnum = tipoIndiceEnum

        List<Map<String, String>> eList = [Etichette.CONSOLIDATO, Etichette.IN_INSERIMENTO, Etichette.Generalita_crescente,
                                           Etichette.Stato, Etichette.Dal, Etichette.Al,
                                           Etichette.Margine, Etichette.Estremi_Atto, Etichette.Tutti_gli_uffici,
                                           Etichette.Tipo, Etichette.Numero, Etichette.Atto]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Errore_funzionalita_export, EtichetteMessaggi.Compilare_campi_obbligatori])
        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)
        eList.addAll(CivNascita.etichetteDomain)
        eList.addAll(CivMorte.etichetteDomain)
        eList.addAll(CivMatrimonio.etichetteDomain)
        eList.addAll(CivUnioneCivile.etichetteDomain)
        eList.addAll(CivCittadinanza.etichetteDomain)

        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        // Aggiungo etichette tipo indice
        eList.addAll(Arrays.asList(ETipoIndice.values())*.etichettaDesc)

        // Aggiungo etichette tipo margine
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        // Aggiungo etichette tipo ordinamento
        eList.addAll(Arrays.asList(ETipoOrdinamentoIndice.values())*.etichettaDesc)
        tipoOrdinamentoIndiceSelezionato = ETipoOrdinamentoIndice.EN

        listaTipiEvento = [null]
        if (tipoAttoEnum == ETipoAtto.MAT){
            listaTipiEvento.addAll([ETipoEvento.Matrimoni, ETipoEvento.Divorzi])
            eList.addAll([ETipoEvento.Matrimoni.etichettaDesc, ETipoEvento.Divorzi.etichettaDesc])
        }
        if (tipoAttoEnum == ETipoAtto.UCI) {
            listaTipiEvento.addAll([ETipoEvento.Unioni_Civili, ETipoEvento.Scioglimenti])
            eList.addAll([ETipoEvento.Unioni_Civili.etichettaDesc, ETipoEvento.Scioglimenti.etichettaDesc])
        }

        doInit(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(tipoAttoEnum.etichettaPluralDesc)

        formLabel = msgTitle?.toUpperCase() + " (" + getEtichettaEnum(tipoIndiceEnum)?.toUpperCase() + ")"

        listaUffici = statoCivileService.listUffici()
        ricerca = new RicercaAttoStampa(tipoAttoEnum, EStatoAtto.CONSOLIDATO, Boolean.TRUE, anscOn)
        if (listaUffici.size() == 1){
            ricerca.ufficio = listaUffici[0]
        }
        listaUffici.add(0, null)

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),    SortUtils.cognomeNome1ListaAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),    SortUtils.cognomeNome2ListaAsc))

        selectedOrder = listaOrder[0]
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    private Map getParams(Boolean usePaging=false) {
        //Gestire solo i consolidati
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       stato: EStatoAtto.CONSOLIDATO, ufficio: ricercaAttoStampa.ufficio,
                       escludiAnnullati: ricercaAttoStampa.escludiAnnullati, escludiANSC: ricercaAttoStampa.escludiANSC,
                       annoDa: ricercaAttoStampa.annoDa, annoA: ((tipoIndiceEnum== ETipoIndice.A)?ricercaAttoStampa.annoDa:ricercaAttoStampa.annoA),
                       order : ((tipoOrdinamentoIndiceSelezionato == ETipoOrdinamentoIndice.F_C2)?listaOrder[1]?.campi:selectedOrder?.campi)]
        return params
    }

    Paginazione<CivAttoBaseDomain> eseguiQuery(Boolean usePaging){
        Page<CivAttoBaseDomain> p = null
        try {
            Map customMandatoryParams = getCustomMandatoryParams()
            p = civAttoService.search(tipoAttoEnum, getParams(usePaging), customMandatoryParams)
        } catch (CampoMandatoryRuntimeException ex) {
            resetRicerca()
            Messagebox.show(getEtichetta(ex.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione<>((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    private Map<String, ?> getCustomMandatoryParams(){
        Map<String, ?> cmp = new HashMap<String, ?>()
        cmp.put("anno", ((RicercaAttoStampa) ricerca).annoDa )
        cmp.put("ufficio", ((RicercaAttoStampa) ricerca).ufficio )
        return cmp
    }

    void esporta(ETipoFile tipo) {

        if ( ((tipoAttoEnum == ETipoAtto.PVU) || (tipoAttoEnum == ETipoAtto.PUB)) && (tipo == ETipoFile.PDF) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_funzionalita_export), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }

        if ( (tipo == ETipoFile.PDF) && (tipoMargineLateraleSelezionato == null) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_obbligatori), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }

        // Popolo la lista nella form
        onRicarica()
        if ( (lista == null) || (lista.isEmpty()) ){
            Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Paginazione<CivAttoBaseDomain> p = eseguiQuery(Boolean.FALSE)

        if (p?.lista == null || p?.lista?.isEmpty()) {
            return
        }

        List<IndiciAtti> listaTemp = []
        List<IndiciAtti> listaNoCognome = []
        for (CivAttoBaseDomain e : p.lista) {
            String c1 = ((ISoggettoAtto1)e).getCognome1Lista()
            String n1 = ((ISoggettoAtto1)e).getNome1Lista()
            String c2 = null
            String n2 = null
            // Se nascita(riconoscimento prenatale), morte(cadavere senza generalità), cittadinanza(straniero con il solo nome)
            if (tipoAttoEnum.isSingoloSoggetto() && ((c1?:"") == "") ){
                listaNoCognome.add(new IndiciAtti(e.anno, e.atto, e.parte, e.serie, e.ufficio, (e.idAtto + "_" + ETipoOrdinamentoIndice.M_C1.name()), c1, n1, c2, n2))
                continue
            }
            if (e instanceof ISoggettoAtto2){
                c2 = ((ISoggettoAtto2)e).getCognome2Lista()
                n2 = ((ISoggettoAtto2)e).getNome2Lista()
            }
            if ( tipoAttoEnum.isDoppioSoggetto() && (tipoOrdinamentoIndiceSelezionato == ETipoOrdinamentoIndice.F_C2) && (e.natura != ENaturaAtto.N) ){
                listaTemp.add(new IndiciAtti(e.anno, e.atto, e.parte, e.serie, e.ufficio, (e.idAtto + "_" + ETipoOrdinamentoIndice.F_C2.name()), c2, n2, c1, n1))
            } else {
                listaTemp.add(new IndiciAtti(e.anno, e.atto, e.parte, e.serie, e.ufficio, (e.idAtto + "_" + ETipoOrdinamentoIndice.M_C1.name()), c1, n1, c2, n2))
                if ( tipoAttoEnum.isDoppioSoggetto() && tipoOrdinamentoIndiceSelezionato.isEntrambi() && (e.natura != ENaturaAtto.N) ){
                    listaTemp.add(new IndiciAtti(e.anno, e.atto, e.parte, e.serie, e.ufficio, (e.idAtto + "_" + ETipoOrdinamentoIndice.EN.name()), c2, n2, c1, n1))
                }
            }
        }
        listaTemp = listaTemp?.sort{(it.cognome1Lista.toUpperCase() + " " + (it.nome1Lista?:"").toUpperCase() + " " + (it.cognome2Lista?:"").toUpperCase() + " " + (it.nome2Lista?:"").toUpperCase())}

        List<IndiciAtti> listaExport = []

        // Aggiunge linea vuota al cambio di lettera
        String cia = listaTemp?.get(0)?.getCognome1Lista()
        char prevFirst = cia?.charAt(0)?.toUpperCase()
        for (IndiciAtti element : listaTemp) {
            cia = element.getCognome1Lista()
            char first = cia?.charAt(0)?.toUpperCase()
            if (first != prevFirst) {
                prevFirst = first
                listaExport.add(new IndiciAtti())
            }
            listaExport.add(element)
        }
        if (listaExport.size()> 0) {
            listaExport.add(new IndiciAtti())
            listaExport.addAll(listaNoCognome)
        }

        List<ExportField> exportFields = []

        exportFields.add(new ExportField("cognome1Lista", getEtichetta(Etichette.Cognome), STRING_FORMAT))
        exportFields.add(new ExportField("nome1Lista", getEtichetta(Etichette.Nome), STRING_FORMAT))

        if (tipoAttoEnum.isDoppioSoggetto()|| tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("cognome2Lista", getEtichetta(Etichette.Cognome)))
            exportFields.add(new ExportField("nome2Lista", getEtichetta(Etichette.Nome)))
        }

        if (tipo == ETipoFile.CSV) {
            exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), STRING_FORMAT, calcolaValoreExportStringFromInteger))
            exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero), STRING_FORMAT, calcolaValoreExportStringFromInteger))
        } else {
            exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), INTEGER_FORMAT))
            exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero), INTEGER_FORMAT))
        }

        if (ricercaAttoStampa.hasParte() || tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("parteRomana", tipo == ETipoFile.PDF ? "P." : getEtichetta(Etichette.Parte)))
        }
        if (ricercaAttoStampa.hasSerie() || tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("serie", tipo == ETipoFile.PDF ? "S." : getEtichetta(Etichette.Serie)))
        }

        exportFields.add(new ExportField("ufficio", getEtichetta(Etichette.Ufficio), INTEGER_FORMAT))

        if (tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("idAtto", getEtichetta(Etichette.Estremi_Atto)))
        }

        StringBuilder b = new StringBuilder(getEtichetta(tipoAttoEnum.etichettaPluralDesc))
        b.append("_")
        b.append(getEtichettaEnum(tipoIndiceEnum))
        String labelAnno = getNomeFileXAnno(getEtichetta(Etichette.Anno), ricercaAttoStampa.annoDa, ((tipoIndiceEnum== ETipoIndice.A)?ricercaAttoStampa.annoDa:ricercaAttoStampa.annoA))
        b.append(labelAnno)

        Map reportParams = [
            CORNICE_VISIBILE: corniceOn,
            TIPO_ATTO: tipoAttoEnum.getId(),
            TITOLO: getEtichettaEnum(tipoIndiceEnum),
            ATTO: getEtichetta(Etichette.Atto)
        ]

        Map reportOptions = [:]
        reportOptions.put(JasperReportUtils.OPTION_MIRROR_LAYOUT, (tipoMargineLateraleSelezionato == ETipoMargineLaterale.S? 1 : 0))
        reportOptions.put(JasperReportUtils.OPTION_MIRROR_MARGINS, true)

        ExportObject eo = new ExportObject("stampa_indici", exportFields, listaExport, reportParams, reportOptions, csvCharsetName)

        Map customMandatoryParams = getCustomMandatoryParams()
        if (tipo == ETipoFile.PDF) {
            customMandatoryParams.put("margine", tipoMargineLateraleSelezionato)
        }
        exportService.export(tipo, eo, b.toString(), customMandatoryParams)
    }

    boolean isAnnuale() { tipoIndiceEnum == ETipoIndice.A }

    void resetLista(){
        lista = []
        refreshLista()
    }

    @Command void onSelectTipoOrdinamento(){
        onRicarica()
    }

}
