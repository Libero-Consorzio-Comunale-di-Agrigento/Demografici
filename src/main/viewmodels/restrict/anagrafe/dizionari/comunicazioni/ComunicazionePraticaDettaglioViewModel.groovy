package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaEventoPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaEventoPraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazione
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePraticaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.ETipoPratica
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
class ComunicazionePraticaDettaglioViewModel extends DizionarioDettaglioViewModel {

    AnaComunicazionePratica dettaglio

    ETipoOperazione tipoOperazione

    List<AnaEventoPratica> listaEventi = [null]


    @WireVariable
    private AnaComunicazionePraticaService anaComunicazionePraticaService

    @WireVariable
    private AnaEventoPraticaService anaEventoPraticaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("id") String id,
         @ExecutionArgParam("comunicazione") AnaComunicazione comunicazione,
         @ExecutionArgParam("archivioAnagrafe") ETipoAnagrafe archivioAnagrafe,
         @ExecutionArgParam("tipoPratica") ETipoPratica tipoPratica) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Pratiche")]
        eList.addAll(AnaComunicazionePratica.etichetteDomain)

        // Aggiungo etichette tipo anagrafe e tipo pratica
        eList += ETipoAnagrafe.values()*.getEtichettaDesc() as Map
        eList += ETipoPratica.values()*.getEtichettaDesc() as Map

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Pratiche"))
        formLabel = msgTitle?.toUpperCase()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([comunicazione : comunicazione,  archivioAnagrafe: archivioAnagrafe, tipoPratica: tipoPratica])
        }

        listaEventi.addAll(anaEventoPraticaService.findAllByArchivioAnagrafeAndTipoPratica(dettaglio.archivioAnagrafe, dettaglio.tipoPratica))
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaComunicazionePraticaService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaComunicazionePratica()
        dettaglio.comunicazione = params.comunicazione
        dettaglio.archivioAnagrafe = params.archivioAnagrafe
        dettaglio.tipoPratica = params.tipoPratica
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            try {
                dettaglio = anaComunicazionePraticaService.save(tipoOperazione, dettaglio)
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                caricaDettaglio(dettaglio.id)
            } catch (CampoMandatoryRuntimeException e) {
                Messagebox.show(getEtichetta(e.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } catch (RecordDuplicatoRuntimeException e) {
                Messagebox.show(getEtichetta(e.getEtichetta()), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }


}