package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivDisposizioniAnticipateTrattamento
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.statocivile.embed.SoggettoDAT
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitGestioneCaseCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class SoggettoDATViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneCaseCampi, TraitComune {

    Map<String,Boolean> minuscole = [:]

    SoggettoDAT dettaglio
    String tipoSoggettoDAT = ""

    Component opener

    Boolean isDisponente

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()
    final List<ETipoSN> listaSN = ETipoSN.values().toList()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService

    @WireVariable
    private AnaEnteService anaEnteService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("opener") Component opener,
               @ExecutionArgParam("tipoSoggettoDAT") String tipoSoggettoDAT, @ExecutionArgParam("isDisponente") Boolean isDisponente) {

        self = w

        minuscole = [cognome:Boolean.FALSE, nome: Boolean.FALSE]
        arcParametroService.checkMinuscoleOn(minuscole)

        this.opener = opener
        this.opener.addEventListener(CustomEvents.ON_REFRESH_INNER_COMPONENT, new org.zkoss.zk.ui.event.EventListener() {
            void onEvent(Event event) {
                caricaDettaglio(event.data.dat)
            }
        })

        this.tipoSoggettoDAT = tipoSoggettoDAT
        this.isDisponente = isDisponente

        ricercaSoggettoInANPROn = arcParametroService.isRicercaSoggettoInANPRAttiva()

        List<Map<String, String>> eList = [Etichette.Minuscole, Etichette.Cancella, EtichetteMessaggi.Compilare_campi_cf, Etichette.Recupera_Documento_Anagrafe,
                                           Etichette.Gestione_Documenti_Entrata, Etichette.Dati_Anagrafici, Etichette.Documenti]

        eList.addAll(SoggettoDAT.etichetteDomain)

        // Aggiungo etichette sesso
        eList += ESesso.values()*.getEtichettaDesc()

        // Aggiungo etichette SI/NO
        eList += ETipoSiNo.values()*.getEtichettaDesc()

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Gestione_Documenti_Entrata)
    }

    @Override
    void caricaDettaglio(def dat){
        dettaglio = ((CivDisposizioniAnticipateTrattamento) dat)."$tipoSoggettoDAT"

        DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

        refreshUi()
    }

    @Override
    void creaDettaglio(Map params){
        log.info ("not implemented")
    }

    @Command void onSelectTipoDocumento(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (event?.target?.selectedItem instanceof AnaTipoDocumento) {
            dettaglio.tipoDocumento = (AnaTipoDocumento)event.target.selectedItem
        } else {
            dettaglio.tipoDocumento = null
        }
        refreshUi()
    }

    @Command void onCancellaTipoDocumento(){
        onSelectTipoDocumento(null)
    }

    @Command void onSelectEnte(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (event?.target?.selectedItem instanceof AnaEnte) {
            dettaglio.ente = (AnaEnte)event.target.selectedItem
        } else {
            dettaglio.ente = null
        }
        refreshUi()
    }

    @Command void onCancellaEnte(){
        onSelectEnte(null)
    }

    @Command void onCancellaCampoDAT(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe) {
        onCancellaCampo(e)

        onAggiornaAna(campoAnagrafe)
    }

    @Command void onCalcolaCf() {
        String cf = statoCivileService.calcolaCf(dettaglio.cognome, dettaglio.nome, dettaglio.sesso, dettaglio.dataNascita,
                dettaglio.comuneNascita.codiceProvincia, dettaglio.comuneNascita.codice)
        if ( (cf?:StatoCivileService.ERRORE_CAMPI_CF) == StatoCivileService.ERRORE_CAMPI_CF ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_campi_cf), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            dettaglio.codiceFiscale = cf
        }
        refreshUi()
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CN:
                riempiComune(dettaglio.comuneNascita, c)
                break
            case ETipoComuneAtto.CR:
                riempiComune(dettaglio.comuneResidenza, c)
                break
            case ETipoComuneAtto.CD:
                riempiComune(dettaglio.comuneDocumento, c)
                break
        }
    }

    @Command
    void onAggiornaCaseAndAna(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe) {
        onAggiornaCase(e)

        onAggiornaAna(campoAnagrafe)
    }

    void onAggiornaAna(String campoAnagrafe){
        if (campoAnagrafe) {
            ETipoCampoAnagrafe ca = ETipoCampoAnagrafe.valueOf(campoAnagrafe)
            switch (ca) {
                case ETipoCampoAnagrafe.COGNOME_SOGGETTO:
                case ETipoCampoAnagrafe.NOME_SOGGETTO:
                case ETipoCampoAnagrafe.DATA_NASCITA_SOGGETTO:
                    dettaglio.matricola = null
                    refreshUi()
                    break
            }
        }
    }

    @Command void onCaricaSoggetti(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        Map params
        if (ts == ETipoSoggetto.SOGGETTO){
            params = [cognome: dettaglio.getCognome(), nome: dettaglio.getNome(), sesso : dettaglio.getSesso(), dataNascita: dettaglio.getDataNascita()]
        }
        if (params){
            Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof AnaAnagrafeBaseDomain){
                    AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain)event.data
                    if (ts == ETipoSoggetto.SOGGETTO){
                        DomainUtils.initSoggettoDatFromAnagrafe(dettaglio, ana)

                        aggiornaDocumento(null, null, null)

                        DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    void aggiornaDocumento(AnaTipoDocumento td, AnaEnte e, Map m){
        dettaglio.tipoDocumento = td
        dettaglio.ente = e
        dettaglio.numeroDocumento = m?.NUMERO_DI
        dettaglio.dataRilascioDocumento = m?.D_DATA_EMISSIONE_DI
        dettaglio.dataScadenzaDocumento = m?.D_DATA_SCADENZA_DI
        dettaglio.comuneDocumento.codice = m?.COD_COM_ENTE_DI?.intValueExact()
        dettaglio.comuneDocumento.codiceProvincia = m?.COD_PRO_ENTE_DI?.intValueExact()
        dettaglio.comuneDocumento.descrizione = m?.DESCRIZIONE_COM_ENTE_DI
        dettaglio.comuneDocumento.siglaProvincia = m?.SIGLA_PRO_ENTE_DI
        refreshUi()
    }

    @Command void onRecuperaDocumentoIdentita(){
        if (dettaglio.matricola != null){
            Window w = (Window) Executions.createComponents("/restrict/statocivile/documenti/documentoListaSelect.zul", self, [matricola: dettaglio.matricola])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data?.documento instanceof Map){
                    Map m = (Map) event.data.documento
                    AnaTipoDocumento td = anaTipoDocumentoService.get(m.TIPO_DI)
                    AnaEnte e = anaEnteService.get(m.ENTE_EMISSIONE_DI?.intValueExact())
                    aggiornaDocumento(td, e, m)
                }
            })
            w.doModal()
        }
    }

}
