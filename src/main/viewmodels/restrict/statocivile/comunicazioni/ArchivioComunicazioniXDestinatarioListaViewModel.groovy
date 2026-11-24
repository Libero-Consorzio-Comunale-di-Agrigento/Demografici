package restrict.statocivile.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarComunicazioniAttributes
import org.springframework.data.domain.Page
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
import restrict.statocivile.ComunicazioniAttoListaParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ArchivioComunicazioniXDestinatarioListaViewModel extends ComunicazioniAttoListaParentViewModel{

    List<RicercaDestinatario> destinatariLista
    RicercaDestinatario destinatarioSelezionato

    final List<ETipoAtto> listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivArchivioComunicazioneService civArchivioComunicazioneService

    @WireVariable
    private CivComunicazioneDestinatarioService civComunicazioneDestinatarioService

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @WireVariable
    private CivEnteService civEnteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        showDetailsAtto = Boolean.TRUE
        showDetailsComunicazione = Boolean.TRUE
        showMassiveCheck = Boolean.FALSE
        showDeleteOption = Boolean.FALSE

        pagingComunicazioneEnabled = true
        backFromListComunicazioneEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Data_Registrazione_decrescente"), Etichette.getEtichetta("Data_Registrazione_crescente"),
                           Etichette.getEtichetta("Gestione_Comunicazioni_Archiviate"), Etichette.getEtichetta("Per_Destinatario")]
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

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        formLabel = getEtichetta(Etichette.getEtichetta("Gestione_Comunicazioni_Archiviate"))?.toUpperCase() + " - " + getEtichetta(Etichette.getEtichetta("Per_Destinatario"))?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_decrescente")),  SortUtils.dataRegistrazioneDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Data_Registrazione_crescente")),    SortUtils.dataRegistrazioneAsc))

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
        Page<CivArchivioComunicazione> p = null
        if ( (tipoAttoEnum != null) && (destinatarioSelezionato?.comuneDomain || destinatarioSelezionato?.ente) ){
            PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder.campi))
            if (destinatarioSelezionato.comuneDomain){
                p = civArchivioComunicazioneService.listAllByTipoAttoAndComuneDestinatarioAndStampaEseguita(tipoAttoEnum,
                        destinatarioSelezionato.comuneDomain.codiceComune, destinatarioSelezionato.comuneDomain.codiceProvincia, Boolean.TRUE, pr)
            } else {
                if (destinatarioSelezionato.ente){
                    p = civArchivioComunicazioneService.listAllByTipoAttoAndEnteDestinatarioAndStampaEseguita(tipoAttoEnum, destinatarioSelezionato.ente.id, Boolean.TRUE, pr)
                }
            }
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSelectTipoAtto() {
        destinatariLista = [(new RicercaDestinatario(0,null, null, "- -"))]
        List<Map> listToCheck = civComunicazioneDestinatarioService.listAllByTipoAttoAndStampaEseguita(tipoAttoEnum, Boolean.TRUE)
        for (int i=0; i<listToCheck.size(); i++){
            Map m = listToCheck[i]

            RicercaDestinatario rd = null
            if ((m.comuneDestinatario != null) && (m.provinciaDestinatario != null)){
                ArcComune comuneDomain = arcComuneBaseService.getByCodiceComuneAndCodiceProvincia(m.comuneDestinatario, m.provinciaDestinatario)
                rd = new RicercaDestinatario((i+1), comuneDomain, null, (getEtichetta(Etichette.getEtichetta("Comune")) + ": " + comuneDomain.descrizioneComune))
            } else {
                if (m.ente != null){
                    CivEnte ente = civEnteService.get(m.ente)
                    rd = new RicercaDestinatario((i+1), null, ente, ente.descrizione)
                }
            }
            if (rd){
                destinatariLista.add(rd)
            }
        }
        destinatariLista = destinatariLista.sort{it.denominazione}

        destinatarioSelezionato = null

        onRicarica()
    }

    @Command onSelectDestinatario() {
        onRicarica()
    }

}
