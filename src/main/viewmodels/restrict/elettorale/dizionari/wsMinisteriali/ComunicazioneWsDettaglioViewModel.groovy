package restrict.elettorale.dizionari.wsMinisteriali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.De4Elezione
import it.finmatica.de4gsdzk.elettorale.De4ElezioneService
import it.finmatica.de4gsdzk.elettorale.EleComunicazioneWs
import it.finmatica.de4gsdzk.elettorale.EleComunicazioneWsService
import it.finmatica.de4gsdzk.elettorale.EleElezione
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneWsDettaglioViewModel extends DizionarioDettaglioViewModel {

    EleComunicazioneWs dettaglio
    ETipoOperazione tipoOperazione

    List<De4Elezione> elezioniList

    @WireVariable
    private EleComunicazioneWsService eleComunicazioneWsService

    @WireVariable
    private De4ElezioneService de4ElezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("elezione") EleElezione elezione) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Comunicazioni_Ws"),
                           Etichette.getEtichetta("Codice_Tipo_Elettore"), Etichette.getEtichetta("Descrizione_Tipo_Elettore")]
        eList.addAll(EleComunicazioneWs.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni_Ws"))
        formLabel = msgTitle?.toUpperCase()

        elezioniList = de4ElezioneService.findAllByElezione(elezione)

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        dettaglio = eleComunicazioneWsService.get(id as Long)
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new EleComunicazioneWs(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            EleComunicazioneWs c = eleComunicazioneWsService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }
}
