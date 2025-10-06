package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscParametro
import it.finmatica.de4gsdzk.ansc.AnscParametroService
import it.finmatica.de4gsdzk.utils.*
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

        List<Map<String, String>> eList = [Etichette.Parametro]
        eList.addAll(AnscParametro.etichetteDomain)
        eList.addAll(FileUtils.etichetteFileUtils)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Parametro)

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
        List<String> formatiAmmessi = [ETipoFile.P12.contentType]
        Map m = FileUtils.checkFile(_allegato, media.name, formatiAmmessi)
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
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
