package restrict

import com.jcabi.manifests.Manifests
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.HomeModuloService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.requestforwarding.RequestForwardingParams
import it.finmatica.de4gsdzk.utils.requestforwarding.RequestForwardingStore
import org.springframework.security.core.context.SecurityContextHolder
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.image.AImage
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.Session
import org.zkoss.zk.ui.event.EventQueues
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Include
import org.zkoss.zul.Window

@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractIndexViewModel {
    Window self

    @Wire('#inner')
    Include inner

    Map<String, String> etichette = [:]

    AImage logoEnte

    Map headerFunctions = [:]

    List<EModulo> moduli = []
    List<EModulo> moduliTop = []
    List<EModulo> moduliBot = []
    Map<EModulo, Boolean> moduliEnabled = [:]
    Sezione selectedModulo

	List<Sezione> sezioni = []
    List<Sezione> selectedSezioni = []
    Sezione selectedSezione

    Sezione selectedSubSezione

    String _denominazioneEnteCorrente=""

    protected RequestForwardingParams requestForwardingParams

    @WireVariable
    private RequestForwardingStore requestForwardingStore

    @WireVariable
    private Manifests manifests

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private HomeModuloService homeModuloService

	abstract void loadSezioni()

    protected void loadHeaderFunctions() {
        headerFunctions = ["uri": "/restrict/statocivile/statoCivileHeaderFunctions.zul"]
        //List<Sezione> hfList = []
        //headerFunctions.put("hfList", hfList)
    }

    void doInit(List<Map<String, String>> eList=[]) {
        eList.addAll([Etichette.Apri_home])
        eList.addAll(EModulo.values()*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        logoEnte = null

        loadModuli()

        loadHeaderFunctions()

        _denominazioneEnteCorrente = (arcComuneBaseService.getComuneCliente()?.descrizioneComune?:"")

        String requestId = Executions.getCurrent().getParameter("requestId")
        requestForwardingParams = requestId ? requestForwardingStore.retrieveRequestForwardingParams(requestId) : new RequestForwardingParams()
    }

    protected void loadModuli() {
        EModulo smartStats = EModulo.SMART_STATS
        URI smartStatsStoredUri = arcParametroService.getStatsUri()
        URI smartStatsResolvedUri = UriUtils.resolveUri(smartStatsStoredUri)
        smartStats.setUri(smartStatsResolvedUri.toASCIIString())

        moduli =  []

        moduliTop = [EModulo.CERTIFICAZIONE, EModulo.ANAGRAFE, EModulo.STATO_CIVILE]
        moduliBot = [EModulo.ELETTORALE, EModulo.LEVA_MILITARE, EModulo.ARCHIVI, smartStats]

        moduli.addAll(moduliTop)
        moduli.addAll(moduliBot)

        List<EModulo> moduliEnabledList = homeModuloService.listModuliAbilitati()
        moduliEnabledList.each {
            moduliEnabled[it] = true
        }
    }

    String getVersioneApplicazione() {
        String versione = manifests.get("Implementation-Version")?:"DEVELOPMENT"
        return " - v.$versione"
    }

    String getDenominazioneEnteCorrente(){
        return _denominazioneEnteCorrente
    }

    String getNominativoUtenteCorrente(){
        return SecurityContextHolder.getContext().getAuthentication().getName()
    }

    @Command onOpenInformazioniUtente() {
        Window w = (Window) Executions.createComponents("/restrict/afc/informazioniUtente.zul", null, [:])
        w.doModal()
    }

    @Command doLogout() {
        Executions.sendRedirect("/logout")
    }

    @Command void onUpdateClientInfo(@BindingParam("width") int _width, @BindingParam("height") int _height,
                                     @BindingParam("orientation") String _orientation ) {
        Map<String, Object> map = new HashMap<String, Object>()
        map.put("desktopHeight", _height)
        map.put("desktopWidth", _width)
        map.put("deviceOrientation", _orientation)
        Session s = Executions.getCurrent().getSession()
        s.setAttribute("desktopHeight", _height)
        s.setAttribute("desktopWidth", _width)
        BindUtils.postGlobalCommand(null, EventQueues.DESKTOP, "onDesktopResize", map)
    }

    @Command
    void onSelectSezione(@BindingParam("sezione") Sezione sezione) {
        Sezione lastSelectedSubSezione = selectedSubSezione
        selectedSubSezione = null
        selectedSezione = sezione
        if (!(sezione.isInto(selectedSezioni))) {
            selectedSezioni.add(sezione)
        }
        List<Sezione> subSezioni = sezione.subSezioni
        if (subSezioni.size() == 1) {
            selectedSubSezione = subSezioni[0]
        }
        if (lastSelectedSubSezione && selectedSubSezione && (lastSelectedSubSezione.uri == selectedSubSezione.uri)) {
            inner.setSrc(null)
        }
        BindUtils.postNotifyChange(null, null, this, "selectedSezione")
        BindUtils.postNotifyChange(null, null, this, "selectedSubSezione")
        BindUtils.postGlobalCommand(null, EventQueues.DESKTOP, "onLoadSezione", null)
    }

}
