package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneFormulaDettaglioViewModel extends DizionarioDettaglioViewModel {

    CivComunicazioneFormula dettaglio

    ETipoOperazione tipoOperazione

    final List<ETipoAnnotazione> listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
    ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue

    final List<ETipoIndividuiAtto> listaIndividui = ETipoIndividuiAtto.values()

    List<CivTipoDocumentoFascicolo> listaTipoDocumento

    @WireVariable
    private CivComunicazioneFormulaService civComunicazioneFormulaService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("comunicazione") CivComunicazione comunicazione){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazione_Formula")]
        eList.addAll(CivComunicazioneRelazioneBaseDomain.etichetteDomain)
        eList.addAll(CivComunicazioneRelazione2BaseDomain.etichetteDomain)
        eList.addAll(CivComunicazioneFormula.etichetteDomain)

        // Aggiungo etichette liste
        eList += ETipoAtto.values()*.getEtichettaDesc()
        eList += ETipoIndividuiAtto.values()*.getEtichettaDesc()
        eList += ETipoOrdinamentoAnnotazione.values()*.getEtichettaDesc()

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazione_Formula"))

        formLabel = msgTitle?.toUpperCase()

        tipoOrdinamentoDefaultValue = ETipoOrdinamentoAnnotazione.Tutte

        resize()

        listaTipoDocumento = [null] + civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(0)?.toList()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([comunicazione: comunicazione])
        }

    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civComunicazioneFormulaService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivComunicazioneFormula(comunicazione: params.comunicazione)
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivComunicazioneFormula c = civComunicazioneFormulaService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onSelectFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivFormulaAnnotazione) {
            dettaglio.formula = (CivFormulaAnnotazione) event.data
        } else {
            dettaglio.formula = null
        }
        refreshUi()
    }

    @Command void onCancellaFormulaAnnotazione() {
        onSelectFormulaAnnotazione(null)
    }

}

