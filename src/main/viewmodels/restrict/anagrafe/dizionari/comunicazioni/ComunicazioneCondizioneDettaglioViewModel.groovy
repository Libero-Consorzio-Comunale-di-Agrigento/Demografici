package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
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
class ComunicazioneCondizioneDettaglioViewModel extends DizionarioDettaglioViewModel {

    AnaCondizioneComunicazione dettaglio

    ETipoOperazione tipoOperazione

    List<AnaCondizioneSql> listaCondizioni = []

    @WireVariable
    private AnaCondizioneComunicazioneService anaCondizioneComunicazioneService

    @WireVariable
    private AnaCondizioneSqlService anaCondizioneSqlService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("comunicazione") AnaComunicazione comunicazione) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Condizioni")]
        eList.addAll(AnaCondizioneComunicazione.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Condizioni"))
        formLabel = msgTitle?.toUpperCase()


        List<Integer> codiciPresenti = anaCondizioneComunicazioneService.getCodiciCondizioneByComunicazione(comunicazione.id)
        creaDettaglio([comunicazione: comunicazione])
        if(codiciPresenti.size() > 0) {
            listaCondizioni = anaCondizioneSqlService.findAllByTipoComunicazioneAndIdNotIn(comunicazione.tipoComunicazione, codiciPresenti)
        } else {
            listaCondizioni = anaCondizioneSqlService.findAllByTipoComunicazione(comunicazione.tipoComunicazione)
        }

    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = anaCondizioneComunicazioneService.findById(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaCondizioneComunicazione()
        dettaglio.comunicazione = params.comunicazione
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            try {
                dettaglio = anaCondizioneComunicazioneService.save(tipoOperazione, dettaglio)
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
