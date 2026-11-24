package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.ETipoImage
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileUtils
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.zkutils.CustomAImage
import org.apache.tika.Tika
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkmax.zul.Filedownload
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractLogoListaViewModel extends DizionarioListaViewModel {

    Tuple2<ArcParametro, CustomAImage> dettaglio
    List<Tuple2<ArcParametro, CustomAImage>> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    protected ArcParametroService arcParametroService

    void doInit(Window w, List<Map<String, String>> eList = []) {
        self = w

        pagingEnabled = false
        modifyEnabled = false
        addEnabled = false

        eList.addAll(Etichette.getEtichetta("Loghi"))
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Salvataggio_Completato"), Etichette.getEtichetta("Ask_Caricamento_Logo"), Etichette.getEtichetta("Ask_Cancellazione_Logo")])

        eList.addAll([Etichette.getEtichetta("scarica_immagine_tooltip"), Etichette.getEtichetta("inserisci_immagine_tooltip"), Etichette.getEtichetta("Cancella")])

        eList.addAll(FileUtils.etichetteFileUtils)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Loghi"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio() {
        log.info("not implemented - not necessary")
        return ""
    }

    private void salvaLogo(ArcParametro logo) {
        arcParametroService.save(logo)
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
        onRicarica()
    }

    @Command
    void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event, @BindingParam("logo") ArcParametro logo) {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Caricamento_Logo")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK == e.getName()) {
                            Media media = event.media
                            byte[] _allegato = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
                            Map m = FileUtils.checkFile(_allegato, FileUtils.defaultAcceptableMimeTypesXImg)
                            if (m) {
                                Messagebox.show(media.name + ":\n" + getEtichetta(m), getMsgTitle(), Messagebox.OK, Messagebox.ERROR)
                            } else {
                                logo.blobAllegato = _allegato
                                salvaLogo(logo)
                            }
                        }
                    }
                })
    }

    @Command
    void onDownloadAllegato(@BindingParam("logo") ArcParametro logo) {
        if (logo.blobAllegato) {
            String contentTypeDetected = new Tika().detect(logo.blobAllegato)
            for (ETipoImage ti : ETipoImage.values()) {
                if (ti.contentType.equalsIgnoreCase(contentTypeDetected)) {
                    Filedownload.save(logo.blobAllegato, null, "logo.${ti.estensione}")
                    break
                }
            }
        }
    }

    @Command
    void onCancellaLogo(@BindingParam("logo") ArcParametro logo) {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Logo")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK == e.getName()) {
                            if (logo.blobAllegato) {
                                logo.blobAllegato = null
                                salvaLogo(logo)
                            }
                        }
                    }
                })
    }
}
