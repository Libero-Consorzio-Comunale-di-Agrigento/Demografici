package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneAttoListaViewModel extends ComunicazioneBaseDomainListaParentViewModel<CivComunicazioneAtto> {

    final List<ETipoAtto> listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault

    final List<Map> addPlusList = []

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("comunicazione") CivComunicazione comunicazione,
               @ExecutionArgParam("opener") Component opener) {

        addEnabled = false
        addPlusEnabled = true
        pagingEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazioni_Atto")]

        eList.addAll(CivComunicazioneRelazione2BaseDomain.etichetteDomain)
        eList.addAll(CivComunicazioneAtto.etichetteDomain)

        // etichette delle enum
        eList.addAll(ETipoAtto.values()*.getEtichettaDesc())
        eList.addAll(ENaturaAtto.values()*.getEtichettaDesc())

        doInit(w, eList)

        // Devo ricaricare la comunicazione perché l'include prende in maniera statica i parametri
        this.comunicazione = civComunicazioneService.get(comunicazione.id)
        this.opener = opener

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni_Atto"))

        caricaLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info ("usePaging: " + usePaging)
        List<CivComunicazioneAtto> l = civComunicazioneAttoService.listAllByComunicazione(comunicazione)

        // aggiunge i tipi atto mancanti al menu +
        addPlusList.clear()
        List<Integer> tipiAtto = l.collect {it.tipoAtto}
        for (ETipoAtto tipoAttoEnum : listaTipiAtto) {
            if (!tipiAtto.contains(tipoAttoEnum.valore)) {
                addPlusList.add([id: tipoAttoEnum.id, idDomain: tipoAttoEnum.valore, descrizione: getEtichettaEnum(tipoAttoEnum), tipo: "T"])
            }
        }

        return new Paginazione(l, l.size())
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazioni/comunicazioneAttoDettaglio.zul"
    }

    @Command void onInserisciPlus(@BindingParam("idDomain") Integer tipoAtto) {
        if (addPlusEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), opener, [tipoAtto: tipoAtto, comunicazione: comunicazione])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void eliminaRelazione(CivComunicazioneAtto c){
        if (deleteEnabled && userModifyEnabled) {
            civComunicazioneAttoService.delete(c)
            onRicarica()
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.comunicazione) {
            return (dettaglio.comunicazione.descrizioneEstesa + " - " + getLabelTipoAtto(dettaglio) + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")))
        }
        return ""
    }

    String getLabelTipoAtto(CivComunicazioneAtto ca) {
        getEtichettaEnum(TipoAttoUtils.fromValoreDefault(ca.tipoAtto))
    }

}
