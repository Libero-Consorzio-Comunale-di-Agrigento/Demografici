package restrict


import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Events
import org.zkoss.zul.Window

abstract class AbstractCommonViewModel extends AbstractResizedViewModel {

    Window self

    String msgTitle = ""
    String formLabel = ""

    Map<String, String> etichette = [:]
    Map<String, String> etichetteCustom = [:]

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    void refreshUi() {
        BindUtils.postNotifyChange(null, null, this, "*")
    }

    String getEtichettaCustomEnum(Enum e) {
        return e ? getEtichettaCustom(e.getEtichettaDesc()) : ""
    }

    String getEtichettaCustom(Map<String, String> etichetta) {
        return etichetta ? etichetteCustom[etichetta.codice] : ""
    }

    String getEtichettaEnum(Enum e, String etichettaDefault = null) {
        return e ? getEtichetta(e.getEtichettaDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichettaPluralEnum(Enum e, String etichettaDefault = null) {
        return e ? getEtichetta(e.getEtichettaPluralDesc()) : getEtichetta(etichettaDefault)
    }

    String getEtichetta(Map<String, String> etichetta) {
        return etichetta ? getEtichetta((String) etichetta.codice) : ""
    }

    String getEtichetta(String codice) {
        return codice ? etichette[codice] : ""
    }

    String getEtichettaCustom(String codice) {
        return codice ? etichetteCustom[codice] : ""
    }

    static final List<Map<String, String>> etichetteDettaglioDefault = [Etichette.getEtichetta("Compilare_campi_obbligatori"), Etichette.getEtichetta("Ask_Modifiche_In_Sospeso"),
                                                                        Etichette.getEtichetta("Salvataggio_Completato"), Etichette.getEtichetta("Chiusura")]

}
