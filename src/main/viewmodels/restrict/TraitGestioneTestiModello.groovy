package restrict

import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileUtils
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zkmax.zul.Filedownload
import org.zkoss.zul.Messagebox

import java.nio.charset.StandardCharsets

trait TraitGestioneTestiModello {

    abstract String getMsgTitle()
    abstract void refreshUi()
    abstract String getEtichetta(Map<String, String> m)

    void uploadModello(UploadEvent event, GestioneTestiGsdModello modello) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map m = FileUtils.checkFile(_allegato, FileUtils.defaultAcceptableMimeTypesXModelli)
        if (m) {
            Messagebox.show(media.name + ":\n" + getEtichetta(m), getMsgTitle(), Messagebox.OK, Messagebox.ERROR)
        } else {
            modello.fileTemplate = _allegato
            modello.nome = media.name
            modello.tipo = media.format
        }
        refreshUi()
    }

    void downloadModello(GestioneTestiGsdModello m) {
        if (m?.fileTemplate){
            Filedownload.save(m.fileTemplate, FileUtils.getMimeType(m.tipo), m.nome)
        }
    }

    final List<Map<String, String>> etichetteGteModelloDefault = [Etichette.getEtichetta("Ask_Conferma_Salvataggio"), Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"),
                                                                  Etichette.getEtichetta("scarica_modello_tooltip"), Etichette.getEtichetta("inserisci_modello_tooltip"), Etichette.getEtichetta("scarica_origine_dati_tooltip")]

}