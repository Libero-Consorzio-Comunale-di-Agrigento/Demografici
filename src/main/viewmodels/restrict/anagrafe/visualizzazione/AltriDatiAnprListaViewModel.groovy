package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.LogGsd
import it.finmatica.de4gsdzk.anagrafe.AnpAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnpOperazioneService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.anpr.AnpOperazione
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.statocivile.LogsService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AltriDatiAnprListaViewModel extends AbstractListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnpOperazione> lista
    AnpAnagrafe anpSoggetto

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnpOperazioneService anpOperazioneService

    @WireVariable
    private AnpAnagrafeService anpAnagrafeService

    @WireVariable
    private LogsService logsService


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.getEtichetta("Altri_Dati_ANPR")]

        // Aggiungo etichette entità
        eList.addAll(AnpAnagrafe.etichetteDomain)
        eList.addAll(AnpOperazione.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        eList.addAll([Etichette.getEtichetta("Data_Decorrenza_tooltip"), Etichette.getEtichetta("Data_Decorrenza_Precedente_tooltip")])

        eList.addAll([Etichette.getEtichetta("Warn_Nessun_elemento_selezionato"), Etichette.getEtichetta("Errore_Ricerca_ANPR"), Etichette.getEtichetta("Nessun_dato_disponibile")])

        eList.addAll([Etichette.getEtichetta("Id_Operazione_Comune_Crescente"), Etichette.getEtichetta("Id_Operazione_Comune_Decrescente"),
                      Etichette.getEtichetta("Id_Operazione_ANPR_Crescente"), Etichette.getEtichetta("Id_Operazione_ANPR_Decrescente"),
                      Etichette.getEtichetta("Data_Decorrenza_Crescente"), Etichette.getEtichetta("Data_Decorrenza_Decrescente"),
                      Etichette.getEtichetta("Data_Richiesta_Crescente"), Etichette.getEtichetta("Data_Richiesta_Decrescente")])
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Altri_Dati_ANPR"))

        formLabel = msgTitle?.toUpperCase()

        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Id_Operazione_Comune_Crescente")), SortUtils.operazioneComuneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Id_Operazione_Comune_Decrescente")), SortUtils.operazioneComuneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Id_Operazione_ANPR_Crescente")), SortUtils.operazioneANPRAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Id_Operazione_ANPR_Decrescente")), SortUtils.operazioneANPRDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Decorrenza_Crescente")), SortUtils.dataDecorrenzaAsc),
                            new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Decorrenza_Decrescente")), SortUtils.dataDecorrenzaDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Richiesta_Crescente")), SortUtils.dataRichiestaAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Richiesta_Decrescente")), SortUtils.dataRichiestaDesc)])
        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        resize()

        anpSoggetto = anprIndividuoCorrente
        caricaLista()

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Override
    void resetDettaglio() {

    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        List<AnpOperazione> l
        try {
            l = anpOperazioneService.listAllByAnpAnagrafe(anpSoggetto, pr).content
        } catch (NoRecordFoundRuntimeException ignored) {
            //In questo modo evito l'eccezione
            l = null
        }
        return new Paginazione((l ?: []), (l?.size() ?: 0))
    }


    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onBack() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    @Command
    void onSelezionaDataRiferimento(@BindingParam("dataDecorrenza") Date dataDecorrenza, @BindingParam("precedente") boolean precedente) {
        Date dataRiferimento = dataDecorrenza
        if (precedente) {
            dataRiferimento = dataDecorrenza.minus(1)
        }
        AnpAnagrafe soggetto
        try {
            soggetto = anpAnagrafeService.findBySoggetto(anpSoggetto, true, dataRiferimento)

            logsService.save(ETipoLog.Gsd, LogGsd.createLogGsdVisualizzazioneIndividuoAnp(soggetto))
        } catch (Exception e) {
            log.error(e.getMessage(), e)
            soggetto = null
        }
        if (soggetto != null) {
            Events.postEvent(CustomEvents.ON_SELECT_RECORD, self, [anpSoggetto: soggetto, dataRiferimento: dataRiferimento])
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_Ricerca_ANPR")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION, null)
        }


    }


}
