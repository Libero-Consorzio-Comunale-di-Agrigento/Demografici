package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneEnte
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneEnteService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneEnteListaViewModel extends ComunicazioneBaseDomainListaParentViewModel<CivComunicazioneEnte> {

    List<ETipoComunicazione> listaTipiComunicazione
    ETipoComunicazione tipoComunicazione

    List<ETipoAtto> listaTipiAtto = []
    ETipoAtto tipoAttoEnum

    @WireVariable
    private CivComunicazioneEnteService civComunicazioneEnteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map<String, String>> eList = [Etichette.Tipo, Etichette.Tipo_Atto, Etichette.Comunicazioni_Ente]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_comunicazione, EtichetteMessaggi.Compilare_tipo_atto])

        eList.addAll(CivComunicazioneEnte.etichetteDomain)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault
        listaTipiComunicazione = ETipoComunicazione.values()

        // etichette delle enum
        eList += listaTipiComunicazione*.getEtichettaDesc() as Map
        eList += listaTipiAtto*.getEtichettaDesc() as Map

        doInit(w, eList)

        msgTitle = getEtichetta(Etichette.Comunicazioni_Ente)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE)
        Page<CivComunicazioneEnte> p = null
        if (tipoComunicazione == null){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_comunicazione), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            if (tipoComunicazione?.isAnnotazione() || tipoAttoEnum) {
                if (tipoComunicazione?.isAnnotazione() && (comunicazione != null)){
                    p = civComunicazioneEnteService.listAllByTipoAttoAndComunicazione(0, comunicazione, pr)
                } else {
                    p = civComunicazioneEnteService.listAllByTipoAtto(tipoAttoEnum?.valore?:0, pr)
                }
            }
        }
        return new Paginazione(p?.getContent()?:[], p?.getTotalElements()?:0)
    }

    String getUriDettaglio(){
        return "dizionari/comunicazione/comunicazioneEnteDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            if (!tipoComunicazione) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_comunicazione), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else if (!tipoComunicazione.isAnnotazione() && !tipoAttoEnum) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                apriDettaglio(getUriDettaglio(), [tipoAtto: tipoAttoEnum?.valore?:0])
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectComunicazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivComunicazione) {
            comunicazione = (CivComunicazione) event.data
        } else {
            comunicazione = null
        }
        onRicarica()
    }

    @Command void onCancellaComunicazione() {
        onSelectComunicazione(null)
    }

    void eliminaRelazione(CivComunicazioneEnte c){
        if (deleteEnabled && userModifyEnabled) {
            civComunicazioneEnteService.delete(c)
            onRicarica()
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.comunicazione) {
            return (dettaglio.comunicazione.descrizioneEstesa + " - " + dettaglio.ente.descrizioneEstesa + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    @Command void onSelectTipoComunicazione() {
        tipoAttoEnum = null
        comunicazione = null
        onRicarica()
    }

}
