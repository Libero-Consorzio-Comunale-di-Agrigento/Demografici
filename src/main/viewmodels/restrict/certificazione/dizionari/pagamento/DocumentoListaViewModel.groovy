package restrict.certificazione.dizionari.pagamento

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumento
import it.finmatica.de4gsdzk.pagamento.depag.DepagDocumentoService
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneErroreException
import it.finmatica.de4gsdzk.pagamento.error.SincronizzazioneNessunElementoException
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoListaViewModel extends DizionarioListaViewModel {
    private static String ADD_SINCRONIZZA = "ADD_SINCRONIZZA"

    final List<Map> addPlusList = []

    List<DepagDocumento> lista
    DepagDocumento dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private DepagDocumentoService depagDocumentoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true
        addEnabled = false
        addPlusEnabled = true
        deleteEnabled = false

        List<Map<String, String>> eList = [Etichette.Documenti, Etichette.Funzione_non_abilitata, Etichette.Sincronizza_con_altro, Etichette.Tipi_Certificato]
        eList.addAll(DepagDocumento.etichetteDomain)
        eList.addAll(EtichetteMessaggi.Info_Sincronizzazione_successo)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Documenti)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        addPlusList.add([id: ADD_SINCRONIZZA, idDomain: ADD_SINCRONIZZA, descrizione: String.format(getEtichetta(Etichette.Sincronizza_con_altro), getEtichetta(Etichette.Tipi_Certificato)), tipo: "T"])

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

        Page<DepagDocumento> p = depagDocumentoService.listAllByDescrizione(SqlUtils.beginsAndEndsLike(filtro), pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        return "/restrict/certificazione/dizionari/pagamento/documentoDettaglio.zul"
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
    void onInserisciPlus(@BindingParam("idDomain") String idDomain) {
        if (addPlusEnabled && userModifyEnabled) {
            if (idDomain == ADD_SINCRONIZZA) {
                try {
                    depagDocumentoService.sincronizza()
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.I, getEtichetta(EtichetteMessaggi.Info_Sincronizzazione_successo))
                } catch (SincronizzazioneNessunElementoException e) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.W, e.message)
                } catch (SincronizzazioneErroreException e) {
                    MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, e.message)
                }
                onRicarica()
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return (dettaglio.tipoCertificato.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio) {
            depagDocumentoService.delete(dettaglio)
            onRicarica()
        }
    }

}
