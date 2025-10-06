package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizione
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizioneService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RichiamoComposizioneDettaglioViewModel extends AbstractDettaglioViewModel{

    CivRichiamoComposizione dettaglio

    ETipoAtto tipoAttoEnum

    ETipoOperazione tipoOperazione

    @WireVariable
    private CivRichiamoComposizioneService civRichiamoComposizioneService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Richiamo_Composizione, Etichette.Formule_Associate]
        eList.addAll(etichetteDettaglioDefault)
        eList.addAll(CivRichiamoBaseDomain.etichetteDomain)
        eList.addAll(CivRichiamoComposizione.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList += ETipoAtto.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Richiamo_Composizione)

        formLabel = msgTitle?.toUpperCase()

        resize()

        // Per label da esibire nello zul
        this.tipoAttoEnum = tipoAttoEnum

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio(tipoAtto: new Integer(tipoAttoEnum.valore))
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civRichiamoComposizioneService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivRichiamoComposizione(params)
        tipoOperazione = ETipoOperazione.INS
    }

    String getUriListaDettaglio(){
        String uri = ""
        if (tipoOperazione.isUpdate()) {
            uri = "/restrict/statocivile/dizionari/tipoAtto/richiamoFormulaLista.zul"
        }
        return uri
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivRichiamoComposizione c = civRichiamoComposizioneService.save(dettaglio)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
