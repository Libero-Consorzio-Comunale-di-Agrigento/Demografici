package restrict.certificazione.emissione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoRichiedente
import it.finmatica.de4gsdzk.certificazione.emissione.EmissioneCertificatoStatoCivileService
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.TipoGenerazioneCertificatoService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class EmissioneCertificatoAttoSelectViewModel extends AbstractSelectViewModel {

    ETipoAtto tipoAttoEnum

    List<CivAttoBaseDomain> lista
    CivAttoBaseDomain dettaglio

    Boolean forceGenerazioneGte
    CerTipoCertificato tipoCertificato
    CerTipoRichiedente tipoRichiedente

    Boolean anscOn = Boolean.FALSE

    String anscRichiedenteWarning
    String anscMorteRichiedenteWarning

    Map<Long, Boolean> attoInvioEnabled = [:]

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private EmissioneCertificatoStatoCivileService emissioneCertificatoStatoCivileService

    @WireVariable
    private TipoGenerazioneCertificatoService tipoGenerazioneCertificatoService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("listaAtti") List<CivAttoBaseDomain> listaAtti,
         @ExecutionArgParam("forceGenerazioneGte") Boolean forceGenerazioneGte,
         @ExecutionArgParam("tipoCertificato") CerTipoCertificato tipoCertificato,
         @ExecutionArgParam("tipoRichiedente") CerTipoRichiedente tipoRichiedente) {
        self = w

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Id_Atto_Ansc"), Etichette.getEtichetta("seleziona_salva_tooltip"), Etichette.getEtichetta("Chiudi")]
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        this.tipoAttoEnum = listaAtti.first().tipoAttoEnum
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                eList.addAll(CivNascita.etichetteDomain)
                break
            case ETipoAtto.MAT:
                eList.addAll(CivMatrimonio.etichetteDomain)
                break
            case ETipoAtto.MOR:
                eList.addAll(CivMorte.etichetteDomain)
                break
            case ETipoAtto.UCI:
                eList.addAll(CivUnioneCivile.etichetteDomain)
                break
            case ETipoAtto.CIT:
                eList.addAll(CivCittadinanza.etichetteDomain)
                break
        }

        doInitEtichette(eList)

        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(Etichette.getEtichetta("seleziona_salva_tooltip"))

        totalSizeLabel = ""

        this.lista = listaAtti
        this.forceGenerazioneGte = forceGenerazioneGte
        this.tipoCertificato = tipoCertificato
        this.tipoRichiedente = tipoRichiedente

        if (emissioneCertificatoStatoCivileService.shouldShowAnscRichiedenteWarning(this.tipoRichiedente, this.forceGenerazioneGte, this.tipoCertificato)) {
            this.anscRichiedenteWarning = "Tipo Emissione ${tipoRichiedente.descrizione}: per atti digitali, il richiedente verrà valorizzato con gli estremi beneficiario."
        }
        if (emissioneCertificatoStatoCivileService.shouldShowAnscMorteRichiedenteWarning(this.tipoRichiedente, this.forceGenerazioneGte, this.tipoCertificato)) {
            this.anscMorteRichiedenteWarning = "Tipo Emissione ${tipoRichiedente.descrizione}: impossibile procedere per atti di morte digitali. Modificare il Tipo Emissione."
            this.anscRichiedenteWarning = null
        }

        lista.each {
            attoInvioEnabled.put(it.id,
                    emissioneCertificatoStatoCivileService.shouldEnableEmissioneCertificatoSuAtto(it.tipoAttoEnum, this.tipoRichiedente, this.forceGenerazioneGte, this.tipoCertificato, it))
        }

        caricaLista()
    }

    void caricaLista() {
        updateTotalSize(lista.size())
        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info("usePaging: " + usePaging)
        return null
    }

    @Command
    void onClickDettaglio() {
        refreshUi()
    }

    @Command
    void onClickSeleziona() {
        if (dettaglio) {
            if (attoInvioEnabled[dettaglio.id]) {
                ETipoGenerazioneCertificato tipoGenerazioneCertificato = tipoGenerazioneCertificatoService.get(forceGenerazioneGte, tipoCertificato, dettaglio)
                Events.sendEvent(CustomEvents.ON_CER_EMISSIONE_ATTO_SELECT, self, [attoSelezionato: dettaglio, tipoGenerazioneCertificato: tipoGenerazioneCertificato])

                if (emissioneCertificatoStatoCivileService.shouldOpenAnnotazioni(tipoGenerazioneCertificato, tipoCertificato, dettaglio)) {
                    openAnnotazioni()
                } else {
                    Events.sendEvent(CustomEvents.ON_CER_EMISSIONE_COMPLETE, self, [:])
                    onChiudi()
                }
            }

        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private void openAnnotazioni() {
        self.getChildren().clear()

        Window windowAnnotazioni = (Window) Executions.createComponents("/restrict/certificazione/emissione/emissioneCertificatoAnnotazioni.zul", self, [
                pkAtto      : dettaglio.id,
                tipoAttoEnum: dettaglio.tipoAttoEnum
        ])
        // Chiudo self quando il secondo step viene chiuso
        windowAnnotazioni.addEventListener(Events.ON_CLOSE, { onChiudi() })

        // Assegno i listener che riguardano il secondo step al secondo step
        self.getEventListeners(CustomEvents.ON_CER_EMISSIONE_ANNOTAZIONI_ATTO_SAVE).each { it ->
            windowAnnotazioni.addEventListener(CustomEvents.ON_CER_EMISSIONE_ANNOTAZIONI_ATTO_SAVE, it)
        }
        self.getEventListeners(CustomEvents.ON_CER_EMISSIONE_COMPLETE).each { it ->
            windowAnnotazioni.addEventListener(CustomEvents.ON_CER_EMISSIONE_COMPLETE, it)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

}
