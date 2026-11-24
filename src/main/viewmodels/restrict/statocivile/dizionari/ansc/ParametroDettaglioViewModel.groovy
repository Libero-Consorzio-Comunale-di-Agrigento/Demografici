package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscParametro
import it.finmatica.de4gsdzk.ansc.AnscParametroService
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileUtils
import org.zkoss.bind.annotation.*
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ParametroDettaglioViewModel extends DizionarioDettaglioViewModel{

    AnscParametro dettaglio

    ETipoOperazione tipoOperazione

    @WireVariable
    private AnscParametroService anscParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") String id){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Parametro")]
        eList.addAll(AnscParametro.etichetteDomain)
        eList.addAll(FileUtils.etichetteFileUtils)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Parametro"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = anscParametroService.get(id)

            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        log.info ("not implemented" + ". Parametri passati: " + params?.size())
    }

    @Command void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event){
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map m = FileUtils.checkFile(_allegato, FileUtils.defaultAcceptableMimeTypesXP12)
        if (m) {
            Messagebox.show(media.name + ":\n" + getEtichetta(m), getMsgTitle(), Messagebox.OK, Messagebox.ERROR)
        } else {
            dettaglio.blobAllegato = _allegato
            onSalvaRecord()
        }
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            AnscParametro c = anscParametroService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
