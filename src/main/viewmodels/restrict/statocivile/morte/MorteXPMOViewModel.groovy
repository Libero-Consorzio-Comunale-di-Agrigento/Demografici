package restrict.statocivile.morte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import restrict.statocivile.AbstractStampaAttiListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MorteXPMOViewModel extends AbstractStampaAttiListaViewModel {

    /** Campi della richiesta (parametri XMPO) */
    Map<String, Object> richiesta = [:]

    /** Numero e anno protocollo da inviare direttamente alla stampa */
    Map<String, Integer> protocollo = [anno: (Integer) null, numero: (Integer) null]

    boolean ricercaPerAtto = false

    List<Integer> listaUffici

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private ExportService exportService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) window) {

        self = window

        backFromListEnabled = true
        xmlExportEnabled = true

        ricerca = new RicercaAttoStampa(ETipoAtto.MOR)

        List<Map<String, String>> eList = [Etichette.getEtichetta("XPMO_Elenco_Morti"), Etichette.getEtichetta("Cognome_Referente"), Etichette.getEtichetta("Nome_Referente"),
                                           Etichette.getEtichetta("Data"), Etichette.getEtichetta("Numero_Richiesta"), Etichette.getEtichetta("Cognome_Nome"), Etichette.getEtichetta("Ricerca_per"),
                                           Etichette.getEtichetta("Numero_Protocollo_Anno"), Etichette.getEtichetta("Estremi_Atto"),
                                           Etichette.getEtichetta("Ask_Estremi_Protocollo_Incompleti"), Etichette.getEtichetta("Cancella"),
                                           Etichette.getEtichetta("Compilare_estremi_atto"), Etichette.getEtichetta("Compilare_estremi_data_registrazione")]
        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)
        eList.addAll(CivMorte.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("XPMO_Elenco_Morti"))

        formLabel = msgTitle?.toUpperCase()

        listaUffici = [null] + gsdService.listUffici()

        caricaRichiesta()
    }

    void caricaLista(){
        log.info ("not implemented")
    }

    Paginazione<Map<String, Object>> eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        List<Map<String, Object>> l = []
        try{
            l = gsdService.listXPMO(ricercaPerAtto, (RicercaAttoStampa)ricerca)
            if ( (l?:[]).isEmpty() ) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        } catch (CampoMandatoryRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione<>(l, l.size())
    }

    private void caricaRichiesta() {
        Map<String, String> params = arcParametroService.mapValoreByIdLike(SqlUtils.beginsAndEndsLike(ArcParametro.XPMO_PARAM))
        richiesta = [
                cognome:    params.XPMO_COGN,
                nome:       params.XPMO_NOME,
                data:       new Date(),
                numero:     Integer.parseInt(params.XPMO_PROG) + 1,
        ]
        ((RicercaAttoStampa)ricerca).dataRegistrazioneDa = DataUtils.addDays(DataUtils.fromStringToDate(params.CIVXPMO), 1)
        ((RicercaAttoStampa)ricerca).dataRegistrazioneA = DataUtils.lastDayOfMonth(((RicercaAttoStampa)ricerca).dataRegistrazioneDa)
        refreshUi()
    }

    private void updateRichiesta() {
        def updateParams = [
                XPMO_COGN:  (String) richiesta.cognome,
                XPMO_NOME:  (String) richiesta.nome,
                XPMO_PROG:  String.valueOf(richiesta.numero),
                XPMO_DATA:  DataUtils.fromDateToString((Date) richiesta.data)
        ]
        if (!ricercaPerAtto) {
            updateParams.CIVXPMO = DataUtils.fromDateToString(((RicercaAttoStampa)ricerca).dataRegistrazioneA)
        }
        arcParametroService.updateValoreByIdLike(SqlUtils.beginsAndEndsLike(ArcParametro.XPMO_PARAM), updateParams)
        onChiudi()
    }

    void esporta(ETipoFile tipo) {
        if (tipo == ETipoFile.XML) {
            if (!protocollo.anno || !protocollo.numero) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Estremi_Protocollo_Incompleti")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener() {
                            void onEvent(Event e) {
                                if (Messagebox.ON_YES.equals(e.getName())) {
                                    elaboraXML(tipo)
                                }
                            }
                        }
                )
            } else {
                elaboraXML(tipo)
            }
        }
    }

    void elaboraXML(ETipoFile tipo) {
        List<Map<String, Object>> anagrafiche = eseguiQuery(Boolean.FALSE)?.lista

        if ( (anagrafiche == null) || (anagrafiche.isEmpty()) ){
            return
        }

        Calendar c = Calendar.getInstance()
        richiesta += [
                sedeComune: anagrafiche[0].get("SEDE_COMUNE"),
                data_GG:    richiesta.data ? String.format("%02d", c.get(Calendar.DATE)) : anagrafiche[0].get("DATA_RICHIESTA_GG"),
                data_MM:    richiesta.data ? String.format("%02d", c.get(Calendar.MONTH)+1) : anagrafiche[0].get("DATA_RICHIESTA_MM"),
                data_AAAA:  richiesta.data ? String.format("%04d", c.get(Calendar.YEAR)) : anagrafiche[0].get("DATA_RICHIESTA_AAAA")]

        //log.debug("RICHIESTA XPMO: {}/{}\n{}\n{}", protocollo.numero, protocollo.anno, richiesta, ricerca)
        //log.debug("ANAGRAFICHE DECESSO: {}", anagrafiche)

        ExportObject eo = new ExportObject("decesso", null, null, [protocollo: protocollo, richiesta: richiesta, anagrafiche: anagrafiche], null, null)
        InputStream exportStream = exportService.export(tipo, eo, [cognomeReferente: richiesta.cognome?:null, nomeReferente: richiesta.nome?:null])
        Filedownload.save(exportStream, tipo.contentType, ExportService.buildFilename("DECEDUTI", tipo))

        updateRichiesta()
    }

    @Command void onSelectTipoRicerca() {
        ricercaPerAtto = !ricercaPerAtto
        refreshUi()
    }

    @Command void onSelectDatiDecesso(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        CivMorte atto = null
        if (event?.data instanceof CivMorte) {
            atto = (CivMorte) event.data
        }
        ricerca.ufficio = atto?.getUfficio()
        ricerca.anno = atto?.getAnno()
        ricerca.atto = atto?.getAtto()
        ricerca.parte = atto?.getParte()
        ricerca.serie = atto?.getSerie()
        ricerca.cognome = atto?.getCognome()
        ricerca.nome = atto?.getNome()
        refreshUi()
    }

    @Command void onCancellaDatiDecesso() {
        onSelectDatiDecesso(null)
    }

    String getNominativo() { [ricerca?.cognome?:"", ricerca?.nome?:""].join(" ").trim() }
}
