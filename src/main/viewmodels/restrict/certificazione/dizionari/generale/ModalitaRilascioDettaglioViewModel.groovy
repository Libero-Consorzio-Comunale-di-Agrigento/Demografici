package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anpr.AnprMotivoEsenzioneBollo
import it.finmatica.de4gsdzk.anpr.AnprMotivoEsenzioneBolloService
import it.finmatica.de4gsdzk.ansc.AnscMotivoEsenzioneBollo
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitCancellazioneCampi
import restrict.statocivile.DizionarioDettaglioViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModalitaRilascioDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitCancellazioneCampi {

    CerModalitaRilascio dettaglio

    ETipoOperazione tipoOperazione

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]

    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = []
    List<CerTariffaDiritto> listaTariffaDiritto = []

    @WireVariable
    private CerModalitaRilascioService cerModalitaRilascioService

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @WireVariable
    private AnprMotivoEsenzioneBolloService anprMotivoEsenzioneBolloService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Modalita_rilascio")]
        eList.addAll(CerModalitaRilascio.etichetteDomain)

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        // Aggiungo etichette categoria certificato
        eList.addAll(CerCategoriaTipoCertificato.etichetteDomain)

        // Aggiungo etichette competenze
        eList.addAll(ETipoCompetenzaCertificazioneOnLine.values()*.getEtichettaDesc())

        // Aggiungo etichette per tipi generazione esterne
        eList.addAll(ETipoGenerazioneCertificato.values().findAll { it.isGenerazioneEsterna() }*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modalita_rilascio"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaListaCategoriaTipoCertificato()
        caricaListaTariffaDiritto()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaListaCategoriaTipoCertificato() {
        listaCategoriaTipoCertificato = [null]
        List<CerCategoriaTipoCertificato> l = cerCategoriaTipoCertificatoService.listAll()
        if (l.size() > 0) {
            listaCategoriaTipoCertificato.addAll(l)
        }
    }

    void caricaListaTariffaDiritto() {
        listaTariffaDiritto = [null]
        List<CerTariffaDiritto> l = cerModalitaRilascioService.listAllTariffaDirittoByDirittoBollo()
        if (l.size() > 0) {
            listaTariffaDiritto.addAll(l)
        }
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = cerModalitaRilascioService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CerModalitaRilascio(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSelectCategoria() {
        resetMotivoEsenzioneBollo()
        refreshUi()
    }

    private void resetMotivoEsenzioneBollo() {
        if (dettaglio.motivoEsenzioneBollo == null) {
            return
        }
        if (dettaglio.categoriaTipoCertificato.isStatoCivile() &&
                dettaglio.motivoEsenzioneBollo instanceof AnscMotivoEsenzioneBollo) {
            return
        }
        if (dettaglio.categoriaTipoCertificato.isAnagrafe() &&
                dettaglio.motivoEsenzioneBollo instanceof AnprMotivoEsenzioneBollo) {
            return
        }
        dettaglio.motivoEsenzioneBollo = null
    }

    @Command
    void onSelectFasciaTariffaria() {
        refreshUi()
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            CerModalitaRilascio c = cerModalitaRilascioService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onCancellaCampoDizionario(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onCancellaCampo(e)
    }

    @Command
    void onSelectMotivoEsenzioneBollo(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CerMotivoEsenzioneBolloBaseDomain) {
            dettaglio.motivoEsenzioneBollo = (CerMotivoEsenzioneBolloBaseDomain) event.data
        } else {
            dettaglio.motivoEsenzioneBollo = null
        }
        refreshUi()
    }

    String getLabelMotivoEsenzioneBollo() {
        if (dettaglio.categoriaTipoCertificato?.isStatoCivile()) {
            return String.format(getEtichetta(Etichette.getEtichetta("Uso")), getEtichettaEnum(ETipoGenerazioneCertificato.ANSC))
        }
        if (dettaglio.categoriaTipoCertificato?.isAnagrafe()) {
            return String.format(getEtichetta(Etichette.getEtichetta("Uso")), getEtichettaEnum(ETipoGenerazioneCertificato.ANPR))
        }
        return String.format(getEtichetta(etichette, Etichette.getEtichetta("Uso")), "${getEtichettaEnum(etichette, ETipoGenerazioneCertificato.ANPR)}/${getEtichettaEnum(etichette, ETipoGenerazioneCertificato.ANSC)}")
    }

}
