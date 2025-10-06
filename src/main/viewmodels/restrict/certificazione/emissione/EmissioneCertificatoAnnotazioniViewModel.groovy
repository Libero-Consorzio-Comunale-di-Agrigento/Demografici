package restrict.certificazione.emissione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.RiferimentiAttoListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EmissioneCertificatoAnnotazioniViewModel extends RiferimentiAttoListaParentViewModel {

    List<ETipoAnnotazione> listaTipoAnnotazione
    List<CivAnnotazioneAtto> lista
    CivAnnotazioneAtto dettaglio

    Boolean anscOn = Boolean.FALSE

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        modifyEnabled = false
        addEnabled = false

        List<Map> eList = [Etichette.Annotazioni, Etichette.SEZIONE_ANNOTAZIONI_ATTO, Etichette.Comune, Etichette.Data_Redazione_Atto_Originale, Etichette.Del, Etichette.Annotazione, Etichette.Modello_Personalizzato]
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarAnnotazioniAttributes.etichetteCbAnnListDesc)

        // Aggiungo etichette delle Annotazioni
        eList.addAll(CivAnnotazioneAtto.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette sul tipo delle Annotazioni
        listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
        eList.addAll(listaTipoAnnotazione*.etichettaDesc)

        //Aggiungo etichette pulsanti
        eList.addAll([Etichette.Conferma, Etichette.Chiudi])

        doInit(eList, pkAtto, tipoAttoEnum)

        msgTitle = getEtichetta(Etichette.Annotazioni)
        formLabel = getEtichetta(Etichette.SEZIONE_ANNOTAZIONI_ATTO)

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(SortUtils.dataRegistrazioneDesc))
        Page<CivAnnotazioneAtto> p = civAnnotazioneAttoService.listAllByUkAttoAndTipoAttoAndTipoIn(atto.idAtto, atto.tipoAtto, listaTipoAnnotazione, pr)
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onConferma() {
        civAnnotazioneAttoService.updateStampaEstrattoSuListaAnnotazioni(lista)
        Events.sendEvent(CustomEvents.ON_CER_EMISSIONE_ANNOTAZIONI_ATTO_SAVE, self, [:])
        Events.sendEvent(CustomEvents.ON_CER_EMISSIONE_COMPLETE, self, [:])

        onChiudi()
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Override
    boolean getLoadOnCloseData() {
        return false
    }
}
