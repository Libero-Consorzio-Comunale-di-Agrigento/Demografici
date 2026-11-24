package restrict.elettorale.dizionari.wsMinisteriali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.EleTipoElezioneWs
import it.finmatica.de4gsdzk.elettorale.EleTipoElezioneWsService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TipoElezioneWsListaViewModel extends DizionarioListaViewModel {

    EleTipoElezioneWs dettaglio
    List<EleTipoElezioneWs> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private EleTipoElezioneWsService eleTipoElezioneWsService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipi_Elezione"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll(EleTipoElezioneWs.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Tipi_Elezione"))
        formLabel = msgTitle?.toUpperCase()
        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.idAsc))
        Page<EleTipoElezioneWs> p = eleTipoElezioneWsService.listAllByFiltroLike(filtro, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/elettorale/dizionari/wsMinisteriali/tipoElezioneWsDettaglio.zul"
    }

    @Command
    void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [:])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            eleTipoElezioneWsService.delete(dettaglio)
            onRicarica()
        }
    }
}
