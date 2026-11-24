package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anpr.AnprComunicazione
import it.finmatica.de4gsdzk.anpr.AnprComunicazioneService
import it.finmatica.de4gsdzk.anpr.AnprMovimentoComunicazione
import it.finmatica.de4gsdzk.anpr.AnprMovimentoComunicazioneService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnprStoricoComunicazioniViewModel extends AbstractListaViewModel {

    Long id
    AnprComunicazione comunicazione

    List<Map<String, String>> filtriList = []

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<AnprMovimentoComunicazione> lista = []
    AnprMovimentoComunicazione dettaglio

    @WireVariable
    private AnprMovimentoComunicazioneService anprMovimentoComunicazioneService
    @WireVariable
    private AnprComunicazioneService anprComunicazioneService
    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("idOperazione") Long idOperazione) {
        self = w
        this.id = idOperazione


        List<Map> eList = [Etichette.getEtichetta("ANPR"), Etichette.getEtichetta("Chiudi"),
                           Etichette.getEtichetta("Comunicazione_Non_Inviare"), Etichette.getEtichetta("Ripristina_Comunicazione")]
        eList.addAll(AnprMovimentoComunicazione.etichetteDomain)

        eList.addAll(etichetteListaDefault)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        pagingEnabled = true
        addEnabled = false
        modifyEnabled = false

        comunicazione = anprComunicazioneService.findById(idOperazione)
        caricaFiltriList()

        msgTitle = getEtichetta(Etichette.getEtichetta("ANPR"))

        totalSizeLabel = ""


        caricaLista()
    }

    protected void caricaFiltriList() {
        filtriList = []

        if (!comunicazione.inviato) {
            filtriList << [codice: "COMUNICAZIONE_DA_NON_INVIARE", descrizione: getEtichetta(Etichette.getEtichetta("Comunicazione_Non_Inviare"))]
        } else if(comunicazione.noteWS.contains("Forzato invio WS")) {
            filtriList << [codice: "RIPRISTINA_COMUNICAZIONE", descrizione: getEtichetta(Etichette.getEtichetta("Ripristina_Comunicazione"))]
        }
        filtriExtraEnabled = filtriList.size() > 0

        BindUtils.postNotifyChange(null, null, this, "filtriList")
        BindUtils.postNotifyChange(null, null, this, "filtriExtraEnabled")
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.FALSE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        lista = (anprMovimentoComunicazioneService.findAllByIdOrderByDataInvio(id) ?: [])

        return new Paginazione(lista, lista.size())
    }


    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Command
    void onFiltriPlus(@BindingParam("codice") String codice) {
        if (filtriExtraEnabled) {
            switch (codice) {
                case "COMUNICAZIONE_DA_NON_INVIARE":
                    comunicazione.inviato = true
                    anprComunicazioneService.saveOrUpdate(comunicazione, true)
                    onChiudi()
                    break
                case "RIPRISTINA_COMUNICAZIONE":
                    comunicazione.inviato = false
                    anprComunicazioneService.saveOrUpdate(comunicazione, true)
                    onChiudi()
                    break
            }
        }
    }

}
