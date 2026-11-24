package restrict.elettorale.dizionari.wsMinisteriali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.De4Elezione
import it.finmatica.de4gsdzk.elettorale.De4ElezioneService
import it.finmatica.de4gsdzk.elettorale.EleCandidatoWs
import it.finmatica.de4gsdzk.elettorale.EleCandidatoWsService
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
class CandidatoWsDettaglioViewModel extends DizionarioDettaglioViewModel {

    EleCandidatoWs dettaglio
    ETipoOperazione tipoOperazione

    List<De4Elezione> elezioniList

    @WireVariable
    private EleCandidatoWsService eleCandidatoWsService

    @WireVariable
    private De4ElezioneService de4ElezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("elezione") EleElezione elezione) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Candidati_Ws"), Etichette.getEtichetta("Codice_Provincia"), Etichette.getEtichetta("Descrizione_Provincia")]
        eList.addAll(EleCandidatoWs.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Candidati_Ws"))
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
        dettaglio = eleCandidatoWsService.get(id as Long)
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new EleCandidatoWs(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            EleCandidatoWs c = eleCandidatoWsService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }
}
