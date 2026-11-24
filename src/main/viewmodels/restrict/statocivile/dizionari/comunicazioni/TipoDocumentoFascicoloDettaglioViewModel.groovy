package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicoloService
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
class TipoDocumentoFascicoloDettaglioViewModel extends DizionarioDettaglioViewModel{

    CivTipoDocumentoFascicolo dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = []
        eList.addAll(CivTipoDocumentoFascicolo.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Tipo_Documento_Fascicolo"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoEnum: tipoAttoEnum])
        }
    }

    void caricaDettaglio(def id) {
        dettaglio = civTipoDocumentoFascicoloService.get(id)
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivTipoDocumentoFascicolo(tipoAtto: new Integer(params.tipoAttoEnum.valore))
        tipoOperazione = ETipoOperazione.INS
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivTipoDocumentoFascicolo c = civTipoDocumentoFascicoloService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
