package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
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
class ComunicazioneAttoDettaglioViewModel extends DizionarioDettaglioViewModel
                implements TraitGestioneTestiModelloRelazione {

    CivComunicazioneAtto dettaglio

    ETipoOperazione tipoOperazione

    ETipoAtto tipoAttoEnum

    final List<ETipoIndividuiAtto> listaIndividui = ETipoIndividuiAtto.values()
    final List<ENaturaAtto> listaNature = [null]
    final List<EFormatoTesto> listaFormatiTesto = [null] + EFormatoTesto.values().toList()

    List<CivTipoDocumentoFascicolo> listaTipoDocumento

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id,
               @ExecutionArgParam("tipoAtto") Integer tipoAtto, @ExecutionArgParam("comunicazione") CivComunicazione comunicazione){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazione_Atto"), Etichette.getEtichetta("Tipo_Atto")]
        eList.addAll(CivComunicazioneRelazioneBaseDomain.etichetteDomain)
        eList.addAll(CivComunicazioneRelazione2BaseDomain.etichetteDomain)
        eList.addAll(CivComunicazioneAtto.etichetteDomain)
        eList.addAll(GestioneTestiGsdModello.etichetteDomain)

        // Aggiungo etichette liste
        eList.addAll(ETipoAtto.values()*.getEtichettaDesc())
        eList.addAll(ETipoIndividuiAtto.values()*.getEtichettaDesc())
        eList.addAll(ENaturaAtto.values()*.getEtichettaDesc())

        // Aggiungo etichette modello
        eList.addAll(etichetteGteModelloDefault)

        // Aggiungo etichette File
        eList.addAll(FileUtils.etichetteFileUtils)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazione_Atto"))

        formLabel = msgTitle?.toUpperCase()

        doInitModelloRelazione(gestioneTestiModelloRelazioneService)

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAtto: tipoAtto, comunicazione: comunicazione])
        }

        this.tipoAttoEnum = TipoAttoUtils.fromValoreDefault(dettaglio.tipoAtto)

        listaTipoDocumento = [null] + civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoAttoEnum)?.toList()

        // Carica le nature in base al tipo atto
        listaNature.addAll(NaturaUtils.getValoriByTipoAtto(tipoAttoEnum))
        listaNature.remove(ENaturaAtto.N)
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civComunicazioneAttoService.get(id)
            creaModelloRelazione(dettaglio)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivComunicazioneAtto(params)
        GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: EAmbito.CO, gruppo: EGruppo.CIV)
        creaModelloRelazione(comunicazioneAtto: dettaglio, modello: modello)
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            salvaComunicazioneAtto()
        }
    }

    void salvaComunicazioneAtto(boolean force=false) {
        try {
            CivComunicazioneAtto c = civComunicazioneAttoService.save(dettaglio, modelloRelazione, force)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch(FileNonValidoRuntimeException fnv) {
            log.warn(fnv.getMessage())
            Messagebox.show( (getEtichetta(fnv.getEtichetta())?:fnv.getMessage()) + "\n" + (fnv.getAdditionalInfo()?:"") + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK == e.getName()) {
                            salvaComunicazioneAtto(true)
                        }
                    }
                }
            )
        }
    }

}
