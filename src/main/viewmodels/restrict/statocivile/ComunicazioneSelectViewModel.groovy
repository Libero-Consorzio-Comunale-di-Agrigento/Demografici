package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoComunicazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
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
class ComunicazioneSelectViewModel extends AbstractSelectViewModel {

    CivComunicazione dettaglio
    List<CivComunicazione> lista

    // filtri popup
    Integer codiceTipoAtto
    ETipoComunicazione tipoComunicazione
    CivFormulaAnnotazione formula

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w,
               @ExecutionArgParam("tipoComunicazione") ETipoComunicazione tipoComunicazione, // filtra per tipoComunicazione
               @ExecutionArgParam("codiceTipoAtto") Integer codiceTipoAtto, //filtra per tipoAtto o nelle formule (filtro in JOIN)
               @ExecutionArgParam("formula") CivFormulaAnnotazione formula //filtra per escludere le formule già usate (filtro in JOIN)
    ) {
        self = w

        addEnabled = false
        modifyEnabled = false
        searchEnabled = true

        this.codiceTipoAtto = codiceTipoAtto
        this.tipoComunicazione = tipoComunicazione
        this.formula = formula

        List<Map> eList = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Seleziona_Comunicazione")]

        eList.addAll(CivComunicazione.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette tipo comunicazione
        eList += ETipoComunicazione.values()*.getEtichettaDesc() as Map

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))

        Page p = null
        if (tipoComunicazione!=null) {
            p = civComunicazioneService.listAllByTipoComunicazione(tipoComunicazione, 0, codiceTipoAtto, formula, filtro, pr)
        } else if (codiceTipoAtto!=null) {
            p = civComunicazioneService.listAllByTipoAttoOrInFormule(codiceTipoAtto, filtro, pr)
        } else {
            log.error("Errore popup: tipoComunicazione o codiceTipoAtto non selezionati")
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command onSeleziona() {
        if (dettaglio){
            Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, dettaglio)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
