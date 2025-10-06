package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class DizionarioListaViewModel extends AbstractListaViewModel {

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    void doInitEtichette(List<Map<String, String>> eList=[]) {
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    abstract String getUriDettaglio()

    void eliminaRecord(){
        log.info("punto di estensione")
    }

    String getMessaggioCancellazione(){
        return ""
    }

    @Command void onElimina() {
        if (userModifyEnabled) {
            String msg = getMessaggioCancellazione()
            if (msg) {
                Messagebox.show(msg, msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener() {
                            void onEvent(Event e) {
                                if (Messagebox.ON_OK.equals(e.getName())) {
                                    eliminaRecord()
                                }
                            }
                        }
                )
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
