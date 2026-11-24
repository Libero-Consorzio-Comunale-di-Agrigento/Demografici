package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoRichiesta
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoRichiestaService
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiesta
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiestaService
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MotivoRichiestaDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivMotivoRichiesta dettaglio

    ETipoOperazione tipoOperazione

    List<CivCategoriaTipoRichiesta> listaTipoRichiesta

    @WireVariable
    private CivMotivoRichiestaService civMotivoRichiestaService

    @WireVariable
    private CivCategoriaTipoRichiestaService civCategoriaTipoRichiestaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Motivo_richiesta")]
        eList.addAll(CivMotivoRichiesta.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Motivo_richiesta"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        dettaglio = civMotivoRichiestaService.get(id)
        tipoOperazione = ETipoOperazione.UPD
        listaTipoRichiesta = civCategoriaTipoRichiestaService.listAllByTipoAtto(dettaglio.tipoAttoEnum)
        refreshDettaglio()
    }

    void creaDettaglio(Map params){
        log.info ("not implemented - not necessary" + ". Parametri passati: " + params?.size())
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivMotivoRichiesta c = civMotivoRichiestaService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
