package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneService
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
class ComunicazioneDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitGestioneTestiModelloRelazione {

    CivComunicazione dettaglio

    ETipoOperazione tipoOperazione

    final List<ETipoComunicazione> listaTipiComunicazione = ETipoComunicazione.values()
    final List<EFormatoTesto> listaFormatiTesto = [null] + EFormatoTesto.values().toList()

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id) {
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazione"), Etichette.getEtichetta("Tipi_di_Atto"), Etichette.getEtichetta("Formule_Annotazione")]
        eList.addAll(CivComunicazione.etichetteDomain)
        eList.addAll(GestioneTestiGsdModello.etichetteDomain)

        // Aggiungo etichette tipo comunicazione
        eList.addAll(listaTipiComunicazione*.etichettaDesc)

        // Aggiungo etichette modello
        eList.addAll(etichetteGteModelloDefault)

        // Aggiungo etichette File
        eList.addAll(FileUtils.etichetteFileUtils)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazione"))

        formLabel = msgTitle?.toUpperCase()

        doInitModelloRelazione(gestioneTestiModelloRelazioneService)

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = civComunicazioneService.get(id)
            creaModelloRelazione(dettaglio)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        log.info ("Parametri gestiti: " + params?.size())
        dettaglio = new CivComunicazione()
        GestioneTestiGsdModello modello = new GestioneTestiGsdModello(ambito: EAmbito.CO, gruppo: EGruppo.CIV)
        creaModelloRelazione(comunicazione: dettaglio, modello: modello)
        tipoOperazione = ETipoOperazione.INS
        refreshUi()
    }

    String getUriListaDettaglio(){
        String uri = ""
        if (tipoOperazione.isUpdate() && (dettaglio.id?.intValue() > 0) ) {
            switch (dettaglio?.tipoComunicazione) {
                case ETipoComunicazione.A:
                    uri = "dizionari/comunicazioni/comunicazioneAttoLista.zul"
                    break
                case ETipoComunicazione.N:
                    uri = "dizionari/comunicazioni/comunicazioneFormulaLista.zul"
                    break
            }
        }
        return uri
    }

    String getLabelAssociazione(){
        String l = ""
        if (tipoOperazione.isUpdate() && (dettaglio.id?.intValue() > 0) ) {
            switch (dettaglio?.tipoComunicazione) {
                case ETipoComunicazione.A:
                    l = getEtichetta(Etichette.getEtichetta("Tipi_di_Atto"))
                    break
                case ETipoComunicazione.N:
                    l = getEtichetta(Etichette.getEtichetta("Formule_Annotazione"))
                    break
            }
        }
        return l
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            salvaComunicazione()
        }
    }

    void salvaComunicazione(boolean force=false) {
        try {
            CivComunicazione c = civComunicazioneService.save(tipoOperazione, dettaglio, modelloRelazione, force)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch(FileNonValidoRuntimeException fnv) {
            log.warn(fnv.getMessage())
            Messagebox.show((getEtichetta(fnv.getEtichetta())?:fnv.getMessage()) + "\n" + (fnv.getAdditionalInfo()?:"") + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK == e.getName()) {
                            salvaComunicazione(true)
                        }
                    }
                }
            )
        }
    }

}
