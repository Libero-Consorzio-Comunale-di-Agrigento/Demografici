package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificatoService
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.CerTariffaDirittoService
import it.finmatica.de4gsdzk.certificazione.EDiritto
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
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
class TariffaDirittoListaViewModel extends DizionarioListaViewModel {

    List<CerTariffaDiritto> lista
    CerTariffaDiritto dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = []
    CerCategoriaTipoCertificato selectedCategoria

    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.Tariffe_Diritti]
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(EDiritto.values()*.etichettaDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tariffe_Diritti)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        caricaListaCategoriaTipoCertificato()

        caricaLista()
    }

    void caricaListaCategoriaTipoCertificato() {
        listaCategoriaTipoCertificato = [null]

        List<CerCategoriaTipoCertificato> l = cerCategoriaTipoCertificatoService.listAll()
        if (l.size() > 0) {
            listaCategoriaTipoCertificato.addAll(l)
        }

        selectedCategoria = listaCategoriaTipoCertificato.get(0) as CerCategoriaTipoCertificato
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.dirittoFasciaTariffariaAsc))

        Page p = cerTariffaDirittoService.listAllByDescrizioneLikeAndCategoriaTipoCertificato(filtro, selectedCategoria, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/generale/tariffaDirittoDettaglio.zul"
    }

    @Command
    void onSelectCategoria() {
        onRicarica()
    }

    @Command
    void onInserisci() {
        if (addEnabled) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [:])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command
    void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            cerTariffaDirittoService.delete(dettaglio)
            onRicarica()
        }
    }

}
