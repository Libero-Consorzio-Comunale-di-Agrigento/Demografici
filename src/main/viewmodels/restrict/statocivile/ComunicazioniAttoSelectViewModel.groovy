package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.DomainUtils
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.dao.DataIntegrityViolationException
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioniAttoSelectViewModel extends AbstractSelectViewModel{

    List<CivComunicazioneAtto> lista
    CivComunicazioneAtto dettaglio

    CivAttoBaseDomain atto

    Boolean priorita

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("atto") CivAttoBaseDomain atto, @ExecutionArgParam("priorita") Boolean priorita) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Numero_copie"), Etichette.getEtichetta("Seleziona_Comunicazione"), Etichette.getEtichetta("Salva")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_selezione_comunicazione")])
        // Aggiungo etichette delle Comunicazioni
        eList.addAll(CivComunicazione.etichetteDomain)
        eList.addAll(CivComunicazioneAtto.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        totalSizeLabel = ""

        this.atto = atto
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
        log.info ("usePaging: " + usePaging)

        List<CivComunicazioneAtto> l = civComunicazioneAttoService.listAllNotSelected(atto, priorita)
        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSalva() {
        if (dettaglio){
            CivArchivioComunicazione ac = civArchivioComunicazioneService.create()
            ac.comunicazione = dettaglio.comunicazione
            ac.numeroCopie = dettaglio.numeroCopie
            DomainUtils.initFromAtto(ac, atto)
            ac.tipoAttoRif = atto.tipoAtto
            try{
                ac = civArchivioComunicazioneService.save(ac)
                Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [idComunicazioneAtto: ac.id] )
                onChiudi()
            } catch (DataIntegrityViolationException ex){
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_selezione_comunicazione")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
