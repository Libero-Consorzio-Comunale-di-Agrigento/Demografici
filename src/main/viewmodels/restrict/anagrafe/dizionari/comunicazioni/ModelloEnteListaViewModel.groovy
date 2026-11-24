package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloEnteService
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
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
class ModelloEnteListaViewModel extends DizionarioListaViewModel {

    AnaModelloEnte dettaglio
    List<AnaModelloEnte> lista
    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaModelloEnteService anaModelloEnteService

    List<ETipoModello> listaTipiModello = [ETipoModello.C, ETipoModello.P]
    ETipoModello tipoModello

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Modelli_Ente"), Etichette.getEtichetta("Funzione_non_abilitata")]
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_modello")])
        eList.addAll(AnaModelloEnte.etichetteDomain)

        // etichette delle enum
        eList += listaTipiModello*.getEtichettaDesc() as Map
        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modelli_Ente"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), [new Sort.Order(Sort.Direction.ASC, "modello.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), [new Sort.Order(Sort.Direction.DESC, "modello.descrizione")]),
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
        Page<AnaModelloEnte> p = null
        if (tipoModello == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_modello")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            p = anaModelloEnteService.listAllByTipoModelloAndFiltroLike(tipoModello, filtro, pr)
        }
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/anagrafe/dizionari/comunicazioni/modelloEnteDettaglio.zul"
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
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
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
            return (dettaglio?.id + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            anaModelloEnteService.delete(dettaglio)
            onRicarica()
        }
    }
}