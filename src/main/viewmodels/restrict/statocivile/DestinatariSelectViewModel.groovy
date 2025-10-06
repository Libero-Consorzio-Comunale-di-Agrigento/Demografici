package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneDestinatario
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneDestinatarioService
import it.finmatica.de4gsdzk.statocivile.CivEnte
import it.finmatica.de4gsdzk.statocivile.CivEnteService
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel
import restrict.TraitComune

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DestinatariSelectViewModel extends AbstractSelectViewModel implements TraitComune {

    List<ETipoEnteDestinatario> listaTipiEnte
    ETipoEnteDestinatario tipoEnteDestinatario

    List<Integer> idEntiDaEscludere
    List<String> idComuniDaEscludere

    List<CivEnte> listaEnti
    CivEnte ente
    ArcComune comune

    @WireVariable
    private CivEnteService civEnteService

    @WireVariable
    private CivComunicazioneDestinatarioService civComunicazioneDestinatarioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("idArcCom") Long idArcCom) {
        self = w

        List<Map<String, String>> eList = [Etichette.Destinatari, Etichette.Comune, Etichette.Ente]

        // Aggiungo etichette tipo ente destinatario
        // per lo stato civile elaboro solo enti e comuni;  rimando la gestione di consolati e individui; l'opzione ENTE deve essere l'ultima
        listaTipiEnte = [ETipoEnteDestinatario.COMUNE, ETipoEnteDestinatario.ENTE]
        eList.addAll(listaTipiEnte*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Destinatari)

        totalSizeLabel = ""

        List<CivComunicazioneDestinatario> listaDestinatariDaEscludere = civComunicazioneDestinatarioService.listAllByArchivioComunicazione(idArcCom)

        idEntiDaEscludere = []
        idComuniDaEscludere = []
        for (CivComunicazioneDestinatario d: listaDestinatariDaEscludere){
            if (d.comuneDomain?.id){
                idComuniDaEscludere.add(d.comuneDomain.id)
            }
            if (d.ente != null){
                idEntiDaEscludere.add(d.ente.id)
            }
        }
    }

    void caricaLista(){
        eseguiQuery(Boolean.TRUE)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        switch (tipoEnteDestinatario) {
            case ETipoEnteDestinatario.ENTE:
                ente = null
                if (idEntiDaEscludere.size() > 0){
                    listaEnti = civEnteService.listAllByTipoEnteDestinatarioAndIdNotIn(tipoEnteDestinatario, idEntiDaEscludere)
                } else {
                    listaEnti = civEnteService.listAllByTipoEnteDestinatario(tipoEnteDestinatario)
                }
                break
            case ETipoEnteDestinatario.COMUNE:
                comune = null
                break
            default:
                Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                break
        }
        return null
    }

    void resetDettaglio(){
        comune = null
        ente = null
        refreshUi()
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        if (tca == ETipoComuneAtto.CC_DEST) {
            comune = c
        }
        refreshUi()
    }

    @Command void onSeleziona() {
        Map params = [:]
        switch (tipoEnteDestinatario) {
            case ETipoEnteDestinatario.ENTE:
                params = [ente:ente, dettaglio:ente]
                break
            case ETipoEnteDestinatario.COMUNE:
                params = [ente:ente, dettaglio:comune]
                break
        }
        if (params.dettaglio == null){
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, params )
            onChiudi()
        }
    }

}
