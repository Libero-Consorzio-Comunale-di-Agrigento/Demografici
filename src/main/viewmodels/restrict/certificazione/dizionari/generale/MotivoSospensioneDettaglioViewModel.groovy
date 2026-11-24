package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprCertificabilita
import it.finmatica.de4gsdzk.anpr.AnprCertificabilitaService
import it.finmatica.de4gsdzk.anpr.AnprTutela
import it.finmatica.de4gsdzk.anpr.AnprTutelaService
import it.finmatica.de4gsdzk.certificazione.CerMotivoSospensione
import it.finmatica.de4gsdzk.certificazione.CerMotivoSospensioneService
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
class MotivoSospensioneDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi{

    List<AnprCertificabilita> listaCertificabilita = []
    List<AnprTutela> listaTutela = []

    CerMotivoSospensione dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private CerMotivoSospensioneService cerMotivoSospensioneService

    @WireVariable
    private AnprCertificabilitaService anprCertificabilitaService

    @WireVariable
    private AnprTutelaService anprTutelaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Motivo_sospensione")]
        eList.addAll(CerMotivoSospensione.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Motivo_sospensione"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaCertificabilita()

        caricaListaTutela()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaCertificabilita() {
        listaCertificabilita = anprCertificabilitaService.listAll()
    }

    void caricaListaTutela() {
        listaTutela = [null]
        List<AnprTutela> l = anprTutelaService.listAll()
        if (l.size() > 0) {
            listaTutela.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = cerMotivoSospensioneService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CerMotivoSospensione(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CerMotivoSospensione c = cerMotivoSospensioneService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

}
