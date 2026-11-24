package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FamigliaSelectViewModel extends AbstractFamigliaViewModel {

    List<AnaIndirizzoStradario> lista
    AnaIndirizzoStradario dettaglio

    @WireVariable
    AnaIndirizzoStradarioService anaIndirizzoStradarioService


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("via") ArcVia via,
         @ExecutionArgParam("numeroCivico") Long numeroCivico,
         @ExecutionArgParam("suffisso") String suffisso,
         @ExecutionArgParam("interno") Long interno,
         @ExecutionArgParam("subInterno") String subInterno,
         @ExecutionArgParam("scala") String scala,
         @ExecutionArgParam("piano") String piano,
         @ExecutionArgParam("tipoFamiglia") ETipoFamiglia tipoFamiglia,
         @ExecutionArgParam("fascia") EFascia fascia) {

        self = w

        controlBarAttributes.searchEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Seleziona_Famiglie_Interni")]
        eList.addAll(AnaIndirizzoStradario.etichetteDomain)


        ricercaFamiglia = new RicercaFamiglia()
        ricercaFamiglia.via = via
        ricercaFamiglia.numeroCivico = numeroCivico
        ricercaFamiglia.suffisso = suffisso
        ricercaFamiglia.interno = interno
        ricercaFamiglia.subInterno = subInterno
        ricercaFamiglia.scala = scala
        ricercaFamiglia.piano = piano
        ricercaFamiglia.tipoFamiglia = tipoFamiglia
        ricercaFamiglia.fascia = fascia
        ricerca = Boolean.TRUE

        doInitVMFamglia(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Seleziona_Famiglie_Interni"))
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        onRicerca()
    }

    @Command
    void onSeleziona() {
        if(dettaglio) {
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, dettaglio)
            onChiudi()
        }

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE))
        Page p = anaIndirizzoStradarioService.listAllByRicercaFamiglia(ricercaFamiglia, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }



}
