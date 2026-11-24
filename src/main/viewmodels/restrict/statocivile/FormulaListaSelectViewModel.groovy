package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
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
class FormulaListaSelectViewModel extends AbstractSelectViewModel{

    List<Map<String, Object>> lista = []
    List<Map<String, Object>> dettagli

    ETipoAtto tipoAttoEnum
    Integer richiamo
    Map params

    String tipoFormula

    private static final String TUTTE = "TU"
    private static final String DEFAULT = "DF"
    private static final String RICORRENTE = "RI"
    private static final String TESTO_FISSO = "TF"

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
               @ExecutionArgParam("richiamo") Integer richiamo, @ExecutionArgParam("params") Map params) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Formula"), Etichette.getEtichetta("Default"), Etichette.getEtichetta("Ricorrenti"), Etichette.getEtichetta("Testo_fisso"), Etichette.getEtichetta("Tutte")]
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Formula"))

        totalSizeLabel = ""

        this.tipoAttoEnum = tipoAttoEnum
        this.richiamo = richiamo
        this.params = params

        this.tipoFormula = TUTTE

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)

        params['flagDefault']    = (tipoFormula==DEFAULT)
        params['flagRicorrente'] = (tipoFormula==RICORRENTE)
        params['flagTestoFisso'] = (tipoFormula==TESTO_FISSO)
        params.filtro = filtro?.trim()

        List<Map<String, Object>> l = []
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                l = gsdService.listFormuleNascita(richiamo, params)
                break
            case ETipoAtto.MAT:
                if (params.divorzio){
                    l = gsdService.listFormuleDivorzio(richiamo, params)
                } else {
                    l = gsdService.listFormuleMatrimonio(richiamo, params)
                }
                break
            case ETipoAtto.PUB:
                l = gsdService.listFormulePubblicazione(richiamo, params)
                break
            case ETipoAtto.PVU:
                l = gsdService.listFormuleProcessoVerbale(richiamo, params)
                break
            case ETipoAtto.UCI:
                if (params.divorzio){
                    l = gsdService.listFormuleScioglimento(richiamo, params)
                } else {
                    l = gsdService.listFormuleUnioneCivile(richiamo, params)
                }
                break
            case ETipoAtto.MOR:
                l = gsdService.listFormuleDecesso(richiamo, params)
                break
            case ETipoAtto.CIT:
                l = gsdService.listFormuleCittadinanza(richiamo, params)
                break
        }

        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettagli = null
        refreshDettagli()
    }

    @Command void onSelectTipoFormula() {
        onRicarica()
    }

    @Command void onSeleziona() {
        if (dettagli){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, dettagli)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
