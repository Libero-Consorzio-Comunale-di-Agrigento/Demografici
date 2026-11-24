package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.ansc.AnscInfoAllegatoCdu
import it.finmatica.de4gsdzk.ansc.AnscInfoStepInvio
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FormUtils
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarANSCAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AllegatiANSCListaViewModel extends AnscAttoListaParentViewModel {

    Boolean wPreviewANSCOpen = Boolean.FALSE

    @Delegate
    ControlBarANSCAttributes cbANSC = new ControlBarANSCAttributes()


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("pkAtto") Long pkAtto,
         @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
         @ExecutionArgParam("casoUso") AnscCasoUsoBaseDomain casoUso,
         @ExecutionArgParam("anscFlow") Boolean anscFlow) {

        self = w

        backFromListANSCEnabled = true
        goToFascicoloANSCEnabled = false
        goToAllegatiANSCEnabled = false
        goToFirmatariANSCEnabled = false
        saveANSCEnabled = false
        goToANSCEnabled = anscFlow == Boolean.TRUE

        List<Map> eList = [Etichette.getEtichetta("Allegati_Ansc")]

        eList.addAll([Etichette.getEtichetta("Ask_salvataggio_allegati_obbligatori_incompleti_ANSC"), Etichette.getEtichetta("Ask_salvataggio_allegati_non_obbligatori_incompleti_ANSC")])

        doInitAllAtti(eList, pkAtto, tipoAttoEnum, casoUso, getAttoParams(tipoAttoEnum))

        msgTitle = getEtichetta(Etichette.getEtichetta("Allegati_Ansc"))
        formLabel = msgTitle?.toUpperCase()
    }

    @Override
    Boolean getCasiUsoEnabled() {
        return Boolean.FALSE
    }

    @Override
    @Command
    void onBackFromList() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    protected Map getAttoParams(ETipoAtto tipoAttoEnum) {
        switch (tipoAttoEnum) {
            case ETipoAtto.CIT:
                return [fetch: [[campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT], [campo: 'motivoCittadinanza', tipo: JoinType.LEFT]]]
        }
        return [fetch: [[campo: 'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT]]]
    }

    @Override
    List<AnscEndPointServizioArchivio> getListaServiziCdu() {
        return anscEndPointServizioArchivioService.listAllServiziAttoAllegatiByAndCasoUsoAndAtto(casoUso.id, atto)
    }

    @Override
    List<AnscInfoStepInvio> getProperLista(String tabComunicazione) {
        return lista
    }

    @Command
    void onPreviewANSC() {
        if (atto && (!(wPreviewANSCOpen))) {
            if (atto?.idAtto) {
                String message = getMessageForNextAnscPageConfirm()
                if (message == null) {
                    goToNextAnscPage()
                } else {
                    Messagebox.show(message, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                            new org.zkoss.zk.ui.event.EventListener() {
                                void onEvent(Event e) {
                                    if (Messagebox.ON_YES.equals(e.getName())) {
                                        goToNextAnscPage()
                                    } else {
                                        caricaLista()
                                    }
                                }
                            }
                    )
                }
            }
        }
    }

    private String getMessageForNextAnscPageConfirm() {
        if (containsAllegatiObbligatoriNonInviati()) {
            return getEtichetta(Etichette.getEtichetta("Ask_salvataggio_allegati_obbligatori_incompleti_ANSC"))
        }
        if (containsNoneAllegatiObbligatori() && containsAllegatiNonObbligatoriNonInviati()) {
            return getEtichetta(Etichette.getEtichetta("Ask_salvataggio_allegati_non_obbligatori_incompleti_ANSC"))
        }
        return null
    }

    private Boolean containsAllegatiObbligatoriNonInviati() {
        List<AnscInfoAllegatoCdu> oggettiInvio = lista.findAll { it.isTipoAllegato() }.oggettiInvio.flatten() as List<AnscInfoAllegatoCdu>
        oggettiInvio = oggettiInvio.findAll { it.flagObbligatorio }
        int countAllegatiObbligatoriInviati = (int) oggettiInvio.count { it.ultimaComunicazione?.comunicazione?.inviato }
        return allegatiCounters.obbligatori > countAllegatiObbligatoriInviati
    }

    private Boolean containsNoneAllegatiObbligatori() {
        allegatiCounters.obbligatori == 0
    }

    private Boolean containsAllegatiNonObbligatoriNonInviati() {
        List<AnscInfoAllegatoCdu> oggettiInvio = lista.findAll { it.isTipoAllegato() }.oggettiInvio.flatten() as List<AnscInfoAllegatoCdu>
        oggettiInvio = oggettiInvio.findAll { !it.flagObbligatorio }
        int countAllegatiNonObbligatoriInviati = (int) oggettiInvio.count { it.ultimaComunicazione?.comunicazione?.inviato }
        return allegatiCounters.nonObbligatori > countAllegatiNonObbligatoriInviati
    }

    void goToNextAnscPage() {
        String uriANSC = FormUtils.getUriPreviewANSC(atto)
        if (uriANSC) {
            try {
                wPreviewANSCOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents(uriANSC, self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), casoUso: casoUso])
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

}
