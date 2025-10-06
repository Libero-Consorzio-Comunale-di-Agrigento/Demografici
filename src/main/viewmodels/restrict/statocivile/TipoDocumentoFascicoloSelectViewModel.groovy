package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicoloService
import it.finmatica.de4gsdzk.utils.*
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
class TipoDocumentoFascicoloSelectViewModel extends AbstractSelectViewModel{

    List<CivTipoDocumentoFascicolo> lista
    CivTipoDocumentoFascicolo dettaglio

    Boolean anscOn = Boolean.FALSE

    String tipoUso

    private static final String TUTTI = "TU"
    private static final String RICORRENTI = "RI"

    ETipoAtto tipoAttoEnum

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {

        this.self = w

        this.tipoAttoEnum = tipoAttoEnum

        List<Map<String, String>> eList = [Etichette.Tutti, Etichette.Ricorrenti]
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        eList.addAll(CivTipoDocumentoFascicolo.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tipo_Documento)

        totalSizeLabel = ""

        this.tipoUso = TUTTI

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))

        Page p = civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoAttoEnum, (tipoUso == RICORRENTI), filtro, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSelectTipoUso() {
        onRicarica()
    }

    @Command void onSeleziona() {
        if (dettaglio){
            Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, dettaglio)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
