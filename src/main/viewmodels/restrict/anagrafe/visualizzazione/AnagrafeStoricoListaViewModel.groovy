package restrict.anagrafe.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoNonResidenteFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteEsteroFamiglia
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.TraitControlBarCapable

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnagrafeStoricoListaViewModel extends AbstractMasterDetailSituazioneStoricoFamigliaListaViewModel implements TraitControlBarCapable, TraitIndividuoCorrente {

    List<AnaEventoAnagrafe> lista
    AnaEventoAnagrafe dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private AnaEventoAnagrafeService anaEventoAnagrafeService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        controlBarAttributes.pagingEnabled = false
        controlBarAttributes.modifyEnabled = false
        controlBarAttributes.addEnabled = false

        // Aggiungo etichette titolo
        List<Map<String, String>> eList = [Etichette.Storico, Etichette.Anagrafe, Etichette.Situazione_al, Etichette.Ordina_per]

        // Aggiungo etichette entità
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaFamiglia.etichetteDomain)
        eList.addAll(AnaEventoAnagrafe.etichetteDomain)
        eList.addAll(AnaEventoAnagrafeFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteFamiglia.etichetteDomain)
        eList.addAll(IndirizzoResidenteEsteroFamiglia.etichetteDomain)
        eList.addAll(IndirizzoNonResidenteFamiglia.etichetteDomain)

        // Aggiungo etichette della lista
        eList.addAll(etichetteListaDefault)

        eList.addAll([EtichetteMessaggi.Warn_Nessun_elemento_selezionato])

        // Aggiungo etichette per messaggi restituiti da funzioni dettaglio
        eList.addAll([])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = "${getEtichetta(Etichette.Storico)} ${getEtichetta(Etichette.Anagrafe)}"

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento), SortUtils.dataAnaEventoAsc))
        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        resize()

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        List<AnaEventoAnagrafe> l = anaEventoAnagrafeService.findAllByAnagrafe(individuoCorrente, pr).content

        return new Paginazione((l ?: []), (l.size() ?: 0))
    }

    void resetDettaglio() {
        dettaglio = null
        eventoAnagrafeFamigliaList = []
        refreshUi()
    }

    void resetLista() {
        lista = []
        refreshLista()
    }

    @Command
    void onSelectDettaglio() {
        caricaListaEventoAnagrafeFamiglia(dettaglio?.famiglia, dettaglio?.dataEvento)
    }

}
