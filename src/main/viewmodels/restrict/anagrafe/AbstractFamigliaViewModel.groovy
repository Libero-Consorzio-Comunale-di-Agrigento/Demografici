package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import restrict.AbstractSelectViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitControlBarCapable
import restrict.TraitVia

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractFamigliaViewModel extends AbstractSelectViewModel implements TraitCancellazioneCampi, TraitVia, TraitControlBarCapable{


    final List<ETipoFamiglia> listaTipoFamiglia = [null] + Arrays.asList(ETipoFamiglia.values())
    final List<ETipoSiNo> listaIscrittoInAPR = [null] + Arrays.asList(ETipoSiNo.values())


    RicercaFamiglia ricercaFamiglia

    boolean ricerca = Boolean.FALSE
    String famigliaLabel = null

    void doInitVMFamglia(List<Map> eList) {

        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false
        controlBarAttributes.backEnabled = false

        if(ricerca){
            famigliaLabel = ricercaFamiglia.fascia == EFascia.ISCRITTO_APR ? "Apr" : "Aire"
        }

        // Aggiungo etichette header
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Iscritto_in_APR")])

        // Aggiungo etichette ricerca
        eList.addAll(RicercaFamiglia.etichetteRicercaDesc)
        eList.addAll(ETipoFamiglia.values()*.etichettaDesc)
        eList.addAll(ETipoSiNo.values()*.etichettaDesc)
        eList.addAll(EFascia.values()*.etichettaDesc)
        eList.add(Etichette.getEtichetta("Tutti"))
        eList.add(Etichette.getEtichetta("Famiglia"))
        // Aggiungo etichette per bottoni ricerca
        eList.addAll([Etichette.getEtichetta("Ricerca_in_Anagrafe")])
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Apr"),
                      Etichette.getEtichetta("Aire")])

        eList.addAll(etichetteListaDefault)
        doInitEtichette(eList)
    }

    abstract void caricaLista()


    @Command
    void onResetRicerca() {
        resetRicerca()
    }

    @Command
    void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaFamiglia, p)
        resetRicerca()
    }

    @Command
    void onRicerca() {
        onRicarica()
    }

    @Override
    void selezionaVia(ArcVia c) {
        ricercaFamiglia.via = c
    }

}
