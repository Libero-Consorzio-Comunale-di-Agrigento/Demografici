package restrict.statocivile.ricercaAtti

import it.finmatica.de4gsdzk.utils.Etichette
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.ansc.AnscEntita
import it.finmatica.de4gsdzk.ansc.AnscEntitaService
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RicercaAttiAnscListaViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    List<AnscEntita> lista
    AnscEntita dettaglio

    ETipoArchivioAnsc tipoArchivioAnscEnum
    final List<ETipoArchivioAnsc> listaTipiArchivio = [ETipoArchivioAnsc.NAS, ETipoArchivioAnsc.MAT, ETipoArchivioAnsc.MOR,
                                                       ETipoArchivioAnsc.CIT, ETipoArchivioAnsc.UCI, ETipoArchivioAnsc.ANN] + [null]

    RicercaAtto ricercaAtto

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    String  buchiNumerazioneXAnno = ""

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnscEntitaService anscEntitaService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = false
        modifyEnabled = false

        ricercaAtto = new RicercaAtto(DataUtils.getAnnoCorrente())

        List<Map<String, String>> eList = [Etichette.getEtichetta("Atti_Divorzio"), Etichette.getEtichetta("Atti_Scioglimento"),
                                           Etichette.getEtichetta("Numero_unico_crescente"), Etichette.getEtichetta("Numero_unico_decrescente"), Etichette.getEtichetta("Gestione_Registrazioni_comunali")]
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)
        // Aggiungo etichette domain
        eList.addAll(AnscEntita.etichetteDomain)
        // Aggiungo etichette ricerca
        eList.addAll(RicercaAtto.etichetteRicercaDesc)
        eList.addAll(etichetteListaDefault)
        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)
        // Aggiungo etichette tipo archivio
        eList.addAll(Arrays.asList(ETipoArchivioAnsc.values())*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Registrazioni_comunali"))

        formLabel = msgTitle?.toUpperCase()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Numero_unico_decrescente")),    SortUtils.numeroUnicoDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.getEtichetta("Numero_unico_crescente")),      SortUtils.numeroUnicoAsc))

        selectedOrder = listaOrder[0]

        totalSizeLabel = ""

        resize()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        buchiNumerazioneXAnno = ""
        List<Long> buchi = gsdService.listBuchiNumerazione(ricercaAtto.anno)
        if (buchi.size() > 0){
            StringBuilder msg = new StringBuilder("Per l'anno ${ricercaAtto.anno} occorre recuperare i seguenti numeri unici comunali: ")
            msg.append(buchi.join(", "))
            buchiNumerazioneXAnno = msg.toString()
            Messagebox.show(buchiNumerazioneXAnno, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder.campi))

        Page<AnscEntita> p = anscEntitaService.listAllByRicercaLike(tipoArchivioAnscEnum, ricercaAtto, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaAtto, p)
        resetRicerca()
    }

    @Command void onRicercaAttiAnsc(){
        onRicarica()
    }

    @Command void onSelectTipoArchivio(){
        onRicarica()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onModifica() {
        if (dettaglio){
            if (userModifyEnabled){
                Map<String, ?> params = new HashMap<String, ?>()
                String uri = ""
                switch (dettaglio.archivioRif) {
                    case ETipoArchivioAnsc.NAS:
                        params.put("id", dettaglio.idRif)
                        if (dettaglio.flagPrenotazionePartoPlurimo){
                            uri = ""
                            Messagebox.show("Numero associato a dichiarazione di parto gemellare", msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                        } else {
                            if (dettaglio.isCodRec0()) {
                                params.put("composizioneTestoAttiva", Boolean.TRUE)
                                uri = "/restrict/statocivile/nascita/nascitaPregressoDettaglio.zul"
                            } else {
                                uri = "/restrict/statocivile/nascita/nascitaDettaglio.zul"
                            }
                        }
                        break
                    case ETipoArchivioAnsc.MOR:
                        params.put("id", dettaglio.idRif)
                        if (dettaglio.isCodRec0()){
                            params.put("composizioneTestoAttiva", Boolean.TRUE)
                            uri = "/restrict/statocivile/morte/mortePregressoDettaglio.zul"
                        } else {
                            uri = "/restrict/statocivile/morte/morteDettaglio.zul"
                        }
                        break
                    case ETipoArchivioAnsc.CIT:
                        params.put("id", dettaglio.idRif)
                        if (dettaglio.isCodRec0()){
                            params.put("composizioneTestoAttiva", Boolean.TRUE)
                            uri = "/restrict/statocivile/cittadinanza/cittadinanzaPregressoDettaglio.zul"
                        } else {
                            uri = "/restrict/statocivile/cittadinanza/cittadinanzaDettaglio.zul"
                        }
                        break
                    case ETipoArchivioAnsc.MAT:
                        params.put("id", dettaglio.idRif)
                        if (dettaglio.isCodRec0()){
                            params.put("composizioneTestoAttiva", Boolean.TRUE)
                            if (dettaglio.flagDivorzio) {
                                uri = "/restrict/statocivile/matrimonio/matrimonio/divorzioPregressoDettaglio.zul"
                            } else {
                                uri = "/restrict/statocivile/matrimonio/matrimonio/matrimonioPregressoDettaglio.zul"
                            }
                        } else {
                            if (dettaglio.flagDivorzio) {
                                uri = "/restrict/statocivile/matrimonio/matrimonio/divorzioDettaglio.zul"
                            } else {
                                uri = "/restrict/statocivile/matrimonio/matrimonio/matrimonioDettaglio.zul"
                            }
                        }
                        break
                    case ETipoArchivioAnsc.UCI:
                        params.put("id", dettaglio.idRif)
                        if (dettaglio.isCodRec0()){
                            params.put("composizioneTestoAttiva", Boolean.TRUE)
                            if (dettaglio.flagDivorzio) {
                                uri = "/restrict/statocivile/unione/unione/scioglimentoPregressoDettaglio.zul"
                            } else {
                                uri = "/restrict/statocivile/unione/unione/unioneCivilePregressoDettaglio.zul"
                            }
                        } else {
                            if (dettaglio.flagDivorzio) {
                                uri = "/restrict/statocivile/unione/unione/scioglimentoDettaglio.zul"
                            } else {
                                uri = "/restrict/statocivile/unione/unione/unioneCivileDettaglio.zul"
                            }
                        }
                        break
                    case ETipoArchivioAnsc.ANN:
                        CivAnnotazioneAtto aa = civAnnotazioneAttoService.get(dettaglio.idRif)
                        CivAttoBaseDomain abd = civAttoService.getAttoFromAnnotazione(aa.getTipoAtto(), aa.ufficio, aa.anno, aa.atto, aa.parte, aa.serie)
                        params.put("pkAtto", abd.id)
                        params.put("tipoAttoEnum", abd.getTipoAttoEnum())
                        params.put("pkAnnotazione", dettaglio.idRif)
                        uri = "/restrict/statocivile/annotazioniAttoLista.zul"
                        break
                }
                if (uri) {
                    apriDettaglio(uri, params)
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getDescrizioneArchivioAnnotazione(AnscEntita entita){
        String desc = getEtichettaEnum(entita.archivioRif)
        if (TipoAttoUtils.isAttoDiAltroComune(entita.tipoAttoAds)){
            return ("${desc} su atto di altro comune")
        } else {
            return ("${desc} su " + getEtichettaEnum(TipoAttoUtils.fromValoreDefault(entita.tipoAttoAds)))
        }
    }

}
