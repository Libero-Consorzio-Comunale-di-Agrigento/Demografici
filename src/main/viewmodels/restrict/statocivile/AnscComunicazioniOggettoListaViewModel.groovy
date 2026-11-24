package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscComunicazioniOggettoListaViewModel extends AbstractListaViewModel{

    IAnscOggettoInvio oggettoInvio

    List<Map<String, String>> filtriList = []

    Component opener

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<IAnscComunicazione> lista = []
    IAnscComunicazione dettaglio

    @WireVariable
    private AnscComunicazioneService anscComunicazioneService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("oggettoInvio") IAnscOggettoInvio oggettoInvio) {
        self = w

        this.oggettoInvio = oggettoInvio

        this.opener = w.parent
        this.opener.addEventListener(CustomEvents.ON_REFRESH_DETAILS, new org.zkoss.zk.ui.event.EventListener() {
            void onEvent(Event event) {
                if (event) {
                    onRicarica()
                    caricaFiltriList()
                }
            }
        })

        List<Map> eList = [Etichette.getEtichetta("ANSC"), Etichette.getEtichetta("Chiudi"), Etichette.getEtichetta("Salta_controllo_dipendenze"), Etichette.getEtichetta("Salta_errore_http")]
        eList.addAll(AnscComunicazione.etichetteDomain)

        eList.addAll(etichetteListaDefault)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        pagingEnabled = true
        addEnabled = false
        modifyEnabled = false

        caricaFiltriList()

        msgTitle = getEtichetta(Etichette.getEtichetta("ANSC"))

        totalSizeLabel = ""

        caricaLista()
    }

    protected void caricaFiltriList(){
        filtriList = []
        if (oggettoInvio.getServizioCdu().servizioPrecedente){
            Long idRif = oggettoInvio.getIdDomain()
            Boolean invioDisabled = (idRif?isInvioServizioDisabled(oggettoInvio.getServizioCdu(), oggettoInvio.getTipoArchivioComunicazione(), idRif):Boolean.TRUE)
            if (invioDisabled){
                filtriList = []
            } else {
                filtriList << [codice: "SKIP", descrizione: getEtichetta(Etichette.getEtichetta("Salta_controllo_dipendenze"))]
            }
        }
        if (isLastComunicazioneInvalid(oggettoInvio)) {
            filtriList << [codice: "SKIP_HTTP_ERROR", descrizione: getEtichetta(Etichette.getEtichetta("Salta_errore_http"))]
        }
        filtriExtraEnabled = (filtriList.size() > 0)
        BindUtils.postNotifyChange(null, null, this, "filtriList")
        BindUtils.postNotifyChange(null, null, this, "filtriExtraEnabled")
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info("usePaging: " + usePaging)

        List<IAnscComunicazione> l = []
        if ( (oggettoInvio instanceof IAnscOggettoInvio) && oggettoInvio.getIdDomain()){
            l = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(oggettoInvio.getTipoArchivioComunicazione(), oggettoInvio.servizioCdu.servizio, oggettoInvio.getIdDomain())?:[])
        }

        return new Paginazione(l, l.size())
    }

    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRif){
        AnscEndPointServizio servizio = servizioCdu?.servizio
        if (servizio && anscComunicazioneService.isUltimaComunicazioneByArchivioRifAndServizioAndIdRifNonInviataCausaHttpError(archivioRif, servizio, idRif)) {
            return Boolean.TRUE
        }
        if (servizio && (!(servizio.flagRipetizione))){
            return anscComunicazioneService.esisteComunicazioneInviataByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        if (servizio && servizio.flagRipetizione){
            return anscComunicazioneService.esisteComunicazioneNonInviataByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        return Boolean.TRUE
    }

    Boolean isLastComunicazioneInvalid(IAnscOggettoInvio oggettoInvio) {
        AnscEndPointServizio servizio = oggettoInvio.servizioCdu?.servizio
        if (!servizio) {
            return Boolean.FALSE
        }
        Long idRif = oggettoInvio.getIdDomain()
        return anscComunicazioneService.isUltimaComunicazioneByArchivioRifAndServizioAndIdRifNonInviataCausaHttpError(oggettoInvio.getTipoArchivioComunicazione(), servizio, idRif)
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onFiltriPlus(@BindingParam("codice") String codice) {
        if (filtriExtraEnabled){
            switch (codice) {
                case "SKIP":
                    Events.sendEvent(CustomEvents.ON_SKIP_CHECK, self, null)
                    break
                case "SKIP_HTTP_ERROR":
                    Events.sendEvent(CustomEvents.ON_SKIP_HTTP_ERROR, self, null)
                    break
            }
        }
    }

}
