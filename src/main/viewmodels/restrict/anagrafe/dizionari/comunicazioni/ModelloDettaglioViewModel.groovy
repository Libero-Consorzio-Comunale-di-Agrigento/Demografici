package restrict.anagrafe.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModello
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaModelloService
import it.finmatica.de4gsdzk.errors.FileNameNonAttesoRuntimeException
import it.finmatica.de4gsdzk.utils.EFormatoTesto
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel
import restrict.statocivile.dizionari.comunicazioni.TraitGestioneTestiModelloRelazione

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModelloDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitGestioneTestiModelloRelazione {

    final List<EFormatoTesto> listaFormatiTesto = [null] + EFormatoTesto.values().toList()

    AnaModello dettaglio

    ETipoOperazione tipoOperazione

    List<ETipoModello> listaTipiModello = ETipoModello.values().toList()

    @WireVariable
    private AnaModelloService anaModelloService

    @WireVariable
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id, @ExecutionArgParam('tipoModello') ETipoModello tipoModello) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Modelli"), Etichette.getEtichetta("Ask_Conferma_Salvataggio")]
        eList.addAll(AnaModello.etichetteDomain)
        eList.addAll(ETipoModello.values()*.getEtichettaDesc())

        doInitModelloRelazione(gestioneTestiModelloRelazioneService)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modelli"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoModello: tipoModello])
        }
    }

    void caricaDettaglio(Object id) {
        if (id != null) {
            dettaglio = anaModelloService.get(id)
            creaModelloRelazione(dettaglio)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new AnaModello(params)
        creaModelloRelazione(dettaglio)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            salvaModello()
        }
    }

    void salvaModello(boolean force = false) {
        try {
            AnaModello c = anaModelloService.save(tipoOperazione, dettaglio, modelloRelazione, force)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch (FileNameNonAttesoRuntimeException fnv) {
            log.warn(fnv.getMessage())
            Messagebox.show(fnv.getMessage() + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK == e.getName()) {
                                salvaModello(true)
                            }
                        }
                    }
            )
        }
    }

}