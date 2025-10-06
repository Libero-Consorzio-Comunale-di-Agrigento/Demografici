package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificatoService
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificatoService
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
class TipoCertificatoListaViewModel extends DizionarioListaViewModel {

    List<CerTipoCertificato> lista
    CerTipoCertificato dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<Map<String, Object>> listaCategoriaTipoCertificato = []
    Map<String, Object> selectedCategoria

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @WireVariable
    private CerTipoCertificatoService cerTipoCertificatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.Tipo_Certificato, Etichette.Nessuno, Etichette.Tutti]
        eList.addAll(CerTipoCertificato.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tipo_Certificato)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        caricaListaCategoriaTipoCertificato()

        caricaLista()
    }

    void caricaListaCategoriaTipoCertificato() {
        listaCategoriaTipoCertificato = [null]

        List<CerCategoriaTipoCertificato> l = cerCategoriaTipoCertificatoService.listAll()
        if (l.size() > 0) {
            l.each {
                listaCategoriaTipoCertificato.add([
                        id             : it?.id,
                        descrizione    : it?.descrizione,
                        categoriaDomain: it
                ])
            }
        }

        Boolean existsCategoriaNone = cerTipoCertificatoService.existsByCategoriaNone()
        if (existsCategoriaNone) {
            listaCategoriaTipoCertificato.add([id             : -1,
                                               descrizione    : getEtichettaCategoriaNone(),
                                               categoriaDomain: null])
        }

        selectedCategoria = listaCategoriaTipoCertificato.get(0) as Map
    }

    String getEtichettaCategoriaNone() {
        Boolean existsDescrizioneLowerCase = listaCategoriaTipoCertificato.any { it?.descrizione?.matches(".*[a-z].*") }
        Boolean shouldCapitalizeEtichettaCategoriaNone = !existsDescrizioneLowerCase
        if (shouldCapitalizeEtichettaCategoriaNone) {
            return getEtichetta(Etichette.Nessuno).toUpperCase()
        }
        return getEtichetta(Etichette.Nessuno)
    }

    @Command
    void onSelectCategoria() {
        onRicarica()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.idAsc))

        Page p
        if (selectedCategoria == null) {
            p = cerTipoCertificatoService.listAllByDescrizioneLike(filtro, pr)
        } else {
            p = cerTipoCertificatoService.listAllByCategoriaAndDescrizioneLike(selectedCategoria.categoriaDomain as CerCategoriaTipoCertificato, filtro, pr)
        }

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/generale/tipoCertificatoDettaglio.zul"
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
            cerTipoCertificatoService.delete(dettaglio)
            caricaListaCategoriaTipoCertificato()
            refreshUi()
            onRicarica()
        }
    }
}
