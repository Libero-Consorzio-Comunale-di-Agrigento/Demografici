package restrict.toponomastica.dizionari.numerazioneCivica

import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivico
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@VariableResolver(DelegatingVariableResolver.class)
class NumerazioneCivicaDettaglioViewModel extends DizionarioDettaglioViewModel {

    ArcDatiNumerazioneCivico dettaglio

    ETipoOperazione tipoOperazione = ETipoOperazione.UPD

    @WireVariable
    private ArcDatiNumerazioneCivicoService arcDatiNumerazioneCivicoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("id") Long id) {
        self = w

        saveRecordEnabled = true
        backFromRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Numerazione_Civica"),
                                           Etichette.getEtichetta("Via"),
                                           Etichette.getEtichetta("Elemento"),
                                           Etichette.getEtichetta("Civico_Esterno"),
                                           Etichette.getEtichetta("Civico_Interno"),
                                           Etichette.getEtichetta("Sequenza"),
                                           Etichette.getEtichetta("Separatore"),
                                           Etichette.getEtichetta("Visibile"),
                                           Etichette.getEtichetta("Default")]
        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Numerazione_Civica"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    @Override
    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = arcDatiNumerazioneCivicoService.get(id as Long)
            tipoOperazione = ETipoOperazione.UPD
        }
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
        BindUtils.postNotifyChange(null, null, this, "tipoOperazione")
    }

    @Override
    void creaDettaglio(Map params) {
        throw new UnsupportedOperationException("Insert non supportato per NumerazioneCivica")
    }

    @Command
    void onSalvaRecord() {
        if (!dettaglio) return
        try {
            ArcDatiNumerazioneCivico salvato = tipoOperazione.isInsert()
                    ? arcDatiNumerazioneCivicoService.insert(dettaglio)
                    : arcDatiNumerazioneCivicoService.update(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(salvato.id)
        } catch (De4gsdzkRuntimeException ex) {
            Messagebox.show(ex.message, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}