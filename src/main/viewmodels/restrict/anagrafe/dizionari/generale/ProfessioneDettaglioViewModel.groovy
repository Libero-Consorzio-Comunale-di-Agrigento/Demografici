package restrict.anagrafe.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaProfessione
import it.finmatica.de4gsdzk.anagrafe.AnaProfessioneService
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceProfessione
import it.finmatica.de4gsdzk.anagrafe.AnpCodiceProfessioneService
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ProfessioneDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    AnaProfessione dettaglio

    ETipoOperazione tipoOperazione

    List<ESesso> listaSesso = ESesso.values() as List
    List<AnpCodiceProfessione> listaAnpCodiceProfessione = []

    @WireVariable
    private AnaProfessioneService anaProfessioneService

    @WireVariable
    private AnpCodiceProfessioneService anpCodiceProfessioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Professioni")]
        eList.addAll(AnaProfessione.etichetteDomain)
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Professioni"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaAnpCodiceProfessione()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaAnpCodiceProfessione() {
        listaAnpCodiceProfessione = [null]
        List<AnpCodiceProfessione> l = anpCodiceProfessioneService.listAll()
        if (l.size() > 0) {
            listaAnpCodiceProfessione.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaProfessioneService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaProfessione(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            AnaProfessione c = anaProfessioneService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id.padRight(5, '0'))
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

}