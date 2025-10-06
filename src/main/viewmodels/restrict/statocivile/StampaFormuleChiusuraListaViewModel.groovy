package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.JasperReportService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import net.sf.jasperreports.engine.JREmptyDataSource
import org.springframework.data.domain.Page
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaFormuleChiusuraListaViewModel extends AbstractStampaAttiListaViewModel {

    List<Integer> listaUffici = []

    ETipoAtto tipoAttoEnum

    List<CivFormulaChiusura> listaFormule = []
    CivFormulaChiusura formulaSelezionata

    FormulaChiusuraAtti formulaChiusuraAtti = null

    RichiestaFormulaChiusura richiesta = null

    final List<ETipoMargineLaterale> listaMargineLaterale = ETipoMargineLaterale.values().toList()
    ETipoMargineLaterale tipoMargineLateraleSelezionato

    List<Integer> listaParte = []
    List<String> listaSerie  = []

    List<Map> stampaList = []

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivFormulaChiusuraService civFormulaChiusuraService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private JasperReportService jasperReportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window window, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {

        self = window

        backFromListEnabled = true
        selectStampaEnabled = ((tipoAttoEnum != ETipoAtto.PVU) && (tipoAttoEnum != ETipoAtto.PUB))

        this.tipoAttoEnum = tipoAttoEnum

        List<Map<String, String>> eList = [Etichette.Formule_Chiusura, Etichette.Margine, Etichette.Etichetta, Etichette.Foglio_Atto, Etichette.Numero,
                                           Etichette.Atto, Etichette.Numero_Atti, Etichette.Dal, Etichette.Al, Etichette.Del,
                                           Etichette.Autorita_Giudiziaria, Etichette.Ordinanza_del, Etichette.In_data, Etichette.restituzione]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_obbligatori, EtichetteMessaggi.Compilare_formula, EtichetteMessaggi.Errore_funzionalita_export])
        eList.addAll(RicercaAtto.etichetteRicercaDesc)
        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        // Aggiungo etichette tipo margine
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)

        doInit(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(tipoAttoEnum.etichettaPluralDesc)

        formLabel = msgTitle?.toUpperCase() + " (" + getEtichetta(Etichette.Formule_Chiusura)?.toUpperCase() + ")"

        listaParte = [null] + [new Integer(1), new Integer(2)]
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                listaSerie = [null] + [CivTipoAtto.SERIE_A, CivTipoAtto.SERIE_B]
                break
            case ETipoAtto.MOR:
                listaSerie = [null] + [CivTipoAtto.SERIE_A, CivTipoAtto.SERIE_B, "B BIS", CivTipoAtto.SERIE_C]
                break
            case ETipoAtto.MAT:
                listaSerie = [null] + [CivTipoAtto.SERIE_A, CivTipoAtto.SERIE_B, CivTipoAtto.SERIE_C]
                break
            case ETipoAtto.UCI:
                listaSerie = []
                break
            case ETipoAtto.PUB:
            case ETipoAtto.PVU:
            case ETipoAtto.CIT:
                listaParte = []
                break
        }

        ricerca = new RicercaAttoStampa(tipoAttoEnum, EStatoAtto.CONSOLIDATO, Boolean.TRUE, anscOn)

        caricaFormuleChiusura()

        caricaListaUffici()

        stampaList = []
        stampaList.add([codice: "ATTO", descrizione: getEtichetta(Etichette.Foglio_Atto)])
        stampaList.add([codice: "ETICHETTA", descrizione: getEtichetta(Etichette.Etichetta)])

        richiesta = new RichiestaFormulaChiusura("", "", null, null, null)

        resetRicerca()
    }

    protected void caricaFormuleChiusura(){
        listaFormule = civFormulaChiusuraService.listAllOrderById()
    }

    protected void caricaListaUffici(){
        listaUffici = [null] + statoCivileService.listUffici()
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<CivAttoBaseDomain> l = p.lista
        CivAttoBaseDomain attoMin = (l.isEmpty()?null:l.first())
        CivAttoBaseDomain attoMax = (l.isEmpty()?null:l.last())
        formulaChiusuraAtti = new FormulaChiusuraAtti(p.count, attoMin?.atto, attoMin?.dataRegistrazione, attoMax?.atto, attoMax?.dataRegistrazione )

        BindUtils.postNotifyChange(null, null, this, "formulaChiusuraAtti")
    }

    private Map getParams(Boolean usePaging=false) {
        //Gestire solo i consolidati
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       stato: EStatoAtto.CONSOLIDATO,
                       escludiAnnullati: ((RicercaAttoStampa) ricerca).escludiAnnullati, escludiANSC: ((RicercaAttoStampa) ricerca).escludiANSC,
                       annoDa: ((RicercaAttoStampa) ricerca).annoDa, annoA: ((RicercaAttoStampa) ricerca).annoDa,
                       ufficio: ricerca.ufficio, parte: ricerca.parte, serie: ricerca.serie,
                       order : SortUtils.annoAttoAsc]
        return params
    }

    Paginazione<CivAttoBaseDomain> eseguiQuery(Boolean usePaging){
        Page<CivAttoBaseDomain> p = null
        try {
            Map customMandatoryParams = getCustomMandatoryParams()
            p = civAttoService.search(tipoAttoEnum, getParams(usePaging), customMandatoryParams)
            if ( (p?.getContent()?:[]).isEmpty() ) {
                Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        } catch (CampoMandatoryRuntimeException ex) {
            resetRicerca()
            Messagebox.show(getEtichetta(ex.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione<>((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSelectStampa(@BindingParam("codice") String codice){
        if (codice == "ATTO"){
            esporta(ETipoFile.PDF)
        }
        if (codice == "ETICHETTA"){
            String testo = getTestoFormula()
            if (testo){
                Map reportOptions = [dataSource: new JREmptyDataSource()]

                Map customMandatoryParams = getCustomMandatoryParams()
                customMandatoryParams.put("data", richiesta.dataChiusura)

                jasperReportService.downloadReportCustom("etichetta_"+TestoUtils.formatoA4, "etichetta", [TESTO : testo], reportOptions, customMandatoryParams)
            }
        }
    }

    @Command void onSelectParte(){
        refreshUi()
    }

    Map<String, ?> getCustomMandatoryParams(){
        Map<String, ?> cmp = new HashMap<String, ?>()
        cmp.put("anno", ((RicercaAttoStampa) ricerca).annoDa )
        if (tipoAttoEnum.hasParte()) {
            cmp.put("parte", ((RicercaAttoStampa) ricerca).parte)
        }
        if (tipoAttoEnum.hasSerie()) {
            switch(tipoAttoEnum) {
                case ETipoAtto.NAS:
                    cmp.put("serie", (((RicercaAttoStampa) ricerca).serie?:null) )
                    break
                case ETipoAtto.MAT:
                case ETipoAtto.MOR:
                    if ( ((RicercaAttoStampa) ricerca).parte?.compareTo(new Integer(2)) == 0){
                        cmp.put("serie", (((RicercaAttoStampa) ricerca).serie?:null) )
                    }
                    break
            }
        }
        return cmp
    }

    String getTestoFormula(){
        String testo
        try{
            testo = statoCivileService.decodificaTestoFormulaChiusura(formulaSelezionata?.id, tipoAttoEnum.valore,
                    ((RicercaAttoStampa) ricerca).annoDa, ((RicercaAttoStampa) ricerca).parte, ((RicercaAttoStampa) ricerca).serie,
                    formulaChiusuraAtti, richiesta )
        } catch (CampoMandatoryRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return null
        }
        return testo
    }

    void esporta(ETipoFile tipo) {

        if ( ((tipoAttoEnum == ETipoAtto.PVU) || (tipoAttoEnum == ETipoAtto.PUB)) && (tipo == ETipoFile.PDF) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_funzionalita_export), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }

        String testo = getTestoFormula()
        if (testo) {
            StringBuilder b = new StringBuilder(getEtichetta(tipoAttoEnum.etichettaPluralDesc))
            b.append("_")
            b.append(getEtichetta(Etichette.Formule_Chiusura))
            String labelAnno = getNomeFileXAnno(getEtichetta(Etichette.Anno), ((RicercaAttoStampa) ricerca).annoDa, ((RicercaAttoStampa) ricerca).annoDa)
            b.append(labelAnno)

            String tipoAttoLabel = getEtichetta(tipoAttoEnum.etichettaPluralDesc).toUpperCase()
            StringBuilder d = new StringBuilder(tipoAttoLabel)
            if (tipoAttoEnum.hasParte() && (((RicercaAttoStampa) ricerca).parte != null)) {
                d.append(" - ")
                d.append(getEtichetta(Etichette.Parte).toUpperCase())
                d.append(TestoUtils.spazio)
                d.append(TestoUtils.getParteRomana(((RicercaAttoStampa) ricerca).parte.intValue()))
            }
            if (tipoAttoEnum.hasSerie() && ((((RicercaAttoStampa) ricerca).serie ?: "") != "")) {
                d.append(" - ")
                d.append(getEtichetta(Etichette.Serie).toUpperCase())
                d.append(TestoUtils.spazio)
                d.append(((RicercaAttoStampa) ricerca).serie)
            }

            Map reportParams = [
                    TESTO           : testo,
                    COGNOME         : "",
                    NOME            : "",
                    SESSO           : "",
                    COGNOME_CONIUGE : "",
                    NOME_CONIUGE    : "",
                    STATO           : "",
                    CORNICE_VISIBILE: corniceOn,
                    CAMPO1_LUNGO    : "",
                    CAMPO2_LUNGO    : "",

                    CODICE_TIPO_ATTO: getTipoAttoEnum().name(),
                    ESTREMI_ATTO    : d.toString(),
                    LABEL_COGNOME   : getEtichetta(Etichette.Cognome),
                    LABEL_NOME      : getEtichetta(Etichette.Nome),
                    LABEL_SESSO     : ""
            ]

            Map reportOptions = [:]
            reportOptions.put(JasperReportUtils.OPTION_DATASOURCE, new JREmptyDataSource())
            reportOptions.put(JasperReportUtils.OPTION_MIRROR_LAYOUT, (tipoMargineLateraleSelezionato == ETipoMargineLaterale.S ? 1 : 0))
            // refs #71088
            //reportOptions.put(JasperReportUtils.OPTION_MIRROR_MARGINS, true)

            Map customMandatoryParams = getCustomMandatoryParams()
            customMandatoryParams.put("margine", tipoMargineLateraleSelezionato)
            customMandatoryParams.put("data", richiesta.dataChiusura)

            jasperReportService.downloadReportCustom("stampa_atto_A4", b.toString(), reportParams, reportOptions, customMandatoryParams)
        }
    }

    @Override
    protected void resetRicerca(){
        formulaChiusuraAtti = new FormulaChiusuraAtti(0L, null, null, null, null)
        updateTotalSize(0L)
        refreshUi()
    }

    @Command void onCancellaCampoRichiesta(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")?.trim()
        if (p) {
            richiesta."$p" = null
            refreshUi()
        }
    }

}
