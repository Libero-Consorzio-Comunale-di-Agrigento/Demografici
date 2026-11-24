package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneListaViewModel extends DizionarioListaViewModel {

    Tuple2<AnaComunicazione, List> dettaglio
    List<Tuple2<AnaComunicazione, List>> lista
    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    final List<ETipoComunicazioneAnagrafe> listaTipiComunicazione = Arrays.asList(ETipoComunicazioneAnagrafe.values())
    ETipoComunicazioneAnagrafe tipoComunicazione

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaComunicazioneService anaComunicazioneService

    @WireVariable
    private AnaComunicazionePraticaService anaComunicazionePraticaService


    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Funzione_non_abilitata")]
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_comunicazione"), Etichette.getEtichetta("Nessun_dato_disponibile")])
        eList.addAll(AnaComunicazione.etichetteDomain)

        // Aggiungo etichette tipo comunicazione
        eList += ETipoComunicazioneAnagrafe.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        //Etichette enumerativi
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneEstesaAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneEstesaDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        List l = []
        Page<AnaComunicazione> p = null

        if (tipoComunicazione == null) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

            p = anaComunicazioneService.listAllByTipoComunicazioneAndFiltroLike(tipoComunicazione, filtro ?: "", pr)

            // carica sotto liste
            for (AnaComunicazione c : p) {
                List<AnaComunicazionePratica> listaAssociazioni = anaComunicazionePraticaService.findAllByComunicazione(c)
                l.add(new Tuple2(c, listaAssociazioni))
            }
        }

        return new Paginazione(l, p?.getTotalElements() ?: 0)
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/anagrafe/dizionari/comunicazioni/comunicazioneDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [:])
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.first.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command
    void onElimina() {
        if (dettaglio) {
            Messagebox.show(
                    getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")),
                    msgTitle,
                    Messagebox.OK | Messagebox.CANCEL,
                    Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                anaComunicazioneService.delete(dettaglio.first())
                                dettaglio = null
                                caricaLista()
                            }
                        }
                    }
            )
        }
    }


    @Command void onSelectTipoComunicazione() {
        onRicarica()
    }

    /**
     * Restituisce il testo di un elemento della sottolista
     *
     * @param subItem l'elemento
     * @return il testo
     */
    String getSubItemText(Object subItem) {
        if (subItem instanceof AnaComunicazionePratica) {
            String anagrafeDesc = getEtichettaEnum(subItem.archivioAnagrafe)
            String praticaDesc = getEtichettaEnum(subItem.tipoPratica)
            return "${anagrafeDesc} - ${praticaDesc}"
        }
        return subItem?.toString() ?: ""
    }

    Boolean isUserModifyEnabled() {
        //FIXME competenze
        return true
    }
}