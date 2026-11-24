package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.istat.IstatDizionarioDettagliSoggetto
import it.finmatica.de4gsdzk.istat.IstatDizionarioDettagliSoggettoService
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
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
class GestioneSoggettoViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneCaseCampi, TraitComune, TraitGestioneIndividuo {

    static final String CONVIVENTE = 'CV'

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private AnaCittadinanzaService anaCittadinanzaService
    @WireVariable
    private AnaStatoCivileService anaStatoCivileService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private ArcParametroService arcParametroService
    @WireVariable
    private AnaAnagrafeService anaAnagrafeService
    @WireVariable
    private AnaDocumentoService anaDocumentoService
    @WireVariable
    private AnaTitoloStudioService anaTitoloStudioService
    @WireVariable
    private IstatDizionarioDettagliSoggettoService istatDizionarioDettagliSoggettoService
    @WireVariable
    private AnaProfessioneService anaProfessioneService
    @WireVariable
    private AnaAttivitaService anaAttivitaService
    @WireVariable
    private AnaPosizioneProfessionaleService anaPosizioneProfessionaleService
    @WireVariable
    private AnaDocumentoAllegatoService anaDocumentoAllegatoService
    @WireVariable
    private AnaTipoDocumentoService anaTipoDocumentoService
    @WireVariable
    private AnaConvivenzaDiFattoService anaConvivenzaDiFattoService
    @WireVariable
    private AnaStatoService anaStatoService
    @WireVariable
    private AnaTipoRecapitoService anaTipoRecapitoService
    @WireVariable
    private CerTerminalistaService cerTerminalistaService
    @WireVariable
    private AnaRapportoParentelaService anaRapportoParentelaService
    @WireVariable
    private AnaRapportoParentelaIstatService anaRapportoParentelaIstatService
    @WireVariable
    private AnaUrnaCinerariaService anaUrnaCinerariaService
    @WireVariable
    private AnaPraticaService anaPraticaService
    @WireVariable
    private AnaDettaglioProvvedimentoService anaDettaglioProvvedimentoService
    @WireVariable
    private AnaEnteService anaEnteService
    @WireVariable
    private AnaMotivoProvvedimentoService anaMotivoProvvedimentoService
    @WireVariable
    private AnaTipoProvvedimentoService anaTipoProvvedimentoService

    @Override
    AnaCittadinanzaService getAnaCittadinanzaService() {
        return anaCittadinanzaService
    }

    @Override
    AnaStatoCivileService getAnaStatoCivileService() {
        return anaStatoCivileService
    }

    @Override
    AnaTitoloStudioService getAnaTitoloStudioService() {
        return anaTitoloStudioService
    }

    @Override
    AnaProfessioneService getAnaProfessioneService() {
        return anaProfessioneService
    }

    @Override
    AnaAttivitaService getAnaAttivitaService() {
        return anaAttivitaService
    }

    @Override
    AnaPosizioneProfessionaleService getAnaPosizioneProfessionaleService() {
        return anaPosizioneProfessionaleService
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }

    @Override
    ArcParametroService getArcParametroService() {
        return arcParametroService
    }

    @Override
    AnaTipoProvvedimentoService getAnaTipoProvvedimentoService() {
        return anaTipoProvvedimentoService
    }

    @Override
    AnaMotivoProvvedimentoService getAnaMotivoProvvedimentoService() {
        return anaMotivoProvvedimentoService
    }

    @Override
    AnaEnteService getAnaEnteService() {
        return anaEnteService
    }

    @Override
    AnaRapportoParentelaService getAnaRapportoParentelaService() {
        return anaRapportoParentelaService
    }

    @Override
    AnaAnagrafeService getAnaAnagrafeService() {
        return anaAnagrafeService
    }

    @Override
    AnaDocumentoService getAnaDocumentoService() {
        return anaDocumentoService
    }

    @Override
    AnaDocumentoAllegatoService getAnaDocumentoAllegatoService() {
        return anaDocumentoAllegatoService
    }

    @Override
    AnaTipoDocumentoService getAnaTipoDocumentoService() {
        return anaTipoDocumentoService
    }

    @Override
    AnaUrnaCinerariaService getAnaUrnaCinerariaService() {
        return anaUrnaCinerariaService
    }

    @Override
    AnaTipoRecapitoService getAnaTipoRecapitoService() {
        return anaTipoRecapitoService
    }

    @Override
    AnaDettaglioProvvedimentoService getAnaDettaglioProvvedimentoService() {
        return anaDettaglioProvvedimentoService
    }

    @Override
    AnaConvivenzaDiFattoService getAnaConvivenzaDiFattoService() {
        return anaConvivenzaDiFattoService
    }

    @Override
    CerTerminalistaService getCerTerminalistaService() {
        return cerTerminalistaService
    }


    AnaAnagrafe soggetto
    AnaPratica pratica
    Date dataPratica

    ETipoAnagrafe archivioAnagrafe
    ETipoPratica tipoPratica
    //La possibilità di modifica sarà limitata ai solo casi di pratica di iscrizione RES e AIRE
    ISoggettoPraticaIscrizione soggettoPratica

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]

    boolean modifica
    Boolean readOnly = false
    Boolean visualizzaSezioneIndividuo = false

    List<IstatDizionarioDettagliSoggetto> listaTitoliStudioIstat
    List<IstatDizionarioDettagliSoggetto> listaProfessioniIstat

    AnaStato statoInAttesa

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id,
         @ExecutionArgParam("modalita") String modalita,
         @ExecutionArgParam("idPratica") Long idPratica,
         @ExecutionArgParam("tipoFamiglia") ETipoFamiglia tipoFamiglia,
         @ExecutionArgParam("soggetto") ISoggettoPraticaIscrizione soggetto,
         @ExecutionArgParam("visualizzaIndividuo") boolean visualizzaIndividuo) {
        self = w

        pratica = anaPraticaService.findById(idPratica)

        this.dataPratica = pratica.data
        statoInAttesa = anaStatoService.getStatoInAttesa()

        initMinuscole()
        caricaListaNazionalita()
        initListeLookup(tipoFamiglia)
        listaTitoliStudioIstat = [null] + istatDizionarioDettagliSoggettoService.findAllByArchivioAndData(ETipoArchivioIstat.GDI, dataPratica)
        listaProfessioniIstat = [null] + istatDizionarioDettagliSoggettoService.findAllByArchivioAndData(ETipoArchivioIstat.CNP, dataPratica)
        modifica = modalita.equals('M')
        this.archivioAnagrafe = pratica.archivioAnagrafe
        this.tipoPratica = tipoPratica
        this.soggettoPratica = soggetto
        this.visualizzaSezioneIndividuo = visualizzaIndividuo

        List<Map<String, String>> eList = [Etichette.getEtichetta("Gestione_Soggetto"),Etichette.getEtichetta("Inserisci_Soggetto"), Etichette.getEtichetta("Sezione_Soggetto_Pratica")]
        eList.addAll(etichetteDettaglioDefault)
        eList.addAll([Etichette.getEtichetta("Ask_Collegamento_Anagrafe"), Etichette.getEtichetta("Ask_Nuova_Ricerca_Anagrafe"),
                      Etichette.getEtichetta("inserisci_urna_tooltip")])
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Chiudi"), Etichette.getEtichetta("Salva")])
        eList.addAll([Etichette.getEtichetta("Salvare_Dati_Soggetto"), Etichette.getEtichetta("Rapporto_Parentela_Istat_Non_Presente")])
        eList.addAll(etichetteGestioneIndividuo)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = modifica ? getEtichetta(Etichette.getEtichetta("Gestione_Soggetto")) : getEtichetta(Etichette.getEtichetta("Inserisci_Soggetto"))
        formLabel = msgTitle?.toUpperCase()

        if (id) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }


    }


    @Override
    void caricaDettaglio(Object id) {
        soggetto = anaAnagrafeService.findByIdSoggetto(id as Integer)
        // Carica urne cinerarie
        soggetto.urneCinerarie = anaAnagrafeService.getUrneCinerarie(soggetto)
        affidamentoUrneCinerarie = (soggetto.urneCinerarie && !soggetto.urneCinerarie.isEmpty()) ? ETipoSiNo.SI : ETipoSiNo.NO

        if (soggetto.convivenzaDiFatto) {
            convivenzaDiFatto = ETipoSiNo.SI
        } else {
            convivenzaDiFatto = ETipoSiNo.NO
        }

        if (visualizzaSezioneIndividuo) {
            caricaListaStatoCivile()
            caricaProfessioni()


            if (modifica) {
                if (soggetto.rapportoParentela) {
                    if (soggetto.sesso == ESesso.M) {
                        selectedRapportoParentela = rapportoParentelaMList.find { it?.id == soggetto.rapportoParentela.id }

                    } else {
                        selectedRapportoParentela = rapportoParentelaFList.find { it?.id == soggetto.rapportoParentela.id }
                    }
                    if (selectedRapportoParentela) {
                        onSelectRapportoParentela(false)
                    } else {
                        soggetto.rapportoParentela = null
                        soggettoPratica.rapportoParentela = null
                    }
                }
            } else {
                soggetto.rapportoParentela = null
                soggettoPratica.rapportoParentela = null
            }


            if (soggettoPratica.codiceTitoloStudioIstat) {
                soggettoPratica.titoloStudioIstat = listaTitoliStudioIstat.find { it?.codiceIstat == soggettoPratica.codiceTitoloStudioIstat }
            }
            if (soggettoPratica.codiceProfessioneIstat) {
                soggettoPratica.professioneIstat = listaProfessioniIstat.find { it?.codiceIstat == soggettoPratica.codiceProfessioneIstat }
            }

            provvedimentoDivorzio = anaDettaglioProvvedimentoService.findByPraticaAndSoggetto(pratica, soggetto)
            if (provvedimentoDivorzio == null) {
                provvedimentoDivorzio = anaDettaglioProvvedimentoService.findBySoggettoANPR(soggetto)
                if (provvedimentoDivorzio != null) {
                    provvedimentoDivorzio.pratica = pratica
                    provvedimentoDivorzio.archivioAnagrafe = pratica.archivioAnagrafe.id
                    provvedimentoDivorzio.tipoPratica = pratica.tipoPratica
                    provvedimentoDivorzio.annoPratica = pratica.anno
                    provvedimentoDivorzio.numeroPratica = pratica.numero
                }
            }
            provvedimento = provvedimentoDivorzio != null ? ETipoSiNo.SI : ETipoSiNo.NO
        }

    }

    @Override
    void creaDettaglio(Map params) {
        soggetto = new AnaAnagrafe()
    }

    @Override
    void onSessoChanged() {
        onModificaDatiSoggetto()
    }

    @Command
    void onSelectRapportoParentela(@BindingParam("mostraMessaggio") boolean mostraMessaggio) {
        if(selectedRapportoParentela != null) {
            soggetto.rapportoParentela = selectedRapportoParentela
            soggetto.codRp = selectedRapportoParentela.codiceRapportoParentela
            soggetto.sequenzaParentela = selectedRapportoParentela.sequenza
            soggettoPratica.rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(soggetto.sesso, soggetto.rapportoParentela.codiceRapportoParentela)
            if (soggettoPratica.rapportoParentela == null) {
                soggettoPratica.rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(soggetto.sesso, CONVIVENTE)
                if(mostraMessaggio) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Rapporto_Parentela_Istat_Non_Presente")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
            }

        } else {
            soggettoPratica.rapportoParentela = null
            soggetto.codRp = null
            soggetto.sequenzaParentela = null
            soggettoPratica.rapportoParentela = null
        }
        refreshUi()
    }

    @Command
    void onSelectTitoloStudio() {
        soggettoPratica.titoloStudioIstat = listaTitoliStudioIstat.find { it?.gruppo == soggetto.titoloStudio.gruppo}
        refreshUi()
    }

    @Override
    void onDataNascitaChanged() {
        onModificaDatiSoggetto()
    }

    @Command
    void onModificaDatiSoggetto(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        if (soggetto.id) {
            AnaAnagrafe soggOld = anaAnagrafeService.findById(soggetto.matricola)
            String datiSoggetto = "(${soggOld.cognome.toUpperCase()} ${soggOld.nome.toUpperCase()} - ${soggOld.sesso.name()} - ${soggOld.dataNascita.format('dd/MM/yyyy')} - matr. ${soggOld.matricola})?"
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Collegamento_Anagrafe")) + "\n " + datiSoggetto, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                log.info("Si è scelto di mantenere il collegamento con l'anagrafe")
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                svuotaMatricola("I")
                                Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Nuova_Ricerca_Anagrafe")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                                        new org.zkoss.zk.ui.event.EventListener() {
                                            void onEvent(Event ev2) {
                                                if (Messagebox.ON_YES.equals(ev2.getName())) {
                                                    onRicercaSoggetto("I")
                                                }
                                                if (Messagebox.ON_NO.equals(ev2.getName())) {
                                                    log.info("Si è scelto dinon effettuare ricerca")
                                                    refreshUi()
                                                }
                                            }
                                        }
                                )

                            }
                        }
                    }
            )
        }
        onAggiornaCase(e)
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Override
    Object getDettaglio() {
        return soggetto
    }

    @Command
    void onAggiungi() {
        salva()
        if(visualizzaSezioneIndividuo) {
            soggettoPratica.anagrafe = soggetto
            soggettoPratica.sesso = soggetto.sesso
        }
        Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, soggettoPratica)
        onChiudi()
    }

    @Command
    void onSalva() {
        salva()
        convivenzaDiFatto = ETipoSiNo.NO
        affidamentoUrneCinerarie = ETipoSiNo.NO
        refreshUi()
    }

    private salva() {
        checkDatiObbligatoriIndividuo()


        //Persistenza Soggetto
        if (soggetto.id == null) {
            //Nuovo soggetto
            soggetto.id = gsdService.getIntegerIdFromSequence(soggetto, soggetto.getTableName())
            soggetto.fascia = EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA
            soggetto.stato = statoInAttesa
            soggetto.dataUltimoEvento = dataPratica
        } else {
            if (visualizzaSezioneIndividuo &&
                    (soggetto.fascia == EFascia.NON_RESIDENTE || soggetto.fascia == EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA)) {
                soggetto.fascia = EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA
                soggetto.stato = statoInAttesa
                soggetto.dataUltimoEvento = dataPratica
            }
        }
        salvaIndividuo()
    }

}
