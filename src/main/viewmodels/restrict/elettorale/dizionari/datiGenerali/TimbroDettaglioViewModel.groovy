package restrict.elettorale.dizionari.datiGenerali

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.elettorale.EleTimbro
import it.finmatica.de4gsdzk.elettorale.EleTimbroService
import it.finmatica.de4gsdzk.elettorale.EleVariabileTimbroService
import it.finmatica.de4gsdzk.utils.EProgressivoTimbro
import it.finmatica.de4gsdzk.utils.ETipoLista
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.ETipoTimbro
import it.finmatica.de4gsdzk.utils.Etichette
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
import restrict.statocivile.TraitTemplateListaStringhe

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TimbroDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitTemplateListaStringhe {

    EleTimbro dettaglio
    ETipoOperazione tipoOperazione
    List<ETipoLista> tipiLista = ETipoLista.values().toList()
    List<ETipoLista> listaTipiTimbro = ETipoTimbro.values().toList()
    List<ETipoLista> listaProgressivi = EProgressivoTimbro.values().toList()

    @WireVariable
    private EleTimbroService eleTimbroService

    @WireVariable
    private EleVariabileTimbroService eleVariabileTimbroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("Timbri"), Etichette.getEtichetta("Variabili_Cerca")]
        eList.addAll(EleTimbro.etichetteDomain)
        eList.addAll(ETipoLista.values()*.getEtichettaDesc())
        eList.addAll(ETipoTimbro.values()*.getEtichettaDesc())
        eList.addAll(EProgressivoTimbro.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Timbri"))
        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }

        setListaStringhe(eleVariabileTimbroService.listVariabili(), getEtichetta(Etichette.getEtichetta("Variabili_Cerca")))
    }

    void caricaDettaglio(def id) {
        dettaglio = eleTimbroService.get(id as Long)
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new EleTimbro(params)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            EleTimbro c = eleTimbroService.save(dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }
}
