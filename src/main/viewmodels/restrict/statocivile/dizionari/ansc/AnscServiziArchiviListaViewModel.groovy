package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
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
class AnscServiziArchiviListaViewModel extends DizionarioListaViewModel{

    List<AnscEndPointServizioArchivio> lista
    AnscEndPointServizioArchivio dettaglio

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    final List<ETipoArchivioAnsc> listaTipiArchivioAnsc = ETipoArchivioAnsc.values().toList()
    ETipoArchivioAnsc tipoArchivioAnscEnum

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = true
        searchEnabled = false
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.Tipi_di_Atto, Etichette.Funzione_non_abilitata, Etichette.Archivi_di_Riferimento,
                                           EtichetteMessaggi.Compilare_tipo_archivio, EtichetteMessaggi.Ask_Cancellazione_associazione_servizio_ANSC]

        eList.addAll(AnscEndPointServizio.etichetteDomain)
        eList.addAll(AnscEndPointServizioArchivio.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(listaTipiArchivioAnsc*.etichettaDesc)

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.Archivi_di_Riferimento)

        formLabel = msgTitle?.toUpperCase()

    }

    @Command void onSelectArchivio() {
        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        List<AnscEndPointServizioArchivio> l = []

        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/ansc/anscServiziArchiviDettaglio.zul"
    }

    @Command void onInserisci() {
        if (tipoArchivioAnscEnum){
            if (userModifyEnabled){
                Map<String, ?> params = new HashMap<String, ?>()
                params.put("tipoArchivioAnsc", tipoArchivioAnscEnum)
                apriDettaglio(getUriDettaglio(), params)
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_archivio), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.archivio == tipoArchivioAnscEnum) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoArchivioAnsc: tipoArchivioAnscEnum])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_apertura_record), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.servizio) {
            return String.format(getEtichetta(EtichetteMessaggi.Ask_Cancellazione_associazione_servizio_ANSC), dettaglio.servizio.descrizione)
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            anscEndPointServizioArchivioService.delete(dettaglio)
            onRicarica()
        }
    }

}
