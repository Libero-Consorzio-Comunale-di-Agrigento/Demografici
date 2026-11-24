package restrict.elettorale.dizionari.wsMinisteriali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.De4Elezione
import it.finmatica.de4gsdzk.elettorale.De4ElezioneService
import it.finmatica.de4gsdzk.elettorale.EleElezione
import it.finmatica.de4gsdzk.elettorale.EleRilevamentoWs
import it.finmatica.de4gsdzk.elettorale.EleRilevamentoWsService
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
import org.zkoss.bind.annotation.NotifyChange
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RilevamentoWsListaViewModel extends DizionarioListaViewModel {

    EleRilevamentoWs dettaglio
    List<EleRilevamentoWs> lista

    EleElezione elezione
    List<De4Elezione> elezioniList = [null]
    De4Elezione de4Elezione

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private EleRilevamentoWsService eleRilevamentoWsService

    @WireVariable
    private De4ElezioneService de4ElezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Rilevamenti"), Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Elezione"),
                                           Etichette.getEtichetta("Anno_Elezioni"), Etichette.getEtichetta("Progr_Elezioni"), Etichette.getEtichetta("Tutte"), Etichette.getEtichetta("Seleziona_Elezione")]
        eList.addAll(EleRilevamentoWs.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Rilevamenti"))
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
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort([new Sort.Order(Sort.Direction.ASC, "rilevamentoAds")]))
        Page<EleRilevamentoWs> p = eleRilevamentoWsService.listAllByElezioneAndElezioneAdsAndFiltroLike(elezione, de4Elezione, filtro, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onSelectElezione(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        elezione = (EleElezione) e.getData()
        caricaElezioniList()
        caricaLista()
		refreshUi()
    }

    @Command
    void onAzzeraElezione() {
        elezione = null
        de4Elezione = null
        caricaLista()
        refreshUi()
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/elettorale/dizionari/wsMinisteriali/rilevamentoWsDettaglio.zul"
    }

    @Command
    void onInserisci() {
        if(elezione == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Seleziona_Elezione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        }
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [elezione: elezione])
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
            eleRilevamentoWsService.delete(dettaglio)
            onRicarica()
        }
    }

    void caricaElezioniList() {
        elezioniList = [null]
        de4Elezione = null
        elezioniList.addAll(de4ElezioneService.findAllByElezione(elezione))
        refreshUi()
    }

    @Command
    void onSelectElezioneAds() {
        onRicerca()
    }
}
