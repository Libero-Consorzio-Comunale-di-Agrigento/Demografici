package restrict.statocivile.dizionari

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class FormulaListaParentViewModel extends DizionarioListaViewModel {

    List lista

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    protected List<ETipoAnnotazione> listaTipoAnnotazione = []
    List<ETipoOrdinamentoAnnotazione> listaTipoOrdinamento
    ETipoOrdinamentoAnnotazione tipoOrdinamentoSelezionato

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarAnnotazioniAttributes cbAnnList = new ControlBarAnnotazioniAttributes()

    void doInit(Window w, List<Map<String, String>> eList) {

        self = w

        pagingAnnotazioneEnabled = true
        searchAnnotazioneEnabled = true

        eList += [Etichette.Formula_crescente, Etichette.Formula_decrescente, Etichette.Funzione_non_abilitata]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])

        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette della Controlbar specifica
        eList.addAll(ControlBarAnnotazioniAttributes.etichetteCbAnnListDesc)

        // Aggiungo etichette tipi annotazione
        eList.addAll(listaTipoAnnotazione*.getEtichettaDesc())

        // Aggiungo etichette tipo ordinamento
        listaTipoOrdinamento = Arrays.asList(ETipoOrdinamentoAnnotazione.values())
        eList.addAll(listaTipoOrdinamento*.etichettaDesc)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInitEtichette(eList)

        totalSizeLabel = ""

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Formula_crescente),   SortUtils.formulaAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Formula_decrescente), SortUtils.formulaDesc))

        //Default: formula crescente
        selectedOrder = listaOrder[0]

        resize()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    @Command void onSelectTipoOrdinamento(){
        onRicarica()
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    @Command void onInserisci() {
        if (addAnnotazioneEnabled && userModifyEnabled) {
            if (tipoAttoEnum != null) {
                apriDettaglio(getUriDettaglio(), [tipoAttoEnum:tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
