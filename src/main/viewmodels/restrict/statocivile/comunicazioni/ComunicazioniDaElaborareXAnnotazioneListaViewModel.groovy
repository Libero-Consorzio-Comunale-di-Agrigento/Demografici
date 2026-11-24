package restrict.statocivile.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.ComunicazioniAttoListaParentViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioniDaElaborareXAnnotazioneListaViewModel extends ComunicazioniAttoListaParentViewModel {

    List<CivFormulaAnnotazione> formuleLista
    CivFormulaAnnotazione formulaSelezionata

    List<CivComunicazione> comunicazioniLista
    CivComunicazione comunicazioneSelezionata

    List<ETipoAtto> listaTipiAtto

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivFormulaAnnotazioneService civFormulaAnnotazioneService

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        showDetailsAtto = Boolean.TRUE

        pagingComunicazioneEnabled = true
        backFromListComunicazioneEnabled = false
        generaTestoComunicazioneEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Data_Registrazione_decrescente"), Etichette.getEtichetta("Data_Registrazione_crescente"),
                                           Etichette.getEtichetta("Gestione_Comunicazioni_Da_Elaborare"), Etichette.getEtichetta("Per_Annotazione"), Etichette.getEtichetta("Formula")]
        eList.addAll(etichetteComunicazioniDefault)

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette delle Comunicazioni
        eList.addAll(CivComunicazioneAtto.etichetteDomain)
        eList.addAll(CivArchivioComunicazione.etichetteDomain)
        eList.addAll(CivComunicazioneProtocollo.etichetteDomain)
        eList.addAll(CivComunicazioneDestinatario.etichetteDomain)
        eList.addAll(CivComunicazioneAllegato.etichetteDomain)
        // Aggiungo etichette Occhiello (per la stampa della CIA)
        eList.addAll(CivOcchiello.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarComunicazioniAttributes.etichetteCbComListDesc)

        // Aggiungo etichette stato comunicazione
        eList.addAll(Arrays.asList(EStatoProtocollazione.values())*.etichettaDesc)
        // Aggiungo etichette stato invio all'albo
        eList.addAll(Arrays.asList(EStatoInvioAlbo.values())*.etichettaDesc)

        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.PUB, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]
        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        formLabel = getEtichetta(Etichette.getEtichetta("Gestione_Comunicazioni_Da_Elaborare"))?.toUpperCase() + " - " + getEtichetta(Etichette.getEtichetta("Per_Annotazione"))?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_decrescente")), SortUtils.dataRegistrazioneDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_crescente")), SortUtils.dataRegistrazioneAsc))

        //Default: data registrazione discendente
        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        resize()
    }

    void caricaLista() {
        listaComunicazioniSelezionate = []

        massiveCheck = Boolean.FALSE

        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        resetDettaglio()

        setAttributiElaborazione()

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        Page p = null
        if ((tipoAttoEnum != null) && (comunicazioneSelezionata?.id != null)) {
            Map params = [activePage           : (usePaging ? activePage : null), pageSize: (usePaging ? pageSize : null),
                          tipoAttoComunicazione: new Integer(tipoAttoEnum.valore), idCom: comunicazioneSelezionata?.id, stampaEseguita: Boolean.FALSE, idFormula: formulaSelezionata?.id,
                          fetch                : [[campo: 'comunicazione', tipo: JoinType.INNER], [campo: 'formulaDfa', tipo: JoinType.LEFT]], order: selectedOrder?.campi]

            p = civArchivioComunicazioneService.list(params)
        }
        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    @Command
    void onSelectTipoAtto() {
        formuleLista = civFormulaAnnotazioneService.listAllByTipoAttoAndTipoAnnotazioneIn(new Integer(tipoAttoEnum.valore), [ETipoAnnotazione.C, ETipoAnnotazione.M])
        formuleLista.add(0, new CivFormulaAnnotazione(id: null, descrizione: "- -"))

        formulaSelezionata = null
        refreshUi()
    }

    @Command
    void onSelectFormula() {
        comunicazioniLista = civComunicazioneService.listAllByTipoAttoComunicazioneAndStampaEseguitaAndFormula(new Integer(tipoAttoEnum.valore), Boolean.FALSE, formulaSelezionata)
        comunicazioniLista.add(0, new CivComunicazione(id: null, descrizione: "- -"))

        comunicazioneSelezionata = null
        refreshUi()
    }

    @Command
    onSelectComunicazione() {
        onRicarica()
    }

}
