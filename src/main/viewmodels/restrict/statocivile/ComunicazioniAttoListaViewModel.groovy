package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAttoAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioniAttoListaViewModel extends ComunicazioniAttoListaParentViewModel{

    Boolean priorita

    Boolean wPreviewFascicoloOpen = Boolean.FALSE

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum,
               @ExecutionArgParam("priorita") Boolean priorita){
        self = w

        showDetailsComunicazione = Boolean.TRUE
        showRecapMessage = Boolean.FALSE

        backFromListComunicazioneEnabled = true
        addComunicazioneEnabled = true
        generaTestoComunicazioneEnabled = true
        goToFascicoloEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Data_Redazione_Atto_Originale"), Etichette.getEtichetta("SEZIONE_COMUNICAZIONI_ATTO")]

        eList.addAll(etichetteComunicazioniDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarComunicazioniAttributes.etichetteCbComListDesc)
        eList.addAll(ControlBarAttoAttributes.etichetteCbAttoDesc)

        // Aggiungo etichette delle Comunicazioni
        eList.addAll(CivArchivioComunicazione.etichetteDomain)
        eList.addAll(CivComunicazioneProtocollo.etichetteDomain)
        eList.addAll(CivComunicazioneDestinatario.etichetteDomain)
        eList.addAll(CivComunicazioneAllegato.etichetteDomain)

        // Aggiungo etichette stato comunicazione
        eList.addAll(Arrays.asList(EStatoProtocollazione.values())*.etichettaDesc)
        // Aggiungo etichette stato invio all'albo
        eList.addAll(Arrays.asList(EStatoInvioAlbo.values())*.etichettaDesc)

        this.priorita = priorita

        leggiParametri()

        doInit(eList, pkAtto, tipoAttoEnum) //carica anche atto e dati provenienza

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))
        formLabel = getEtichetta(Etichette.getEtichetta("SEZIONE_COMUNICAZIONI_ATTO")) + (priorita?" (${getEtichetta(Etichette.getEtichetta("adempimenti_tooltip"))})":"")

        resize()

        caricaLista()
    }

    boolean getLoadOnCloseData(){
        return true
    }

    void caricaLista() {
        listaComunicazioniSelezionate = []

        massiveCheck = Boolean.FALSE

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        resetDettaglio()

        setAttributiElaborazione()

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)
        List<CivArchivioComunicazione> l = civArchivioComunicazioneService.listAllByUkAttoAndTipoAtto(atto.getTipoAtto(), atto.ufficio, atto.anno, atto.atto, atto.parte, atto.serie,
                [priorita: priorita, fetch: [[campo:'comunicazione', tipo: JoinType.INNER], [campo:'formulaDfa', tipo: JoinType.LEFT]],
                 order: SortUtils.dataRegistrazioneAsc ])?:[]

        List<CivArchivioComunicazione> ll = (civArchivioComunicazioneService.listAllComunicazioniDaAnnotazioneByUkAtto(atto, datiProvenienza, priorita)?:[])
        l.addAll(ll)

        return new Paginazione(l, l.size())
    }

    @Command void onInserisci() {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/comunicazioniAttoSelect.zul", self, [atto: atto, priorita: priorita])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            onRicarica()
            if (event.data.idComunicazioneAtto instanceof Long){
                Long idComunicazioneAtto = event.data.idComunicazioneAtto
                for (CivArchivioComunicazione ac : lista){
                    if (ac.id.compareTo(idComunicazioneAtto) == 0){
                        setDettaglio(ac)
                        break
                    }
                }
            }
        })
        w.doModal()
    }

    @Command void onPreviewFascicolo(){
        if (wPreviewFascicoloOpen){
            return
        }
        apriPreviewFascicolo()
    }

    void apriPreviewFascicolo(){
        if (atto?.id && (!(wPreviewFascicoloOpen)) ) {
            try{
                wPreviewFascicoloOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/fascicoloAttoLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum()])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    onPagina()
                    self.setVisible(true)
                    wPreviewFascicoloOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form fascicolo atto", ex)
                wPreviewFascicoloOpen = Boolean.FALSE
                throw ex
            }
        }
    }

}
