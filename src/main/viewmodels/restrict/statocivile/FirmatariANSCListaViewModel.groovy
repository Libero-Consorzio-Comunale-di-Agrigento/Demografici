package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAtto
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAttoService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarANSCAttributes
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FirmatariANSCListaViewModel extends RiferimentiAttoListaParentViewModel{

    List<CivFirmatarioAtto> lista = []
    List<CivFirmatarioAtto> dettaglio

    final List<ETipoFirmaAnsc> listaTipoFirma = [null] + Arrays.asList(ETipoFirmaAnsc.values())

    Boolean wPreviewANSCOpen = Boolean.FALSE

    AnscCasoUsoBaseDomain casoUso

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()

    @WireVariable
    private CivFirmatarioAttoService civFirmatarioAttoService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso,
         @ExecutionArgParam("anscFlow") Boolean anscFlow) {

        self = w
        this.casoUso = casoUso

        backFromListANSCEnabled = true
        goToFascicoloANSCEnabled = false
        goToAllegatiANSCEnabled = false
        goToFirmatariANSCEnabled = false
        goToANSCEnabled = anscFlow == Boolean.TRUE
        saveANSCEnabled = true

        List<Map> eList = [Etichette.Firmatari]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Ask_salvataggio_dati_firmatari_incompleti_ANSC, EtichetteMessaggi.Salvataggio_Completato])
        eList.addAll(ControlBarANSCAttributes.etichetteCbANSCDesc)

        //Aggiungo etichette firmatari
        eList.addAll(CivFirmatarioAtto.etichetteDomain)

        // Aggiungo etichette tipo firma
        eList.addAll(ETipoFirmaAnsc.values()*.getEtichettaDesc())

        doInit(eList, pkAtto, tipoAttoEnum) //carica anche atto e dati provenienza

        msgTitle = getEtichetta(Etichette.Firmatari)
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        List l = []
        if (!(usePaging)){
            l = civFirmatarioAttoService.listAllByIdAtto(atto?.idAtto, new Sort(SortUtils.sequenzaAsc))
        }
        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettagli()
    }

    boolean getLoadOnCloseData(){
        return true
    }

    @Command void onSalvaAnsc() {
        civFirmatarioAttoService.saveAll(lista, atto.getTipoAttoEnum(), atto.id)
        Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        onRicarica()
    }

    @Command void onPreviewANSC(){
        if (atto && (!(wPreviewANSCOpen)) ) {
            if (atto?.idAtto) {
                if (civFirmatarioAttoService.existsFirmatarioNonValido(atto.idAtto)){
                     Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_salvataggio_dati_firmatari_incompleti_ANSC), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                            new org.zkoss.zk.ui.event.EventListener(){
                                void onEvent(Event e){
                                    if (Messagebox.ON_YES.equals(e.getName())){
                                        goToNextAnscPage()
                                    }
                                }
                            }
                    )
                } else {
                    goToNextAnscPage()
                }
            }
        }
    }

    void goToNextAnscPage() {
        String uriANSC = "/restrict/statocivile/allegatiANSCLista.zul"
        if (skipAllegatiPage()) {
            uriANSC = FormUtils.getUriPreviewANSC(atto)
        }
        if (uriANSC) {
            try {
                wPreviewANSCOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents(uriANSC, self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), casoUso: casoUso, anscFlow: true])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    wPreviewANSCOpen = Boolean.FALSE
                    Events.postEvent(Events.ON_CLOSE, self, [:])
                })
                w.doEmbedded()
            } catch (Exception ex) {
                log.error("Errore apertura preview dati per integrazione con ANSC", ex)
                wPreviewANSCOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    Boolean skipAllegatiPage() {
        if (casoUso == null) {
            return true
        }
        return anscEndPointServizioArchivioService.listAllServiziAttoAllegatiByAndCasoUsoAndAtto(casoUso?.id, atto).isEmpty() || civAttoService.isInviatoAnsc(atto.getTipoAttoEnum(), atto.id)
    }

}
