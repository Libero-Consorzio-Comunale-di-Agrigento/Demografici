package restrict.statocivile.rubricaNascite

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.CivRubricaNascite
import it.finmatica.de4gsdzk.statocivile.CivRubricaNasciteService
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
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RubricaNasciteListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    List<CivRubricaNascite> lista
    CivRubricaNascite dettaglio

    RicercaRubricaNascite ricerca

    List<Map<String, String>> filtriList = []

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable CivRubricaNasciteService civRubricaNasciteService

    @WireVariable GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        filtriExtraEnabled = true

        ricerca = new RicercaRubricaNascite()

        List<Map<String, String>> eList = [Etichette.getEtichetta("Rubrica_Nascite"), Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Cancella"),
                                           Etichette.getEtichetta("Data_Registrazione_decrescente"), Etichette.getEtichetta("Data_Registrazione_crescente"),
                                           Etichette.getEtichetta("Generalita_crescente"), Etichette.getEtichetta("Generalita_decrescente"),
                                           Etichette.getEtichetta("Data_Nascita_decrescente"), Etichette.getEtichetta("Data_Nascita_crescente"), Etichette.getEtichetta("Estrazioni")]
        eList.addAll(etichetteListaDefault)
        eList.addAll(RicercaRubricaNascite.etichetteRicercaRubricaDesc)
        eList.addAll(CivRubricaNascite.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Rubrica_Nascite"))

        formLabel = msgTitle?.toUpperCase()

        filtriList = [[codice: "ESTRAZIONE", descrizione: getEtichetta(Etichette.getEtichetta("Estrazioni"))]]

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_decrescente")), SortUtils.dataRegistrazioneDescOnly))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_crescente")),   SortUtils.dataRegistrazioneAscOnly))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_crescente")),           SortUtils.cognomeNomeAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Generalita_decrescente")),         SortUtils.cognomeNomeDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Nascita_decrescente")),       SortUtils.dataNascitaDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Nascita_crescente")),         SortUtils.dataNascitaAsc))

        selectedOrder = listaOrder[0]

        resize()

    }

    @Override void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    @Override Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest( usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder.campi))

        Page<CivRubricaNascite> p = civRubricaNasciteService.listAll(ricerca, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Override void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    static final String uriDettaglio = "rubricaNascite/rubricaNasciteDettaglio.zul"

    @Command void onInserisci() {
        if (modifyEnabled) {
            if (userModifyEnabled) {
                apriDettaglio(uriDettaglio, [:])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(uriDettaglio, [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricerca, p)
    }

    @Command void onFiltriPlus(@BindingParam("codice") String codice) {
        if (filtriExtraEnabled){
            if (userModifyEnabled) {
                if (codice == "ESTRAZIONE") {
                    apriDettaglio("rubricaNascite/stampaRubricaNasciteLista.zul", [:])
                } else {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

}
