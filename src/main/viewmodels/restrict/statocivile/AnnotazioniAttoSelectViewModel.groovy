package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnnotazioniAttoSelectViewModel extends AbstractSelectViewModel{

    List<CivFormulaAnnotazione> lista
    CivFormulaAnnotazione dettaglio

    final List<ETipoAnnotazione> listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]

    final List<ETipoOrdinamentoAnnotazione> listaTipoOrdinamento = Arrays.asList(ETipoOrdinamentoAnnotazione.values())
    ETipoOrdinamentoAnnotazione tipoOrdinamentoSelezionato

    CivAttoBaseDomain atto

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    Boolean anscOn = Boolean.FALSE

    @Delegate
    ControlBarAnnotazioniAttributes cbAnnList = new ControlBarAnnotazioniAttributes()

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("atto") CivAttoBaseDomain atto) {
        self = w

        pagingAnnotazioneEnabled = true
        searchAnnotazioneEnabled = true
        selectTipoOrdinamentoEnabled = true

        addAnnotazioneEnabled = false
        modifyAnnotazioneEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("Formula_crescente"), Etichette.getEtichetta("Formula_decrescente"), Etichette.getEtichetta("Salva")]

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAnnotazioniAttributes.etichetteCbAnnListDesc)

        // Aggiungo etichette delle Annotazioni
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)
        eList.addAll(CivAnnotazioneAtto.etichetteDomain)

        // Aggiungo etichette sul tipo delle Annotazioni
        eList.addAll(ETipoAnnotazione.values()*.getEtichettaDesc())

        // Aggiungo etichette sul genere delle Annotazioni
        eList.addAll(Arrays.asList(EGenereAnnotazione.values())*.etichettaDesc)

        // Aggiungo etichette tipo annotazione
        eList.addAll(Arrays.asList(ETipoOrdinamentoAnnotazione.values())*.getEtichettaDesc())
        tipoOrdinamentoSelezionato = ETipoOrdinamentoAnnotazione.Nuovo_Ordinamento

        doInitEtichette(eList)

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        msgTitle = getEtichetta(Etichette.getEtichetta("Annotazioni"))
        totalSizeLabel = ""

        this.atto = atto

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Formula_crescente")),      SortUtils.formulaAsc) )
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Formula_decrescente")),    SortUtils.formulaDesc))

        //Default: formula crescente
        selectedOrder = listaOrder[0]

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Map params = [activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                      tipoAtto: atto.tipoAtto, tipiAnnotazione:listaTipoAnnotazione,
                      tipoOrdinamento: tipoOrdinamentoSelezionato, filtro: filtro, order: selectedOrder?.campi]

        Page<CivFormulaAnnotazione> p = civFormulaAnnotazioneService.list(params)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSelectTipoOrdinamento(){
        onRicarica()
    }

    @Command void onSalva() {
        if (dettaglio){
            Boolean stampaSuAtto = arcParametroService.iStampaAnnotazioneSuAttoAttiva()
            Boolean stampaSuEstratto = arcParametroService.iStampaAnnotazioneSuEstrattoAttiva()
            CivAnnotazioneAtto aa = civAnnotazioneAttoService.create(EStatoAnnotazione.E, stampaSuAtto, stampaSuEstratto)
            DomainUtils.initFromAtto(aa, atto)
            aa.formulaDfa = dettaglio
            aa.formula = aa.formulaDfa?.id
            aa.sequenza = civAnnotazioneAttoService.getMaxSequenzaByUkAtto(atto.idAtto)
            aa.testo = civFormulaAnnotazioneService.getTestoAnnotazioneDecodificato(aa.formulaDfa.id, atto)
            aa.genere = dettaglio.genere
            aa.flagSecretato = dettaglio.flagSecretato
            aa.flagIstat = dettaglio.flagIstat
            aa = civAnnotazioneAttoService.save(ETipoOperazione.INS, aa, atto)

            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [idAnnotazione: aa.id] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    boolean getCanSaveRecord() {
        return true
    }

}
