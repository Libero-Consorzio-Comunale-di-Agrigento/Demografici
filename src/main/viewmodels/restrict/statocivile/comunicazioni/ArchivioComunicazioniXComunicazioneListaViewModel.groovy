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
class ArchivioComunicazioniXComunicazioneListaViewModel extends ComunicazioniAttoListaParentViewModel{

    List<CivComunicazione> comunicazioniLista
    CivComunicazione comunicazioneSelezionata

    List<ETipoAtto> listaTipiAtto

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        showDetailsAtto = Boolean.TRUE
        showDetailsComunicazione = Boolean.FALSE
        showMassiveCheck = Boolean.FALSE
        showDeleteOption = Boolean.FALSE

        pagingComunicazioneEnabled = true
        backFromListComunicazioneEnabled = false

        List<Map> eList = [Etichette.Estremi_Atto, Etichette.Data_Registrazione_decrescente, Etichette.Data_Registrazione_crescente,
                           Etichette.Gestione_Comunicazioni_Archiviate, Etichette.Per_Comunicazione]
        eList.addAll(etichetteComunicazioniDefault)

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette delle Comunicazioni
        eList.addAll(CivArchivioComunicazione.etichetteDomain)
        eList.addAll(CivComunicazioneProtocollo.etichetteDomain)
        eList.addAll(CivComunicazioneDestinatario.etichetteDomain)
        eList.addAll(CivComunicazioneAllegato.etichetteDomain)

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

        msgTitle = getEtichetta(Etichette.Comunicazioni)

        formLabel = getEtichetta(Etichette.Gestione_Comunicazioni_Archiviate)?.toUpperCase() + " - " + getEtichetta(Etichette.Per_Comunicazione)?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Registrazione_decrescente),  SortUtils.dataRegistrazioneDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Registrazione_crescente),    SortUtils.dataRegistrazioneAsc))

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

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page p = null
        if ( (tipoAttoEnum != null) && (comunicazioneSelezionata?.id != null)){
            Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                           tipoAttoComunicazione: new Integer(tipoAttoEnum.valore), idCom: comunicazioneSelezionata?.id, stampaEseguita: Boolean.TRUE,
                           fetch   : [[campo:'comunicazione', tipo: JoinType.INNER], [campo:'formulaDfa', tipo: JoinType.LEFT]], order: selectedOrder?.campi]

            p = civArchivioComunicazioneService.list(params)
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSelectTipoAtto() {
        comunicazioniLista = civComunicazioneService.listAllByTipoAttoComunicazioneAndStampaEseguita(new Integer(tipoAttoEnum.valore), Boolean.TRUE)
        comunicazioniLista.add(0, new CivComunicazione(id:null, descrizione:"- -"))

        comunicazioneSelezionata = null

        onRicarica()
    }

    @Command onSelectComunicazione() {
        onRicarica()
    }
}
