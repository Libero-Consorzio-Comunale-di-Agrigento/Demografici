package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.LogBaseDomain
import it.finmatica.de4gsdzk.LogProjection
import it.finmatica.de4gsdzk.statocivile.LogsService
import it.finmatica.de4gsdzk.utils.ETipoLog
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractLogsListaViewModel extends DizionarioListaViewModel {

    List<LogProjection> lista
    LogProjection dettaglio

    ETipoLog tipoLog

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private LogsService logsService

    @WireVariable
    private CompetenzaService competenzaService

    @WireVariable
    private GsdService gsdService

    abstract List<ETipoLog> getListaTipiLog()

    void doInit(List<Map<String, String>> eList) {
        searchEnabled = true
        addEnabled = false
        modifyEnabled = false
        additionalSearchFilter = "/restrict/logsListaSearch.zul"

        // TODO: mostra solo su utente tecnico
        if (competenzaService.isCivSuperUser() && competenzaService.isCerSuperUser()) {
            additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonCompilaOggettiDb.zul"
        }

        eList.addAll([Etichette.getEtichetta("Archivio"), Etichette.getEtichetta("Log")])
        eList.addAll(LogBaseDomain.etichetteDomain)

        eList.add(Etichette.getEtichetta("compila_oggetti_db"))

        eList.addAll([Etichette.getEtichetta("Data_crescente"), Etichette.getEtichetta("Data_decrescente")])

        // Aggiungo etichette tipolog
        eList.addAll(Arrays.asList(ETipoLog.values())*.etichettaDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Log"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        tipoLog = null

        //Ordinamento
        listaOrder.addAll([ new OrderBy(getEtichetta(Etichette.getEtichetta("Data_decrescente")), [new Sort.Order(Sort.Direction.DESC, "dataOra"), new Sort.Order(Sort.Direction.DESC, "id")]),
                            new OrderBy(getEtichetta(Etichette.getEtichetta("Data_crescente")), [new Sort.Order(Sort.Direction.ASC, "dataOra"), new Sort.Order(Sort.Direction.ASC, "id")])])

        selectedOrder = listaOrder[0]

        listaTipiLog.sort { a, b ->
            Map<String, String> etichettaA = a.etichettaDesc
            Map<String, String> etichettaB = b.etichettaDesc
            etichette[etichettaA.codice] <=> etichette[etichettaB.codice]
        }
    }

    @Override
    void caricaLista() {
        Paginazione<LogProjection> p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshLista()
    }

    @Override
    Paginazione<LogProjection> eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(activePage, usePaging ? pageSize : Integer.MAX_VALUE, new Sort(selectedOrder?.campi))
        Page<LogProjection> p = logsService.listAllByTipoLog(tipoLog, filtro, pr)
        return new Paginazione(p?.getContent() ?: [], p?.getTotalElements() ?: 0)
    }

    @Override
    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        log.info("not implemented - not necessary")
        return ""
    }

    @Command
    void onShowClob() {
        showClob()
    }

    void showClob() {
        if (dettaglio) {
            LogBaseDomain log = logsService.get(tipoLog, dettaglio.id)
            String message = log.infoVis ?: getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile"))
            Messagebox.show(message, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        }
    }

    @Command
    void onCompilaOggettiDb() {
        gsdService.compilaOggettiDb()
        Messagebox.show("Oggetti database compilati", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
    }

}
