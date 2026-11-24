package it.finmatica.de4gsdzk.zkutils

import groovy.transform.CompileStatic
import it.finmatica.ad4.security.SpringSecurityService
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileInputStreamDeleteOnClose
import it.finmatica.webscan.WebScanCallback
import it.finmatica.webscan.WebScanService
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Toolbarbutton
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta as getEtichetta

@CompileStatic
@VariableResolver(DelegatingVariableResolver)
class ScanToolbarbutton extends Toolbarbutton implements EventListener<Event>, WebScanCallback {

    Map<String, String> etichette = [:]
    String msgTitle

    @WireVariable
    private SpringSecurityService springSecurityService

    @WireVariable
    private WebScanService webScanService

    // Salvo localmente i file scansionati. È 'accettabile' che la popup di scansione serva per 'un solo file' anche se la stessa consente la scansione di più file alla volta.
    private File fileStore
    private String fileName
    private String contentType
    private long idCallback

    private String nomeFileScansioneDefault = 'scansione'
    private boolean isPdf = true

    ScanToolbarbutton() {
        setImage('/images/icon/action/22x22/scanner.png')
        setAutodisable('self')
        //setMold('trendy')

        List<Map<String, String>> eList = [Etichette.getEtichetta("Scansione"), Etichette.getEtichetta("Scansione_Annullata"), Etichette.getEtichetta("scansione_tooltip")]
        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(etichette, Etichette.getEtichetta("Scansione"))

        setTooltiptext(getEtichetta(etichette, Etichette.getEtichetta("scansione_tooltip")))

        Selectors.wireVariables(this, this, Selectors.newVariableResolvers(getClass(), Toolbarbutton))

        addEventListener(Events.ON_CLICK, this)
    }

    @Override
    void onEvent(Event event) throws Exception {
        if (event.name == Events.ON_CLICK) {
            apriPopupScansione()
        } else if (event.name == Events.ON_CLOSE) {
            onChiudiPopupScansione(event)
        }
    }

    private void apriPopupScansione() {
        idCallback = webScanService.registerCallback(this, getNominativoUtente())

        boolean scansioneDiretta = false

        String urlScansione = webScanService.buildUrlWebScan(idCallback, scansioneDiretta, isPdf)
        Window popupScansione = (Window) Executions.createComponents('/restrict/afc/popupScansione.zul', null, [urlScansione: urlScansione, nomeFileScansionatoPlaceholder:nomeFileScansioneDefault])
        popupScansione.addEventListener(Events.ON_CLOSE, this)
        popupScansione.doModal()
    }

    private void onChiudiPopupScansione(Event event) {
        if (isPdf) {
            LinkedHashMap<String, String> eventData = (LinkedHashMap<String, String>)event?.data
            fileName = (eventData?.nomeFileScansionato?:nomeFileScansioneDefault) + "." + ETipoFile.PDF.estensione
        }

        // se non ho il file salvato, significa che ho annullato la scansione e non faccio nulla.
        if (fileStore == null) {
            Messagebox.show(getEtichetta(etichette, Etichette.getEtichetta("Scansione_Annullata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            return
        }
        // Eventuali controlli

        Events.postEvent(new ScanEvent(this, new FileInputStreamDeleteOnClose(fileStore),fileName, contentType))

        webScanService.unregisterCallback(idCallback)
        // svuoto i campi
        idCallback = -1
        fileStore = null
        fileName = null
        contentType = null
    }

    private String getNominativoUtente() {
        return springSecurityService.principal.username
    }

    @Override
    void callback(String nominativoUtente, String nomeFile, String contentType, InputStream inputStream) {
        fileStore = File.createTempFile("temp", "pdf")
        fileStore << inputStream
        this.fileName = nomeFile
        this.contentType = contentType
    }

}
