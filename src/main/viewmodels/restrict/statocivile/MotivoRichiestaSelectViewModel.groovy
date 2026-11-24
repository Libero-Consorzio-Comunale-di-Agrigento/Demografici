package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiesta
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiestaService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class MotivoRichiestaSelectViewModel extends AbstractSelectViewModel {

    List<CivMotivoRichiesta> lista
    CivMotivoRichiesta dettaglio

    CivCategoriaTipoAtto categoria
    ETipoRichiesta tipoRichiesta

    String tipoUso

    private static final String RICORRENTI = "RI"
    private static final String ALTRO = "AL"

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivMotivoRichiestaService civMotivoRichiestaService

    void doInit(Window w, CivCategoriaTipoAtto categoria, ETipoRichiesta tipoRichiesta) {
        self = w

        addEnabled = false
        modifyEnabled = false

        this.categoria = categoria
        this.tipoRichiesta = tipoRichiesta

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Ricorrenti"), Etichette.getEtichetta("Altro")]
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Motivo_richiesta"))

        totalSizeLabel = ""

        this.tipoUso = RICORRENTI

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)
        String f = (filtro ? SqlUtils.beginsAndEndsLike(filtro) : "%")
        List<CivMotivoRichiesta> l = civMotivoRichiestaService.listAllByCategoriaAndTipoRichiesta(categoria, tipoRichiesta, f, [ricorrenti: tipoUso == RICORRENTI, nonRicorrenti: tipoUso == ALTRO])
        return new Paginazione(l, l.size())
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Command
    void onSelectTipoUso() {
        onRicarica()
    }

    @Command
    void onSeleziona() {
        if (dettaglio) {
            Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, dettaglio)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
