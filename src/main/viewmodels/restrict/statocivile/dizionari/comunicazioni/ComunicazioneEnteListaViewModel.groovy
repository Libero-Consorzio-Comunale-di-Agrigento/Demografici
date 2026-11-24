package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneEnte
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneEnteService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
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

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<ETipoComunicazione> listaTipiComunicazione
    ETipoComunicazione tipoComunicazione

    List<ETipoAtto> listaTipiAtto = []
    ETipoAtto tipoAttoEnum

    @WireVariable
    private CivComunicazioneEnteService civComunicazioneEnteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Comunicazioni_Ente")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_comunicazione"), Etichette.getEtichetta("Compilare_tipo_atto")])

        eList.addAll(CivComunicazioneEnte.etichetteDomain)


        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])



        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault
        listaTipiComunicazione = ETipoComunicazione.values()

        // etichette delle enum
        eList += listaTipiComunicazione*.getEtichettaDesc() as Map
        eList += listaTipiAtto*.getEtichettaDesc() as Map

        doInit(w, eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni_Ente"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), [new Sort.Order(Sort.Direction.ASC, "comunicazione.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), [new Sort.Order(Sort.Direction.DESC, "comunicazione.descrizione")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), [new Sort.Order(Sort.Direction.ASC, "comunicazione.id")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), [new Sort.Order(Sort.Direction.DESC, "comunicazione.id")])])

        selectedOrder = listaOrder[0]
    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder?.campi))
        Page<CivComunicazioneEnte> p = null
        if (tipoComunicazione == null){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
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
        return "dizionari/comunicazioni/comunicazioneEnteDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            if (!tipoComunicazione) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else if (!tipoComunicazione.isAnnotazione() && !tipoAttoEnum) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                apriDettaglio(getUriDettaglio(), [tipoAtto: tipoAttoEnum?.valore?:0])
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
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
            return (dettaglio.comunicazione.descrizioneEstesa + " - " + dettaglio.ente.descrizioneEstesa + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    @Command void onSelectTipoComunicazione() {
        tipoAttoEnum = null
        comunicazione = null
        onRicarica()
    }

}
