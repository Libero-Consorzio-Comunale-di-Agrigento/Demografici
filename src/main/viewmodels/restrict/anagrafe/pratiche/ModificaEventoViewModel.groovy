package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentela
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentelaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCineraria
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaUrnaCinerariaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractCommonViewModel
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModificaEventoViewModel extends AbstractCommonViewModel implements TraitCancellazioneCampi, TraitComune {

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private AnaPraticaService anaPraticaService

    ModificaEvento modificaEvento
    Long idPratica

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("id") Long id,
         @ExecutionArgParam("operazione") String operazione,
         @ExecutionArgParam("ripristino") Boolean ripristino) {
        self = w
        modificaEvento = new ModificaEvento('A'.equals(operazione), ripristino)
        idPratica = id


        List<Map<String, String>> eList = [Etichette.getEtichetta("Aggiorna_Evento"), Etichette.getEtichetta("Elimina_Evento")]
        eList.addAll(ModificaEvento.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Compilare_pratica_anno"), Etichette.getEtichetta("Compilare_campi_nuovi_valori"),
                      Etichette.getEtichetta("Ask_Conferma_Operazione"),Etichette.getEtichetta("Data_Registrazione_Non_Corretta"),
                      Etichette.getEtichetta("Conferma"), Etichette.getEtichetta("Chiudi")])



        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = modificaEvento.aggiornamento ? getEtichetta(Etichette.getEtichetta("Aggiorna_Evento")) : getEtichetta(Etichette.getEtichetta("Elimina_Evento"))
        formLabel = msgTitle?.toUpperCase()
    }

    @Override
    Object getDettaglio() {
        return modificaEvento
    }

    @Command
    void onConferma() {
        if (modificaEvento.aggiornamento) {
            checkDatiObbligatori()
        }
        if((modificaEvento.motivo?.trim() ?: "") == "") {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }
        Messagebox.show(getEtichetta(etichette, Etichette.getEtichetta("Ask_Conferma_Operazione")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES.equals(e.getName())){
                            if(modificaEvento.aggiornamento) {
                                gsdService.popolaDatiAggiornamento(idPratica, modificaEvento)
                            } else {
                                gsdService.popolaDatiEliminazione(idPratica, modificaEvento)
                            }
                            String msg = gsdService.modificaEvento(modificaEvento.aggiornamento)
                            Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                            onChiudi()
                        }
                        if (Messagebox.ON_NO.equals(e.getName())){
                            onChiudi()
                        }
                    }
                }
        )
    }

    private void checkDatiObbligatori() {
        if((modificaEvento.anno == null && modificaEvento.pratica != null) ||
                (modificaEvento.anno != null && modificaEvento.pratica == null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_pratica_anno"))
        }
        if(modificaEvento.anno == null &&
                (modificaEvento.comuneEvento.codice == null || modificaEvento.comuneEvento.codiceProvincia == null) &&
                (modificaEvento.comuneIscrizioneAire.codice == null || modificaEvento.comuneIscrizioneAire.codiceProvincia == null) &&
                modificaEvento.dataRegistrazione == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_nuovi_valori"))
        }

        if(DataUtils.isDataFutura(modificaEvento.dataRegistrazione)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Data_Registrazione_Non_Corretta"))
        }

    }

    @Override
    void selezionaComune(ETipoComuneAtto tc, ArcComuneBaseDomain c) {
        switch (tc) {
            case ETipoComuneAtto.PROV:
                riempiComune(modificaEvento.comuneEvento, c)
                break
            case ETipoComuneAtto.ISC_AIRE:
                riempiComune(modificaEvento.comuneIscrizioneAire, c)
                break
        }
    }


}