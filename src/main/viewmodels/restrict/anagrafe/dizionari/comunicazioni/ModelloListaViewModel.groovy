package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModelloListaViewModel extends DizionarioListaViewModel {

    AnaModello dettaglio
    List<AnaModello> lista
    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaModelloService anaModelloService

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    List<ETipoModello> listaTipiModello
    ETipoModello tipoModello

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true
        additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonDownloadOrigineDati.zul"

        List<Map<String, String>> eList = [Etichette.getEtichetta("Modelli"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_modello")])
        eList.addAll(AnaModello.etichetteDomain)

        listaTipiModello = ETipoModello.values()

        // etichette delle enum
        eList += listaTipiModello*.getEtichettaDesc() as Map
        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modelli"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), [new Sort.Order(Sort.Direction.ASC, "codModello")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), [new Sort.Order(Sort.Direction.DESC, "codModello")])])

        selectedOrder = listaOrder[0]
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        Page<AnaModello> p = null
        if (tipoModello == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_modello")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            p = anaModelloService.listAllByTipoModelloAndFiltroLike(tipoModello, filtro, pr)
        }
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/anagrafe/dizionari/comunicazioni/modelloDettaglio.zul"
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled) {
            if (!tipoModello) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_modello")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                apriDettaglio(getUriDettaglio(), [tipoModello: tipoModello])
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoModello: tipoModello])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onSelectTipoModello() {
        onRicarica()
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio?.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            anaModelloService.delete(dettaglio)
            onRicarica()
        }
    }

    @Command void onDownloadOrigineDati() {
        byte[] zip = gestioneTestiGsdModelloService.generateZipFromServer("/WEB-INF/originedati/comunicazioni_ana")
        Filedownload.save(zip, ETipoFile.ZIP.contentType, "Ana.zip")
    }
}
