package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.RicercaAtto
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarAnnotazioniAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.dao.EmptyResultDataAccessException
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class RegistrazioneAnnotazioniListaParentViewModel extends AbstractListaViewModel {

    List<CivSoggettoAnnotazione> lista = []
    CivSoggettoAnnotazione dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<Integer> listaUffici = []

    final RicercaAtto ricercaAtto = new RicercaAtto()

    Boolean wPreviewAnnotazioniOpen = Boolean.FALSE
    Boolean wPreviewComunicazioniOpen = Boolean.FALSE

    @Delegate
    ControlBarAnnotazioniAttributes cbAnnList = new ControlBarAnnotazioniAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivAttoService civAttoService

    void doInit(Window w, List<Map> eList=[]){
        self = w

        addAnnotazioneEnabled = false
        modifyAnnotazioneEnabled = true

        eList.addAll([Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Estremi_Atto_secondario"),
                      Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("Generata_da"), Etichette.getEtichetta("Generata_su"), Etichette.getEtichetta("Da_registrare_su"),
                      Etichette.getEtichetta("Atto_non_in_Archivio"), Etichette.getEtichetta("Estremi_Atto_decrescente"), Etichette.getEtichetta("Estremi_Atto_crescente"),
                      Etichette.getEtichetta("Generalita_decrescente"), Etichette.getEtichetta("Generalita_crescente")])
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_atto"), Etichette.getEtichetta("Ask_Formato_etichette"), Etichette.getEtichetta("Ask_Inserimento_Annotazione")])
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        eList.addAll(CivSoggettoAnnotazione.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Annotazioni"))
        totalSizeLabel = ""

        listaUffici = [null] + gsdService.listUffici()
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/annotazioni/registrazioneAnnotazioniDettaglio.zul"
    }

    String getEstremiAtto(CivSoggettoAnnotazione sa) {
        String s = ""
        if (sa?.id != null){
            try {
                CivAttoBaseDomain atto = civAttoService.getAttoFromAnnotazione(sa.getTipoAtto(), sa.ufficio, sa.anno, sa.atto, sa.parte, sa.serie)
                s = atto.getNominativoEstremiAtto(sa.tipoFormula, sa.tipoAttoAnnotazione)
                if (sa.isAttoDiAltroComune()){
                    s = s + " " + getEtichetta(Etichette.getEtichetta("Generata_da")) + " " + getEtichettaEnum(atto.getTipoAttoEnum()) + " "
                }
            } catch (EmptyResultDataAccessException e){
                log.error(e.getMessage())
                s = ("*** " + getEtichetta(Etichette.getEtichetta("Atto_non_in_Archivio"))+ " ***")
            }
        }
        return s
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        if (p) {
            ricercaAtto."$p" = null
            resetRicerca()
        }
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    boolean getCanSaveRecord() {
        return true
    }

}
