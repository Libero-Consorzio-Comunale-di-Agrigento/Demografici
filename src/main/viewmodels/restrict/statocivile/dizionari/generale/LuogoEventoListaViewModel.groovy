package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ILuogoEvento
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class LuogoEventoListaViewModel extends DizionarioListaViewModel{

    ILuogoEvento dettaglio
    List<ILuogoEvento> lista

    List<Sezione> sezioniLuogo = []
    Sezione selectedSezioneLuogo

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    Component opener

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    abstract void eliminaLuogo(ILuogoEvento luogo)

    void doInit(Window w, List<Sezione> sezioniLuogo, Component opener, ETipoEvento t, List<Map<String, String>> eList) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        this.sezioniLuogo = sezioniLuogo
        for (Sezione s: sezioniLuogo){
            if (ETipoEvento.valueOf(s.value) == t){
                selectedSezioneLuogo = s
                break
            }
        }
        this.opener = opener

        eList.addAll([Etichette.getEtichetta("Luogo"), Etichette.getEtichetta("Luoghi_Evento"), Etichette.getEtichetta("Funzione_non_abilitata")])

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Luoghi_Evento"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled){
            apriDettaglio(getUriDettaglio(), opener, [:])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio){
            if (userModifyEnabled){
                apriDettaglio(getUriDettaglio(), opener, [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            eliminaLuogo(dettaglio)
        }
    }

    @Command void onSelectLuogo() {
        Events.postEvent(CustomEvents.ON_SELECT_LUOGO, opener, [selectedSezioneLuogo:selectedSezioneLuogo])
    }

}
