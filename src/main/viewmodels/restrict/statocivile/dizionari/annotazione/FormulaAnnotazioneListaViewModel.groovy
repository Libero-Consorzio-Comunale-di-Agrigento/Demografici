package restrict.statocivile.dizionari.annotazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.GestioneTestiGsdTipoModello
import it.finmatica.de4gsdzk.GestioneTestiGsdTipoModelloService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitGestioneTestiModello
import restrict.statocivile.dizionari.FormulaListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaAnnotazioneListaViewModel extends FormulaListaParentViewModel implements TraitGestioneTestiModello {

    CivFormulaAnnotazione dettaglio

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    @WireVariable
    private GestioneTestiGsdTipoModelloService gestioneTestiGsdTipoModelloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        selectTipoOrdinamentoEnabled = true
        additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonDownloadOrigineDati.zul"
        additionalListaToolbarbutton2= "/restrict/afc/controlbar/toolbarbuttonDownloadAllegatoOld.zul"
        additionalListaToolbarbutton3= "/restrict/afc/controlbar/toolbarbuttonUploadAllegatoOld.zul"

        listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
        tipoOrdinamentoSelezionato = ETipoOrdinamentoAnnotazione.Tutte

        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

        List<Map<String, String>> eList = [Etichette.getEtichetta("Formule_Annotazione")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_modello_etichetta_non_trovato"), Etichette.getEtichetta("Salvataggio_Completato")])

        // Aggiungo etichette modello
        eList.addAll(etichetteGteModelloDefault)

        doInit(w, eList)

        etichetteCustom = ["scarica_allegato_tooltip": getEtichetta(Etichette.getEtichetta("scarica_modello_tooltip")), "inserisci_allegato_tooltip": getEtichetta(Etichette.getEtichetta("inserisci_modello_tooltip"))]

        msgTitle = getEtichetta(Etichette.getEtichetta("Formule_Annotazione"))

        formLabel = msgTitle?.toUpperCase()
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "dizionari/annotazione/formulaAnnotazioneDettaglio.zul"
    }

    String getUriDettaglioInfo(){
        return "dizionari/annotazione/formulaAnnotazioneDettaglioInfo.zul"
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivFormulaAnnotazione> p = null

        if (tipoAttoEnum != null) {
            Map params = [activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                          tipoAtto: new Integer(tipoAttoEnum.valore), tipiAnnotazione:listaTipoAnnotazione,
                          tipoOrdinamento: tipoOrdinamentoSelezionato, filtro: filtro, order: selectedOrder?.campi]

            p = civFormulaAnnotazioneService.list(params)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onModifica() {
        if (modifyAnnotazioneEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.tipoAtto.intValue() == tipoAttoEnum?.valore) {
                if (civFormulaAnnotazioneService.isAnnotazioneBloccata(dettaglio.id)){
                    apriDettaglio(getUriDettaglioInfo(), [id: dettaglio.id])
                } else {
                    apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_apertura_record")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onDownload() {
        GestioneTestiGsdModello m = gestioneTestiGsdModelloService.getByAmbitoEtichetta()
        if (m){
            downloadModello(m)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_modello_etichetta_non_trovato")), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
    }

    @Command void onUpload(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event) {
        GestioneTestiGsdModello g = gestioneTestiGsdModelloService.getByAmbitoEtichetta()
        if (g == null){
            GestioneTestiGsdTipoModello tm = gestioneTestiGsdTipoModelloService.get(GestioneTestiGsdTipoModello.TIPO_ETICHETTA_ANNOTAZIONE)
            g = new GestioneTestiGsdModello(codice: tm.id, descrizione: "etichetta", ambito: EAmbito.ET, gruppo: EGruppo.CIV, tipoModello: tm, valido: true)
        }
        uploadModello(event, g)
        gestioneTestiGsdModelloService.save(g)
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
    }

    @Command void onDownloadOrigineDati() {
        byte[] zip = gestioneTestiGsdModelloService.generateZipFromServer("/WEB-INF/originedati/civ")
        Filedownload.save(zip, ETipoFile.ZIP.contentType, "Civ.zip")
    }

}
