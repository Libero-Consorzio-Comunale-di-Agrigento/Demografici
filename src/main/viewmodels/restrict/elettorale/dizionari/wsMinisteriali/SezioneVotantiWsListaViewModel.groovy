package restrict.elettorale.dizionari.wsMinisteriali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.De4Elezione
import it.finmatica.de4gsdzk.elettorale.De4ElezioneService
import it.finmatica.de4gsdzk.elettorale.EleElezione
import it.finmatica.de4gsdzk.elettorale.EleSezioneVotantiWs
import it.finmatica.de4gsdzk.elettorale.EleSezioneVotantiWsService
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
class SezioneVotantiWsListaViewModel extends DizionarioListaViewModel {

    EleSezioneVotantiWs dettaglio
    List<EleSezioneVotantiWs> lista

    EleElezione elezione
    List<De4Elezione> elezioniList = [null]
    De4Elezione de4Elezione

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private EleSezioneVotantiWsService eleSezioneVotantiWsService

    @WireVariable
    private De4ElezioneService de4ElezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Sezioni_Votanti"), Etichette.getEtichetta("Funzione_non_abilitata"), Etichette.getEtichetta("Elezione"),
                                           Etichette.getEtichetta("Anno_Elezioni"), Etichette.getEtichetta("Progr_Elezioni"), Etichette.getEtichetta("Tutte"), Etichette.getEtichetta("Seleziona_Elezione")]
        eList.addAll(EleSezioneVotantiWs.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Sezioni_Votanti"))
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
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort([new Sort.Order(Sort.Direction.ASC, "sezioneAds")]))
        Page<EleSezioneVotantiWs> p = eleSezioneVotantiWsService.listAllByElezioneAndElezioneAdsAndFiltroLike(elezione, de4Elezione, filtro, pr)
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
        return "/restrict/elettorale/dizionari/wsMinisteriali/sezioneVotantiWsDettaglio.zul"
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
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, elezione: elezione])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizioneSezione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            eleSezioneVotantiWsService.delete(dettaglio)
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
