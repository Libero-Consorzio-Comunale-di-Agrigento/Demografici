package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPraticaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.IDichiarazionePratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.ISoggettoPratica
import it.finmatica.de4gsdzk.anpr.AnprComunicazione
import it.finmatica.de4gsdzk.anpr.AnprComunicazioneService
import it.finmatica.de4gsdzk.anpr.AnprTipoArchivio
import it.finmatica.de4gsdzk.anpr.AnprTipoArchivioService
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractCommonViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnprComunicazioniViewModel extends AbstractCommonViewModel {

    List<AnprComunicazione> lista
    AnaPratica pratica
    IDichiarazionePratica dichiarazione

    List<ISoggettoPratica> listaSoggetti = [null]
    ISoggettoPratica soggettoSelezionato
    static final ISoggettoPratica PRATICA_E_SOGGETTI = [getAnagrafe: { -> null }] as ISoggettoPratica

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO, null]
    ETipoSiNo filtroWs

    List<AnprTipoArchivio> listaArchiviRif = [null]
    AnprTipoArchivio archivioRif


    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private AnprComunicazioneService anprComunicazioneService
    @WireVariable
    private AnaPraticaService anaPraticaService
    @WireVariable
    private AnprTipoArchivioService anprTipoArchivioService


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id,
         @ExecutionArgParam("soggetti") List<ISoggettoPratica> soggetti,
         @ExecutionArgParam("dichiarazione") IDichiarazionePratica d) {

        self = w

        List<Map<String, String>> eList = AnprComunicazione.etichetteDomain
        eList.addAll([Etichette.getEtichetta("Sezione_Informazioni_Pratica"), Etichette.getEtichetta("Sezione_Provenienza_Pratica"),
                      Etichette.getEtichetta("Comune_Provenienza_Soggetto"), Etichette.getEtichetta("Comune_Iscrizione_Aire")])
        eList.addAll([Etichette.getEtichetta("ANPR"), Etichette.getEtichetta("invio_anpr_tooltip"), Etichette.getEtichetta("ripetizione_invio_tooltip"),
                      Etichette.getEtichetta("Inviato"), Etichette.getEtichetta("info_tooltip"), Etichette.getEtichetta("Annulla_comunicazione_tooltip"),
                      Etichette.getEtichetta("Funzioni_Ausiliarie_tooltip"), Etichette.getEtichetta("Pratica_e_Soggetti"),
                      Etichette.getEtichetta("Pratica"),  Etichette.getEtichetta("Comunicazione_Non_Inviata"),
                      Etichette.getEtichetta("Tutti")])
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())
        eList.addAll(AnaPratica.etichetteDomain)
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("ANPR"))
        formLabel = msgTitle?.toUpperCase()

        pratica = anaPraticaService.findById(id)
        soggettoSelezionato = null

        listaSoggetti.add(PRATICA_E_SOGGETTI)
        listaSoggetti.addAll(soggetti)
        soggettoSelezionato = PRATICA_E_SOGGETTI
        dichiarazione = d

        filtroWs = null

        listaArchiviRif.addAll(anprTipoArchivioService.listAll())
        archivioRif = listaArchiviRif.first()

        caricaLista()

    }

    private caricaLista() {
        onSelectFiltro()
    }

    @Command
    void onSelectFiltro() {
        String filtroInviato = filtroWs == null ? null : (filtroWs == ETipoSiNo.SI ? 'S' : 'N')
        if (soggettoSelezionato == null) {
            lista = anprComunicazioneService.findAllByPraticaAndInviatoAndArchivioRif(pratica.id, filtroInviato, archivioRif)
        } else if (soggettoSelezionato.is(PRATICA_E_SOGGETTI)) {
            List<Integer> matricole = listaSoggetti.findAll { it != null && !it.is(PRATICA_E_SOGGETTI) }*.anagrafe.matricola
            lista = anprComunicazioneService.findAllByPraticaOrMatricoleAndInviatoAndArchivioRif(pratica.id, matricole, filtroInviato, archivioRif)
        } else {
            lista = anprComunicazioneService.findAllByMatricolaAndInviatoAndArchivioRif(soggettoSelezionato.anagrafe.matricola, filtroInviato, archivioRif)
        }
        refreshUi()
    }

    @Command
    void onBackFromList() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onOpenStoricoComunicazioni(@BindingParam("id") Long idOperazione) {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/anprStoricoComunicazioni.zul", self, [idOperazione: idOperazione])
        w.addEventListener(Events.ON_CLOSE, { event ->
            caricaLista()
        })
        w.doModal()
    }

    @Command
    void onInviaComunicazione(@BindingParam("c") AnprComunicazione comunicazione){
        inviaComunicazione(comunicazione.id, comunicazione.servizio.id, false)
    }

    @Command
    void onRipetiComunicazione(@BindingParam("c") AnprComunicazione comunicazione){
        inviaComunicazione(comunicazione.id, comunicazione.servizio.id, true)
    }

    private void inviaComunicazione(Long idOperazione, String idServizio, Boolean flagRipetizione){
        Long id = gsdService.inviaComunicazioneANPR(idOperazione, idServizio, flagRipetizione)
        AnprComunicazione comunicazione = anprComunicazioneService.findById(flagRipetizione ? id : idOperazione)
        if (comunicazione?.noteWSAnpr) {
            Messagebox.show(comunicazione.noteWSAnpr, msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        caricaLista()
    }

    @Command
    void onAnnullaComunicazione(@BindingParam("c") AnprComunicazione comunicazione){
        Long id = gsdService.annullaComunicazioneANPR(comunicazione.id, comunicazione.servizio.id)
        AnprComunicazione c = anprComunicazioneService.findById(id)
        if (c?.noteWSAnpr) {
            Messagebox.show(c.noteWSAnpr, msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        caricaLista()
    }

    @Command
    void onModificaComunicazione(@BindingParam("id") Long idOperazione){
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/anprModificaComunicazione.zul", self, [idOperazione: idOperazione])
        w.addEventListener(Events.ON_CLOSE, { event ->
            caricaLista()
        })
        w.doModal()
    }


}
