package restrict.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerFondoCassaTerminalista
import it.finmatica.de4gsdzk.certificazione.CerFondoCassaTerminalistaService
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractPopupViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PopupFondoCassaViewModel extends AbstractPopupViewModel {

    CerFondoCassaTerminalista dettaglio

    Boolean askConfirm = true

    @WireVariable
    private CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("terminalista") CerTerminalista terminalista) {
        self = w

        List<Map<String, String>> eList = []
        eList.addAll(CerFondoCassaTerminalista.etichetteDomain)
        eList.addAll([Etichette.getEtichetta("Ask_Modifica_fondo_cassa")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Fondo_Cassa"))

        formLabel = msgTitle

        dettaglio = cerFondoCassaTerminalistaService.findByTerminalistaAndData(terminalista, DataUtils.getDataCorrente())
        if (dettaglio == null) {
            dettaglio = cerFondoCassaTerminalistaService.create(terminalista)
            askConfirm = false
        }
    }

    @Command
    void onConferma() {
        if (dettaglio.fondoCassa == null) {
            throw new CampoMandatoryRuntimeException()
        }

        if (!askConfirm) {
            cerFondoCassaTerminalistaService.save(dettaglio)
            onChiudi()
            return
        }

        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifica_fondo_cassa")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            cerFondoCassaTerminalistaService.save(dettaglio)
                            onChiudi()
                        }
                    }
                })
    }

}
