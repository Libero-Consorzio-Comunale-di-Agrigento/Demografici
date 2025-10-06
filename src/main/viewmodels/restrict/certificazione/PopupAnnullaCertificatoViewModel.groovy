package restrict.certificazione

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@VariableResolver(DelegatingVariableResolver)
class PopupAnnullaCertificatoViewModel {

    Window self

    String noteAnnullamento
    Boolean showCertificatoEsternoWarning = Boolean.FALSE

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w,
              @ExecutionArgParam("showCertificatoEsternoWarning") Boolean showCertificatoEsternoWarning) {
        this.self = w

        this.showCertificatoEsternoWarning = showCertificatoEsternoWarning ?: Boolean.FALSE

        List<Map<String, String>> eList = [Etichette.annulla_certificato_tooltip, Etichette.Note, Etichette.Conferma, Etichette.Chiudi]
        eList.addAll(EtichetteMessaggi.Warn_annullamento_certificato_esterno)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Command
    void onConferma() {
        if (TestoUtils.isVuoto(noteAnnullamento)) {
            throw new CampoMandatoryRuntimeException()
        }
        Events.postEvent(CustomEvents.ON_NULLIFY_CERTIFICATO, self, [noteAnnullamento: noteAnnullamento])

        onChiudi()
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

}
