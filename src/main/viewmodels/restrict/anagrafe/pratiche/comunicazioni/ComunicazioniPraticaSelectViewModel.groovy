package restrict.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaArchivioComunicazioneService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePraticaService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioniPraticaSelectViewModel extends AbstractSelectViewModel{

    List<AnaComunicazionePratica> lista
    AnaComunicazionePratica dettaglio

    AnaPratica pratica

    Boolean priorita

    @WireVariable
    private AnaComunicazionePraticaService anaComunicazionePraticaService

    @WireVariable
    private AnaArchivioComunicazioneService anaArchivioComunicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pratica") AnaPratica pratica, @ExecutionArgParam("priorita") Boolean priorita) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Seleziona_Comunicazione"), Etichette.getEtichetta("Salva")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_selezione_comunicazione")])
        // Aggiungo etichette delle Comunicazioni
        eList.addAll(AnaComunicazione.etichetteDomain)
        eList.addAll(AnaComunicazionePratica.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        totalSizeLabel = ""

        this.pratica = pratica
        this.priorita = priorita

        caricaLista()

        if (lista.size() == 0){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            onChiudi()
        }
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){

        List<AnaComunicazionePratica> l = anaComunicazionePraticaService.listAllNotSelected(pratica, priorita)
        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSalva() {
        if (dettaglio){
            String esito = anaComunicazionePraticaService.sendAllDefaultComunicazioni(pratica.archivioAnagrafe, pratica.tipoPratica, pratica.anno, pratica.numero, priorita, dettaglio.comunicazione.id)
            Messagebox.show(esito, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
