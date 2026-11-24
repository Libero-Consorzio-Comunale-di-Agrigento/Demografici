package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazionePraticaService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarPraticaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitVia

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractPraticaDettaglioViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitVia, TraitComune {


    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @Delegate
    ControlBarPraticaAttributes cbAtto = new ControlBarPraticaAttributes()

    AnaPratica pratica

    @WireVariable
    private AnaPraticaService anaPraticaService
    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    protected GsdService gsdService
    @WireVariable
    protected AnaVariazioneService anaVariazioneService
    @WireVariable
    private AnaTipoConvivnezaService anaTipoConvivnezaService
    @WireVariable
    protected ArcParametroService arcParametroService
    @WireVariable
    protected AnaDizionarioPraticheService anaDizionarioPraticheService
    @WireVariable
    protected AnaStatoService anaStatoService
    @WireVariable
    AnaEventoPraticaService anaEventoPraticaService
    @WireVariable
    AnaFamigliaService anaFamigliaService
    @WireVariable
    AnaComunicazionePraticaService anaComunicazionePraticaService
    @WireVariable
    protected ArcComuneBaseService arcComuneBaseService
    @WireVariable
    protected AnaAnagrafeService anaAnagrafeService
    @WireVariable
    protected AnaRapportoParentelaService anaRapportoParentelaService


    ETipoSiNo numeraPratica
    boolean abilitaNumero
    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]

    List<AnaDizionarioPratiche> listaIniziative

    List<AnaVariazione> listaVariazioni
    AnaVariazione selectedVariazione

    List<AnaTipoConvivenza> listaTipoConvivenza

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    final List<ETipoFamiglia> listaTipoFamiglia = [null] + Arrays.asList(ETipoFamiglia.values())

    ETipoSiNo legittima

    boolean comuneProvenienzaEstero = false

    boolean recuperoEstremiDaStradario
    boolean estremiStradario

    List<AnaRapportoParentela> rapportoParentelaMList
    List<AnaRapportoParentela> rapportoParentelaFList
    List<AnaRapportoParentela> rapportoParentelaMPrecList
    List<AnaRapportoParentela> rapportoParentelaFPrecList

    List<ISoggettoPratica> listaDichiaranti = []
    ISoggettoPratica selectedDichiarante

    List<ArcComune> listaStati = []
    ArcComune selectedStato = null

    protected boolean modifica
    AnaEventoPratica eventoAnnullamento
    AnaEventoPratica eventoPerfezionamento

    boolean caratteriSpecialiEnabled = false
    Boolean tuttiSoggettiSelezionati = false

    Boolean readOnly

    protected static final String CAPO_FAMIGLIA = 'CF'
    protected static final String CAPO_CONVIVENZA = 'CC'
    protected static final String INTESTATARIO_SCHEDA = "I.S."


    void doInit(Window w, Long id, boolean modifica, boolean readOnly) {
        self = w
        deleteRecordEnabled = true
        saveRecordEnabled = true
        recuperoEstremiDaStradario = (arcParametroService.get(ArcParametro.ADOI_ECSTR)?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
        estremiStradario = (arcParametroService.get(ArcParametro.ADOI_ECTPR)?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
        abilitaNumero = false

        caratteriSpecialiEnabled = (arcParametroService.get(ArcParametro.UNICODE)?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())

        listaTipoConvivenza = [new AnaTipoConvivenza(descrizione: '--')] + anaTipoConvivnezaService.findAll()
        this.modifica = modifica
        eventoAnnullamento = anaEventoPraticaService.getAvanzamentoAnnullamento()
        eventoPerfezionamento = anaEventoPraticaService.getAvanzamentoPerfezionamento()

        if (modifica) {
            caricaDettaglio(id)
            tuttiSoggettiSelezionati = isAllSoggettiSelezionati()
        } else {
            pratica = new AnaPratica()
            pratica.anno = DataUtils.getAnnoCorrente()
            pratica.data = DataUtils.getDataCorrente()
            pratica.archivioAnagrafe = archivioAnagrafe
            pratica.tipoPratica = tipoPratica

            numeraPratica = ETipoSiNo.SI
            legittima = ETipoSiNo.NO

            creaDettaglio([:])

        }

        listaVariazioni = anaVariazioneService.findVariazioniValide(pratica.archivioAnagrafe, pratica.tipoPratica)
        filtraVariazioni()
        listaIniziative = anaDizionarioPraticheService.findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(pratica.archivioAnagrafe, pratica.tipoPratica, ETipoArchivioDizionario.INIZIATIVA)

        if (modifica) {
            selectedVariazione = listaVariazioni.find { it.codiceVariazioneTpr == pratica.codiceVariazione }
        } else {
            if (tipoPratica != ETipoPratica.RET) {
                selectedVariazione = listaVariazioni.first()
            }

        }

        this.readOnly = readOnly

        msgTitle = "${tipoPratica.getEtichettaDesc().defaultValue} ${archivioAnagrafe.getEtichettaDesc().defaultValue}"
        formLabel = msgTitle?.toUpperCase()
    }

    protected void caricaPratica(Long id) {
        pratica = anaPraticaService.findById(id)
        if (pratica.numero > 0) {
            numeraPratica = ETipoSiNo.SI
        } else {
            numeraPratica = ETipoSiNo.NO
        }
        if (pratica?.occupazioneImmobile?.flagLegittima) {
            legittima = ETipoSiNo.SI
        } else {
            legittima = ETipoSiNo.NO
        }
    }

    void doInitEtichette(List<Map<String, String>> eList = []) {

        eList.addAll(etichetteDettaglioDefault)

        //Etichette enumerativi
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)
        eList.addAll(ControlBarPraticaAttributes.etichetteCbPraticaDesc)

        eList.addAll(AnaPratica.etichetteDomain)
        // Aggiungo etichette per valori campi di ricerca
        eList.addAll([Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Abilita_Numero"), Etichette.getEtichetta("Ask_Cancellazione_Record")])
        eList.addAll([Etichette.getEtichetta("Salva_Pratica"), Etichette.getEtichetta("Salva"), Etichette.getEtichetta("Salva_Perfeziona"),
                      Etichette.getEtichetta("Salva_Annulla"), Etichette.getEtichetta("Aggiorna_Evento"), Etichette.getEtichetta("Elimina_Evento")])

        eList.addAll([Etichette.getEtichetta("Sezione_Informazioni_Pratica"), Etichette.getEtichetta("Sezione_Dichiarante_Pratica"),
                      Etichette.getEtichetta("Sezione_Famiglia_Pratica"), Etichette.getEtichetta("Sezione_Provenienza_Pratica"),
                      Etichette.getEtichetta("Sezione_Occupazione_Immobile_Pratica"), Etichette.getEtichetta("Sezione_Soggetti_Pratica"),
                      Etichette.getEtichetta("Sezione_Modello_Apr_Pratica"), Etichette.getEtichetta("Sezione_Modello_Aire_01_Cancellazione")])
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())
        eList.addAll(Etichette.getEtichetta("Ricerca_in_Anagrafe"), Etichette.getEtichetta("Inserire_Soggetto"),
                Etichette.getEtichetta("Famiglia_Non_Associata"), Etichette.getEtichetta("Trasferire_Intero_Nucleo"), Etichette.getEtichetta("Accedere_Comunicazioni_ANPR"))

        //Famiglia
        eList.addAll(ETipoFamiglia.values()*.etichettaDesc)

        //Occupazione Immobile
        eList.addAll(AnaOccupazioneImmobile.etichetteDomain)

        //Soggetti
        eList.addAll([Etichette.getEtichetta("inserisci_soggetto_tooltip"), Etichette.getEtichetta("modifica_tooltip"),
                      Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("Famiglia_tooltip"), Etichette.getEtichetta("caratteri_speciali_tooltip"),
                      Etichette.getEtichetta("Nessun_Soggetto_Inserito"), Etichette.getEtichetta("Elimina_Soggetto"), Etichette.getEtichetta("Elimina_Famiglia"),
                      Etichette.getEtichetta("Impossibile_Inserire_Soggetto_Aire"), Etichette.getEtichetta("Famiglia_Non_Reperibile"),
                      Etichette.getEtichetta("Annulla"), Etichette.getEtichetta("Soggetto_Presente"), Etichette.getEtichetta("Rapporto_Parentela_Errato"),
                      Etichette.getEtichetta("Inserire_Soggetti"), Etichette.getEtichetta("Inserire_Variazioni"), Etichette.getEtichetta("Numero_Ordine_Presente")])


        //Messaggi annullamento
        eList.addAll([Etichette.getEtichetta("Annullamento_Pratica"), Etichette.getEtichetta("Annullamento_Soggetti"), Etichette.getEtichetta("Tutti_Soggetti_Annullati")])

        //Controllo dati
        eList.addAll([Etichette.getEtichetta("IS_Aggregazione"), Etichette.getEtichetta("IS_Errati"), Etichette.getEtichetta("IS_Creazione"), Etichette.getEtichetta("CC_Presente_Aggregazione"),
                      Etichette.getEtichetta("CC_Aggregazione"), Etichette.getEtichetta("CC_Creazione"), Etichette.getEtichetta("IS_Famiglia_Prec")])

        //Messaggi perfezionamento
        eList.addAll([Etichette.getEtichetta("Impossibile_Perfezionare_Iscrizone_Preliminare"), Etichette.getEtichetta("Annullamento_Pratica"),
                      Etichette.getEtichetta("Perfezionamento_Pratica"), Etichette.getEtichetta("Effettuare_Ricerca_Famiglia")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)
    }

    @Override
    boolean getCanDeleteRecord() {
        return pratica?.id != null && !(pratica.flagPerfezionamentoPreliminare || pratica.flagPerfezionamento || pratica.flagAnnullamento)
    }

    @Command
    void onEliminaRecord() {
        if (pratica) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                String msg =gsdService.eliminaPratica(pratica)
                                if(msg) {
                                    Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
                                } else {
                                    Messagebox.show("Eliminazione avvenuta con successo", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                                    onChiudi()
                                }
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Override
    boolean getCanSaveRecord() {
        return !readOnly
    }

    @Command
    void onSalvaRecord() {
        if (pratica.id == null) {
            onSalvaPratica()
        } else {
            onSalva()
        }
    }

    @Command
    void onSelectNumera() {
        pratica.numero = null
        refreshUi()
    }

    @Command
    void onSelectVariazione() {
        pratica.codiceVariazione = selectedVariazione?.codiceVariazioneTpr
        if (!modifica) {
            pratica.iniziativa = listaIniziative.find { it.codice == selectedVariazione?.tipoRichiestaDefault }
            popolaDefault()
        }
        refreshUi()
    }

    @Command
    void svuotaMatricolaECodiceDichiarante() {
        pratica.matricolaDichiarante = null
        pratica.codFamigliaDichiarante = null
        refreshUi()
    }

    @Command
    void onRicercaSoggetto(@BindingParam("sezione") String sezione) {
        switch (sezione) {
            case 'D':
                Map params = [cognome: pratica.cognomeDichiarante?.toUpperCase(), nome: pratica.nomeDichiarante?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        caricaDatiDichiarante(ana)
                    }
                })
                w.doModal()
                break
            case 'I':
                Map params = [cognome: dichiarazione.cognomeIntestatarioConvivenza?.toUpperCase(), nome: dichiarazione.nomeIntestatarioConvivenza?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        caricaDatiIntestatario(ana)
                    }
                })
                w.doModal()
                break
            case 'COM_PROP':
                Map params = [sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        pratica.occupazioneImmobile.nomeProprietaComodato = "${ana.cognome} ${ana.nome}"
                        pratica.occupazioneImmobile.cfProprietaComodato = ana.codiceFiscale
                        pratica.occupazioneImmobile.comuneProprietaComodato.descrizione = ana.comuneResidenza.descrizione
                        pratica.occupazioneImmobile.comuneProprietaComodato.codice = ana.comuneResidenza.codice
                        pratica.occupazioneImmobile.comuneProprietaComodato.siglaProvincia = ana.comuneResidenza.siglaProvincia
                        pratica.occupazioneImmobile.comuneProprietaComodato.codiceProvincia = ana.comuneResidenza.codiceProvincia
                        pratica.occupazioneImmobile.comuneProprietaComodatoString = ana.comuneResidenza.descrizione
                        pratica.occupazioneImmobile.viaProprietaComodato = ana.indirizzo.via
                        refreshUi()
                    }
                })
                w.doModal()
                break
            case 'LOC_PROP':
                Map params = [sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        pratica.occupazioneImmobile.nomeProprietaLocazione = "${ana.cognome} ${ana.nome}"
                        pratica.occupazioneImmobile.cfProprietaLocazione = ana.codiceFiscale
                        pratica.occupazioneImmobile.comuneProprietaLocazione.descrizione = ana.comuneResidenza.descrizione
                        pratica.occupazioneImmobile.comuneProprietaLocazione.codice = ana.comuneResidenza.codice
                        pratica.occupazioneImmobile.comuneProprietaLocazione.siglaProvincia = ana.comuneResidenza.siglaProvincia
                        pratica.occupazioneImmobile.comuneProprietaLocazione.codiceProvincia = ana.comuneResidenza.codiceProvincia
                        pratica.occupazioneImmobile.comuneProprietaLocazioneString = ana.comuneResidenza.descrizione
                        pratica.occupazioneImmobile.viaProprietaLocazione = ana.indirizzo.via
                        refreshUi()
                    }
                })
                w.doModal()
                break
        }
    }

    @Command
    void onRicercaFamiglia() {
        Map params = [via       : dichiarazione.indirizzo.via, numeroCivico: dichiarazione.indirizzo.numeroCivico,
                      suffisso  : dichiarazione.indirizzo.suffisso, interno: dichiarazione.indirizzo.interno,
                      subinterno: dichiarazione.indirizzo.subInterno, piano: dichiarazione.indirizzo.piano,
                      scala     : dichiarazione.indirizzo.scala, tipoFamiglia: dichiarazione.tipoFamiglia,
                      fascia    : fascia]

        Window w = (Window) Executions.createComponents("/restrict/anagrafe/famigliaSelect.zul", self, params)
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data instanceof AnaIndirizzoStradario) {
                AnaIndirizzoStradario famiglia = (AnaIndirizzoStradario) event.data
                caricaDatiFamiglia(famiglia)
            }
        })
        w.doModal()

    }

    @Command
    void svuotaCodiciFamiglia() {
        dichiarazione.codFamigliaDest = null
        dichiarazione.famigliaDest = null
        refreshUi()
    }

    @Command
    void onCancellaCampoPratica(@BindingParam("sezione") String sezione, @ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        switch (sezione) {
            case 'F':
                cancellaCampo(dichiarazione, p)
                if (tipoPratica != ETipoPratica.RET) {
                    svuotaCodiciFamiglia()
                }
                break
            case 'D':
                cancellaCampo(pratica, p)
                svuotaMatricolaECodiceDichiarante()
                break
            case 'C':
                cancellaCampo(dichiarazione, p)
                if (p.equals("cognomeIntestatarioConvivenza") || p.equals("nomeIntestatarioConvivenza")) {
                    svuotaMatricolaIntestatario()
                }
                break
            case 'I':
                cancellaCampo(pratica.occupazioneImmobile, p)
                break
            case 'M':
                cancellaCampo(pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione, p)
                break
        }

        refreshUi()

    }

    protected void caricaDatiDichiarante(AnaAnagrafeBaseDomain ana) {
        pratica.cognomeDichiarante = ana.cognome
        pratica.nomeDichiarante = ana.nome
        pratica.matricolaDichiarante = ana.matricola
        refreshUi()
    }

    protected void caricaDatiIntestatario(AnaAnagrafeBaseDomain ana) {
        dichiarazione.cognomeIntestatarioConvivenza = ana.cognome
        dichiarazione.nomeIntestatarioConvivenza = ana.nome
        dichiarazione.intestatarioConvivenza = ana
        refreshUi()
    }

    protected void caricaDatiFamiglia(AnaIndirizzoStradario famiglia) {
        IndirizzoCivico indirizzoFamiglia = famiglia.getIndirizzo().indirizzo
        copiaDatiIndirizzo(dichiarazione.indirizzo, indirizzoFamiglia)
        dichiarazione.tipoFamiglia = famiglia.tipoFamiglia

        if (dichiarazione.flagAggregazione) {
            dichiarazione.codFamigliaDest = famiglia.codice
            dichiarazione.famigliaDest = famiglia.famiglia
            dichiarazione.cognomePresso = famiglia.cognomeIntestatario
            dichiarazione.nomePresso = famiglia.nomeIntestatario
            if (famiglia.tipoFamiglia == ETipoFamiglia.CONVIVENZA && famiglia.famiglia) {
                dichiarazione.tipoConvivenza = listaTipoConvivenza.find { it.id == famiglia.famiglia.tipoConvivenza.id }
                dichiarazione.convivenza = famiglia.famiglia.descrizioneConvivenza
                dichiarazione.cognomeIntestatarioConvivenza = famiglia.famiglia.cognomeIntestatario
                dichiarazione.nomeIntestatarioConvivenza = famiglia.famiglia.nomeIntestatario
                dichiarazione.intestatarioConvivenza = famiglia.famiglia.intestatarioConvivenza
                dichiarazione.dataIntestatarioConvivenza = famiglia.famiglia.dataIntestatarioConvivenza
                dichiarazione.dataIstituzioneConvivenza = famiglia.famiglia.dataIstituzioneConvivenza
            }
        }

        if (recuperoEstremiDaStradario) {
            pratica.occupazioneImmobile.sezioneCatastoTpr = famiglia.sezioneCatasto
            pratica.occupazioneImmobile.foglioCatastoTpr = famiglia.foglioCatasto
            pratica.occupazioneImmobile.numeroCatastoTpr = famiglia.numeroCatasto
            pratica.occupazioneImmobile.subalternoCatastoTpr = famiglia.subalternoCatasto
        }

        if (!dichiarazione.flagAggregazione && famiglia.famiglia) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Famiglia_Non_Associata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        refreshUi()
    }

    void refreshUi() {
        BindUtils.postNotifyChange(null, null, this, "*")
    }

    void inizializzazioneIndividuo() {
        // hook - no-op di default
    }

    @Override
    void selezionaVia(ArcVia c) {
        dichiarazione.indirizzo.via = c
        dichiarazione.codFamigliaDest = null
        dichiarazione.famigliaDest = null
    }

    @Override
    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c) {
        switch (tca) {
            case ETipoComuneAtto.PROV:
                riempiComuneProvenienza(ETipoComuneAtto.PROV, c)
                break
            case ETipoComuneAtto.ISC_AIRE:
                riempiComuneProvenienza(ETipoComuneAtto.ISC_AIRE, c)
                break
            case ETipoComuneAtto.LOC:
                riempiComune(pratica.occupazioneImmobile.comuneProprietaLocazione, c)
                pratica.occupazioneImmobile.comuneProprietaLocazioneString = pratica.occupazioneImmobile.comuneProprietaLocazione.descrizione
                break
            case ETipoComuneAtto.LOC_SEDE:
                pratica.occupazioneImmobile.sedeContrattoLocazione = c?.descrizioneComune
                break
            case ETipoComuneAtto.COM:
                riempiComune(pratica.occupazioneImmobile.comuneProprietaComodato, c)
                pratica.occupazioneImmobile.comuneProprietaComodatoString = pratica.occupazioneImmobile.comuneProprietaComodato.descrizione
                break
            case ETipoComuneAtto.COM_SEDE:
                pratica.occupazioneImmobile.sedeContrattoComodato = c?.descrizioneComune
                break
        }
        refreshUi()
    }


    @Command
    void onSelectAggregazione() {
        if (dichiarazione.flagAggregazione) { //SI
            svuotaConvivenza()
            notificaCampiConvivenza()
        } else { //NO
            dichiarazione.cognomePresso = null
            dichiarazione.nomePresso = null
            dichiarazione.codFamigliaDest = null
            dichiarazione.famigliaDest = null
            BindUtils.postNotifyChange(null, null, dichiarazione, "cognomePresso")
            BindUtils.postNotifyChange(null, null, dichiarazione, "nomePresso")
            BindUtils.postNotifyChange(null, null, dichiarazione, "codFamigliaDest")
            BindUtils.postNotifyChange(null, null, dichiarazione, "famigliaDest")
        }
        // Forza rivalutazione delle visible in soggetti che usano isRapportoParentela*NonModificabile()
        // (metodi che dipendono da flagAggregazione ma non tracciati da ZK)
        impostaRapportoParentelaDefault()
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaNuovoNonModificabile")
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaPrecedenteNonModificabile")
        BindUtils.postNotifyChange(null, null, this, "soggetti")
    }

    private void notificaCampiConvivenza() {
        BindUtils.postNotifyChange(null, null, dichiarazione, "tipoConvivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "convivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "dataIstituzioneConvivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "intestatarioConvivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "cognomeIntestatarioConvivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "nomeIntestatarioConvivenza")
        BindUtils.postNotifyChange(null, null, dichiarazione, "dataIntestatarioConvivenza")
    }

    @Command
    void onSelectTipoFamiglia() {
        if (!(dichiarazione.tipoFamiglia == ETipoFamiglia.CONVIVENZA)) {
            svuotaConvivenza()
            notificaCampiConvivenza()
        }
        dichiarazione.codFamigliaDest = null
        dichiarazione.famigliaDest = null
        popolaRapportoParentelaLists()
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaMList")
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaFList")
        BindUtils.postNotifyChange(null, null, dichiarazione, "codFamigliaDest")
        BindUtils.postNotifyChange(null, null, dichiarazione, "famigliaDest")
        // Forza rivalutazione delle visible in soggetti che usano isRapportoParentela*NonModificabile()
        // (metodi che dipendono da tipoFamiglia/flagAggregazione ma non tracciati da ZK)
        impostaRapportoParentelaDefault()
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaNuovoNonModificabile")
        BindUtils.postNotifyChange(null, null, this, "rapportoParentelaPrecedenteNonModificabile")
        BindUtils.postNotifyChange(null, null, this, "soggetti")
    }

    private void svuotaConvivenza() {
        dichiarazione.tipoConvivenza = listaTipoConvivenza.first()
        dichiarazione.convivenza = null
        dichiarazione.dataIstituzioneConvivenza = null
        dichiarazione.intestatarioConvivenza = null
        dichiarazione.cognomeIntestatarioConvivenza = null
        dichiarazione.nomeIntestatarioConvivenza = null
        dichiarazione.dataIntestatarioConvivenza = null
    }

    @Command
    svuotaMatricolaIntestatario() {
        dichiarazione.intestatarioConvivenza = null
        refreshUi()
    }

    @Command
    onSelectLegittima() {
        pratica.occupazioneImmobile.flagLegittima = legittima == ETipoSiNo.SI
        onCheck(0)
    }

    @Command
    onCheck(@BindingParam("check") int numeroCheck) {

        resetCheck(numeroCheck)
        if (numeroCheck > 0) {
            if (pratica.occupazioneImmobile.flagProprietario && (estremiStradario || recuperoEstremiDaStradario)) {
                pratica.occupazioneImmobile.sezioneCatasto = pratica.occupazioneImmobile.sezioneCatastoTpr
                pratica.occupazioneImmobile.foglioCatasto = pratica.occupazioneImmobile.foglioCatastoTpr
                pratica.occupazioneImmobile.numeroCatasto = pratica.occupazioneImmobile.numeroCatastoTpr
                pratica.occupazioneImmobile.subalternoCatasto = pratica.occupazioneImmobile.subalternoCatastoTpr
            } else {
                pratica.occupazioneImmobile.sezioneCatasto = null
                pratica.occupazioneImmobile.foglioCatasto = null
                pratica.occupazioneImmobile.numeroCatasto = null
                pratica.occupazioneImmobile.subalternoCatasto = null
            }

            if (!pratica.occupazioneImmobile.flagLocazione) {
                pratica.occupazioneImmobile.sedeContrattoLocazione = null
                pratica.occupazioneImmobile.dataContrattoLocazione = null
                pratica.occupazioneImmobile.numeroContrattoLocazione = null
                pratica.occupazioneImmobile.nomeProprietaLocazione = null
                pratica.occupazioneImmobile.cfProprietaLocazione = null
                pratica.occupazioneImmobile.comuneProprietaLocazione = null
                pratica.occupazioneImmobile.comuneProprietaLocazioneString = null
                pratica.occupazioneImmobile.viaProprietaLocazione = null
            }

            if (!pratica.occupazioneImmobile.flagLocazioneErp) {
                pratica.occupazioneImmobile.noteLocazioneErp = null
            }

            if (!pratica.occupazioneImmobile.flagComodato) {
                pratica.occupazioneImmobile.sedeContrattoComodato = null
                pratica.occupazioneImmobile.dataContrattoComodato = null
                pratica.occupazioneImmobile.numeroContrattoComodato = null
                pratica.occupazioneImmobile.nomeProprietaComodato = null
                pratica.occupazioneImmobile.cfProprietaComodato = null
                pratica.occupazioneImmobile.comuneProprietaComodato = null
                pratica.occupazioneImmobile.comuneProprietaComodatoString = null
                pratica.occupazioneImmobile.viaProprietaComodato = null
            }

            if (!pratica.occupazioneImmobile.flagUsufrutto) {
                pratica.occupazioneImmobile.noteUsufrutto = null
            }

            if (!pratica.occupazioneImmobile.flagTitolo) {
                pratica.occupazioneImmobile.noteTitolo = null
            }
        }

        refreshUi()

    }

    private resetCheck(int numeroCheck) {
        if (numeroCheck != 1) {
            pratica.occupazioneImmobile.flagProprietario = false
        }
        if (numeroCheck != 2) {
            pratica.occupazioneImmobile.flagLocazione = false
        }
        if (numeroCheck != 3) {
            pratica.occupazioneImmobile.flagLocazioneErp = false
        }
        if (numeroCheck != 4) {
            pratica.occupazioneImmobile.flagComodato = false
        }
        if (numeroCheck != 5) {
            pratica.occupazioneImmobile.flagUsufrutto = false
        }
        if (numeroCheck != 6) {
            pratica.occupazioneImmobile.flagTitolo = false
        }

    }

    boolean isSoggettiFamigliaToShow(AnaAnagrafeBaseDomain ana) {
        return ana instanceof AnaAnagrafe && (isIscrizioneAprDaAire(ana) || isVariazione() || isRettificaFamiglia())
    }


    boolean isIscrizioneAprDaAire(AnaAnagrafeBaseDomain ana) {
        return ana.fascia == EFascia.ISCRITTO_AIRE && pratica.tipoPratica == ETipoPratica.ISC
    }

    boolean isVariazione() {
        return pratica.tipoPratica == ETipoPratica.VAR
    }

    boolean isAllSoggettiSelezionati() {
        return getSoggettiNonOrdinati().every { it.flagSoggetto }
    }

    boolean isSoggettoISSelezionato() {
        for (ISoggettoPratica s : getSoggettiNonOrdinati()) {
            if (s.anagrafe.rapportoParentelaDescrizione == INTESTATARIO_SCHEDA && s.flagSoggetto) {
                return true
            }
        }
        return false
    }

    boolean isRapportoParentelaPrecedenteNonModificabile() {
        return !isAllSoggettiSelezionati() && !isSoggettoISSelezionato()
    }

    boolean isRapportoParentelaNuovoNonModificabile() {
        return isTipoFamigliaOrigUgualeANuovo() && isAllSoggettiSelezionati() && !dichiarazione.flagAggregazione
    }

    boolean isTipoFamigliaOrigUgualeANuovo() {
        return dichiarazione.tipoFamigliaOriginario == dichiarazione.tipoFamiglia
    }

    @Command
    void onInserisciSoggetto() {
        checkAndSalvaPratica(false) // Salvo eventuali nuovi dati inseriti prima di aprire il pop up
        Map params = [inserimentoSoggetto: tipoPratica == ETipoPratica.ISC, sessoEnabled: Boolean.TRUE, archivioAnagrafe: archivioAnagrafe, tipoPratica: tipoPratica, flagInserimento: Boolean.TRUE]
        Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            Integer id = null
            if (event.data instanceof AnaAnagrafeBaseDomain) {
                AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                if (ana instanceof AnpAnagrafe && ana.anagrafe != null) {
                    ana = ana.anagrafe
                }
                if (isSoggettiFamigliaToShow(ana)) {
                    if (soggetti.isEmpty() && (ana as AnaAnagrafe).famiglia != null) {
                        if ((isVariazione() || isIscrizioneAprDaAire(ana)) && (ana as AnaAnagrafe).famiglia.numeroComponenti > 1) {
                            String msg = "${isIscrizioneAprDaAire(ana) ? 'Codice Variazione: Reimmigrazione da AIRE.\n\n' : ''}${getEtichetta(Etichette.getEtichetta("Trasferire_Intero_Nucleo"))}"
                            Messagebox.show(msg, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                                    new org.zkoss.zk.ui.event.EventListener() {
                                        void onEvent(Event ev) {
                                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                                popolaFamigliari(ana as AnaAnagrafe, true)
                                            }
                                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                                popolaFamigliari(ana as AnaAnagrafe, false)
                                            }
                                        }
                                    })

                        } else {
                            //Rettifica o 1 solo componente
                            if(isIscrizioneAprDaAire(ana)) {
                                Messagebox.show("Codice Variazione: Reimmigrazione da AIRE.", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                                popolaFamigliari(ana as AnaAnagrafe, true)
                            } else {
                                popolaFamigliari(ana as AnaAnagrafe, true)
                            }

                        }
                    } else {
                        if (!soggetti.isEmpty()) {
                            Messagebox.show(getEtichetta(Etichette.getEtichetta("Impossibile_Inserire_Soggetto_Aire")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                        } else if ((ana as AnaAnagrafe).famiglia == null) {
                            Messagebox.show(getEtichetta(Etichette.getEtichetta("Famiglia_Non_Reperibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                            //Oppure se famiglia null vuol dire che non ha famiglia associata?
                        }
                    }
                    return
                }
                id = ana.matricola
            }

            if (isRettificaIndividuo()) {
                ISoggettoPratica sogg = getNewSoggetto()
                sogg.anagrafe = anaAnagrafeService.findByIdSoggetto(id as Integer)
                aggiungiSoggetto(sogg)
                popolaListaDichiaranti()
                inizializzazioneIndividuo()
                refreshUi()
            } else {
                Window wSogg = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneSoggetto.zul", self, [id      : id, modalita: 'I', idPratica: pratica.id, tipoFamiglia: dichiarazione.tipoFamiglia,
                                                                                                                               soggetto: getNewSoggetto(), visualizzaIndividuo: true])
                wSogg.addEventListener(CustomEvents.ON_SELECT_RECORD, { eventSogg ->
                    if (eventSogg.data instanceof ISoggettoPraticaIscrizione) {
                        ISoggettoPratica sogg = (ISoggettoPratica) eventSogg.data
                        aggiungiSoggetto(sogg)
                        popolaListaDichiaranti()
                        refreshComunicazioniEAdempimenti()
                        caricaDettaglio(pratica.id)
                        refreshUi()
                    }
                })
                wSogg.doModal()
            }

        })
        w.doModal()
    }

    void popolaFamigliari(AnaAnagrafe ana, Boolean interoNucleo) {
        // Leggo la famiglia da DB a causa della chiusura della sessiona dovuta alla messageBox
        AnaFamiglia famiglia = anaFamigliaService.get(ana.famiglia.id, [:])
        inserisciSoggettiFamiglia(famiglia, interoNucleo)
        popolaListaDichiaranti()
        refreshComunicazioniEAdempimenti()
        refreshUi()
    }

    //Operazione consentita solo in pratiche di ISCRIZIONE RES/AIRE
    @Command
    void onModificaSoggetto(@BindingParam("soggetto") ISoggettoPratica soggetto) {
        checkAndSalvaPratica(false) // Salvo eventuali nuovi dati inseriti prima di aprire il pop up
        ISoggettoPraticaIscrizione s = !(isIscrizioneAprDaAire(soggetto.anagrafe) || isVariazione()) ? soggetto : null
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneSoggetto.zul", self, [id                 : soggetto.anagrafe.id, modalita: 'M', idPratica: pratica.id,
                                                                                                                   tipoFamiglia       : dichiarazione.tipoFamiglia, soggetto: s,
                                                                                                                   visualizzaIndividuo: !(isIscrizioneAprDaAire(soggetto.anagrafe) || isVariazione())])
        w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
            if (event.data != null && event.data instanceof ISoggettoPraticaIscrizione) {
                ISoggettoPraticaIscrizione sogg = (ISoggettoPraticaIscrizione) event.data
                aggiornaSoggetto(soggetto, sogg)
                popolaListaDichiaranti()
                caricaDettaglio(pratica.id)
                refreshUi()
            }

        })
        w.doModal()

    }

    @Command
    void onEliminaSoggetto(@BindingParam("soggetto") ISoggettoPratica soggetto) {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Elimina_Soggetto")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event ev) {
                        if (Messagebox.ON_YES.equals(ev.getName())) {
                            if (isRettificaIndividuo()) {
                                getSoggetti().get(0).dichiarazione = null
                                getSoggetti().clear()
                                selectedDichiarante = null
                            } else {
                                eliminaSoggetto(soggetto)
                                popolaListaDichiaranti()
                                if (soggetto.anagrafe.matricola == selectedDichiarante?.anagrafe?.matricola) {
                                    selectedDichiarante = null
                                }
                            }
                            refreshUi()
                        }
                        if (Messagebox.ON_NO.equals(ev.getName())) {
                            log.info("Si è scelto di non eliminare il soggetto")
                        }
                    }
                })

    }

    @Command
    void onEliminaFamiglia() {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Elimina_Famiglia")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event ev) {
                        if (Messagebox.ON_YES.equals(ev.getName())) {
                            eliminaFamiglia()
                            popolaListaDichiaranti()
                            selectedDichiarante = null
                            refreshUi()
                        }
                        if (Messagebox.ON_NO.equals(ev.getName())) {
                            log.info("Si è scelto di non eliminare il soggetto")
                        }
                    }
                })
    }

    @Command
    void popolaListaDichiaranti() {
        listaDichiaranti = soggetti.findAll { !it.flagAnnullamento && it.flagSoggetto && it.numeroOrdine != null } + soggettoDummy
        refreshUi()
    }

    @Command
    void onChangeNumeroOrdine(@BindingParam("sogg") ISoggettoPratica soggetto) {
        if(soggetti.count{ it.numeroOrdine == soggetto.numeroOrdine} > 1) {
            soggetto.numeroOrdine = null
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Numero_Ordine_Presente")), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }

        popolaListaDichiaranti()
        refreshUi()
    }

    @Command
    void onSelectDichiarante() {
        if (selectedDichiarante && selectedDichiarante.numeroOrdine != 9) {
            pratica.cognomeDichiarante = selectedDichiarante.anagrafe.cognome
            pratica.nomeDichiarante = selectedDichiarante.anagrafe.nome
            pratica.matricolaDichiarante = selectedDichiarante.anagrafe.matricola
            pratica.codFamigliaDichiarante = selectedDichiarante.anagrafe.famiglia?.codice
            pratica.famigliaDichiarante = selectedDichiarante.anagrafe.famiglia
        } else {
            pratica.cognomeDichiarante = null
            pratica.nomeDichiarante = null
            pratica.matricolaDichiarante = null
            pratica.codFamigliaDichiarante = null
            pratica.famigliaDichiarante = null
        }
        refreshUi()
    }

    @Command
    void checkSoggetti() {
        if (soggetti.size() == 0) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Inserire_Soggetto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command
    void onSalvaPratica() {
        //Salvataggio preliminare prima del compeltamento della pratica
        //per ottenere un id associato
        checkAndSalvaPratica()
    }

    protected void checkAndSalvaPratica(boolean mostraMessagebox = true) {
        checkDatiObbligatoriPratica()
        salva(mostraMessagebox)
    }

    @Command
    void onSalva() { //Salvataggio finale
        checkDatiObbligatoriPratica()
        checkDatiObbligatoriSoggettiEDichiarante()
        if (soggetti.every { it.flagAnnullamento }) {
            Messagebox.show("${getEtichetta(Etichette.getEtichetta('Tutti_Soggetti_Annullati'))}${getEtichetta(Etichette.getEtichetta('Annullamento_Pratica'))}", msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                annullaPratica(false, true)
                                salva()
                                refreshComunicazioniEAdempimenti()
                                onChiudi()
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                log.info("Si è scelto di non annullare la Pratica")
                                salva()
                                refreshUi()
                            }
                        }
                    })
        } else {
            salva()
            refreshComunicazioniEAdempimenti()
            caricaDettaglio(pratica.id)
            refreshUi()
        }
    }

    @Command
    void onSalvaPerfeziona() {
        checkDatiObbligatoriPratica()
        checkDatiObbligatoriSoggettiEDichiarante()
        checkCodFamiglia()
        if (soggetti.every { it.flagAnnullamento }) {
            Messagebox.show("${getEtichetta(Etichette.getEtichetta('Tutti_Soggetti_Annullati'))}${getEtichetta(Etichette.getEtichetta('Annullamento_Pratica'))}", msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                annullaPratica(false, true)
                                salva()
                                refreshComunicazioniEAdempimenti()
                                onChiudi()
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                log.info("Si è scelto di non annullare la Pratica")
                                salva()
                                refreshUi()
                            }
                        }
                    })
        } else if (soggetti.any { it.flagAnnullamento }) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Annullamento_Soggetti")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event ev) {
                            if (Messagebox.ON_YES.equals(ev.getName())) {
                                perfezionaPratica(true)
                                salva(false)
                                refreshComunicazioniEAdempimenti()
                                popUpAperturaComunicazioniANPR()
                            }
                            if (Messagebox.ON_NO.equals(ev.getName())) {
                                log.info("Si è scelto di procedere")
                                salva()
                                refreshUi()
                            }
                        }
                    })
        } else {
            perfezionaPratica(true)
            salva(false)
            refreshComunicazioniEAdempimenti()
            popUpAperturaComunicazioniANPR()
        }
    }

    private void popUpAperturaComunicazioniANPR() {
        caricaDettaglio(pratica.id)
        if(pratica.flagPerfezionamento) {
            readOnly = true
        }
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Accedere_Comunicazioni_ANPR")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event ev) {
                        if (Messagebox.ON_YES.equals(ev.getName())) {
                            Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/anprComunicazioni.zul", self.parent, [id: pratica.id, soggetti: soggetti, dichiarazione: dichiarazione])
                            self.setVisible(false)
                            w.addEventListener(Events.ON_CLOSE, { event ->
                                caricaDettaglio(pratica.id)
                                refreshUi()
                                self.setVisible(true)
                            })
                            w.doEmbedded()
                        }
                        if (Messagebox.ON_NO.equals(ev.getName())) {
                            refreshUi()
                        }
                    }
                })
    }

    @Command
    void onSalvaAnnulla() {
        checkDatiObbligatoriPratica()
        checkDatiObbligatoriSoggettiEDichiarante()
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Annullamento_Pratica")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event ev) {
                        if (Messagebox.ON_YES.equals(ev.getName())) {
                            annullaPratica(true, true)
                            salva()
                            refreshComunicazioniEAdempimenti()
                            onChiudi()
                        }
                        if (Messagebox.ON_NO.equals(ev.getName())) {
                            log.info("Si è scelto di non annullare la Pratica")
                            salva()
                            refreshUi()
                        }
                    }
                })
    }

    protected void checkDatiObbligatoriPratica() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        String sezione = "Informazioni Pratica"
        if (pratica.codiceVariazione == null &&
                pratica.tipoPratica == ETipoPratica.ISC && pratica.archivioAnagrafe == ETipoAnagrafe.RESIDENTI) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        if (pratica.iniziativa == null || pratica.anno == null ||
                pratica.data == null || pratica.dataDecorrenza == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        sezione = "Informazioni Pratica - Numero pratica"
        if (numeraPratica == ETipoSiNo.SI && abilitaNumero) {
            if (pratica.numero == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            if (pratica.id == null) { //Controllo solo al primo ciclo di salvataggio
                String msgErrore = gsdService.controllaNumeroPratica(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, pratica.getTableName())
                if (msgErrore != null) {
                    throw new De4gsdzkRuntimeException(msgErrore)
                }
            }
        }

        checkDatiAggiuntiviPratica()

        if (pratica.occupazioneImmobile.flagLegittima) {
            sezione = "Occupazione Immobile"
            if (pratica.occupazioneImmobile.flagProprietario && pratica.occupazioneImmobile.flagLocazione &&
                    pratica.occupazioneImmobile.flagLocazioneErp && pratica.occupazioneImmobile.flagComodato &&
                    pratica.occupazioneImmobile.flagUsufrutto && pratica.occupazioneImmobile.flagTitolo) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }


    }

    protected void checkDatiObbligatoriSoggettiEDichiarante() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }

        checkSoggettiPratica()

        if (hasModelloApr4()) {
            checkDatiObbligatoriModelloAPR4()
        }

        String sezione = "Dichiarante"
        if (selectedDichiarante == null && soggetti.any { !it.flagAnnullamento }) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        if (selectedDichiarante?.numeroOrdine == 9) {
            if (pratica.nomeDichiarante == null || pratica.cognomeDichiarante == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }
    }

    private boolean hasModelloApr4() {
        return pratica.archivioAnagrafe == ETipoAnagrafe.RESIDENTI &&
                (pratica.tipoPratica == ETipoPratica.ISC || pratica.tipoPratica == ETipoPratica.CANC)
    }

    protected void checkDatiObbligatoriModelloAPR4() {

        String sezione = "Modello APR/4"
        if ((dichiarazione as IDichiarazioneRes).conteggio == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }


        if (dichiarazione.codFamigliaProv != null) {
            sezione = "Modello AIRE/01 Cancellazione"
            if ((pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoProtocolloAire == null ||
                    pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.protocolloAire == null)) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            if (pratica.dichiarazioneCancellazioneAir.id == null) { //Controllo solo al primo ciclo di salvataggio
                String msgErrore = gsdService.controllaNumeroPratica(archivioAnagrafe, tipoPratica,
                        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoProtocolloAire,
                        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.protocolloAire,
                        pratica.dichiarazioneCancellazioneAir.getTableName())
                if (msgErrore != null) {
                    throw new De4gsdzkRuntimeException(msgErrore)
                }
            }
        }
    }

    private void checkCodFamiglia() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        if (dichiarazione.flagAggregazione && dichiarazione.famigliaDest == null && tipoPratica != ETipoPratica.RET) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Effettuare_Ricerca_Famiglia")))
        }
    }

    protected void salva(boolean mostraMessagebox = true) {
        salvaPratica()
        salvaDichiarazione()
        if (mostraMessagebox) {
            Messagebox.show("Salvataggio effettuato con successo", "Pratica", Messagebox.OK, Messagebox.INFORMATION)
        }
        refreshUi()
    }

    protected void annullaPratica(Boolean impostaFlagSoggetti, Boolean aggiungiAvanzamento) {
        //Prima di annullare la pratica è necessario effettuare un salvataggio preliminare
        //in modo tale che i dati siano allineati anche nel DB per le function invocate
        salva(false)

        if (impostaFlagSoggetti) {
            for (ISoggettoPratica s : soggetti) {
                if (s.flagSoggetto) {
                    s.flagAnnullamento = true
                }

            }
        }
        pratica.flagAnnullamento = true
        if (aggiungiAvanzamento) {
            gsdService.inserisciAvanzamento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, eventoAnnullamento.codEp)
        }
        annullaDichiarazione()
        annullaSoggetti()

        if (pratica.flagPerfezionamentoPreliminare) {
            gsdService.inserisciEvento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, true)
            gsdService.inserisciMovimento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, true, null, null, null)
        }
    }


    private void salvaPratica() {

        //Pratica
        if (pratica.id == null) {
            pratica.id = gsdService.getIdFromSequence(pratica, pratica.getTableName())
        }
        if (pratica.numero == null) {
            pratica.numero = gsdService.getNumeroPratica(pratica.archivioAnagrafe, pratica.anno, pratica.tipoPratica, numeraPratica)
        }

        if (pratica.occupazioneImmobile.flagLegittima) {
            if (pratica.occupazioneImmobile.id == null) {
                pratica.occupazioneImmobile.id = gsdService.getIdFromSequence(pratica.occupazioneImmobile, pratica.occupazioneImmobile.getTableName())
            }
            pratica.occupazioneImmobile.pratica = pratica
            pratica.occupazioneImmobile.idPratica = pratica.idPratica
            pratica.occupazioneImmobile.numeroPratica = pratica.numero
            pratica.occupazioneImmobile.archivioAnagrafe = archivioAnagrafe
            pratica.occupazioneImmobile.tipoPratica = tipoPratica
            pratica.occupazioneImmobile.annoPratica = pratica.anno
        } else {
            pratica.occupazioneImmobile.pratica = null
            pratica.occupazioneImmobile.idPratica = null
            pratica.occupazioneImmobile = null
        }

        pratica.codiceIniziativa = pratica.iniziativa?.codice

        if (dichiarazione.codFamigliaProv != null && pratica.dichiarazioneCancellazioneAir != null) {
            //Salvataggio modello AIRE cancellazione
            if (pratica.dichiarazioneCancellazioneAir.id == null) {
                pratica.dichiarazioneCancellazioneAir.id = gsdService.getIdFromSequence(pratica.dichiarazioneCancellazioneAir)
            }
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.codiceMotivo = pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.motivoCancellazione?.codice
        } else {
            pratica.dichiarazioneCancellazioneAir = null
        }

        if (pratica.cognomeDichiarante && pratica.nomeDichiarante) {
            pratica.cognomeNomeDichiarante = pratica.cognomeDichiarante.concat("/").concat(pratica.nomeDichiarante)
        }

        pratica = anaPraticaService.saveOrUpdate(pratica)

    }

    protected void perfezionaPratica(Boolean aggiungiAvanzamento) {
        //Prima di perfezionare la pratica è necessario effettuare un salvataggio preliminare
        //in modo tale che i dati siano allineati anche nel DB per le function invocate
        salva(false)

        if (dichiarazione.codFamigliaProv != null && !(selectedVariazione.codiceMovimento == 1 && selectedVariazione.evento.id == 4)) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Selezionare_Variazione_Corretta")))
            return
        }

        // Flag perfezionamento per pratica
        if (selectedVariazione.flagPreliminare) {
            if (pratica.flagPerfezionamentoPreliminare) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Impossibile_Perfezionare_Iscrizone_Preliminare")))
                return
            }
        } else {
            pratica.flagPerfezionamento = true
        }

        //Inserimento  avanzamento di perfezionamento
        if (aggiungiAvanzamento) {
            gsdService.inserisciAvanzamento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, eventoPerfezionamento.codEp)
        }

        //Eventuale creazione della famiglia
        AnaFamiglia famiglia = null
        if (!dichiarazione.flagAggregazione) {
            if (pratica.flagPerfezionamento && dichiarazione.famigliaDest) {
                famiglia = updateFamiglia(dichiarazione.famigliaDest.id)
            } else { //Perfezionamento preliminare
                famiglia = inserisciFamiglia()
            }

        }

        //Soggetti
        perfezionaSoggetti(anaStatoService.findById(selectedVariazione.evento.id), selectedVariazione.codiceMovimento, famiglia)
        //Annullo eventuali soggetto con il flag settato
        annullaSoggetti()

        //Modello APR4
        if(hasModelloApr4()) {
            dichiarazione.dataDefinizione = DataUtils.getDataCorrente()
        }

        //Modello AIRE
        if (dichiarazione.codFamigliaProv != null && pratica?.dichiarazioneCancellazioneAir) {
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.dataDefinizione = DataUtils.getDataCorrente()
        }

        //Evento
        gsdService.inserisciEvento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, false)

        //Movimento
        gsdService.inserisciMovimento(archivioAnagrafe, tipoPratica, pratica.anno, pratica.numero, false,
                famiglia ? famiglia.codice : dichiarazione?.codFamigliaDest,
                famiglia ? famiglia.id : dichiarazione?.famigliaDest?.id,
                famiglia ? famiglia.intestatario : dichiarazione?.famigliaDest?.intestatario)
    }

    void refreshComunicazioniEAdempimenti() {
        anaComunicazionePraticaService.sendAllDefaultComunicazioni(pratica.archivioAnagrafe, pratica.tipoPratica, pratica.anno, pratica.numero, false, null)
        anaComunicazionePraticaService.sendAllDefaultComunicazioni(pratica.archivioAnagrafe, pratica.tipoPratica, pratica.anno, pratica.numero, true, null)
    }

    protected void salvaFamiglia(AnaFamiglia famiglia) {
        anaFamigliaService.saveOrUpdate(famiglia)
    }

    @Command
    void onOpenCaratteriSpeciali(@BindingParam("soggetto") ISoggettoPratica soggetto) {
        Window w = (Window) Executions.createComponents("/restrict/gestioneCaratteriSpeciali.zul", self, [gruppo: EGruppo.ANA, dettaglio: soggetto.anagrafe])
        w.doModal()
    }

    @Command
    void onSelectRapportoParentela(@BindingParam("soggetto") ISoggettoPratica sogg, @BindingParam("rapporto") String rapporto) {
        selezionaRapportoParentela(sogg, rapporto, true)
    }

    @Command
    void onCheckFlagSoggetto(@BindingParam("soggetto") ISoggettoPratica sogg) {
        if (sogg.flagSoggetto) {
            sogg.rapportoParentelaPrecedente = null
            sogg.codRpPrecedente = null
            sogg.sequenzaRpPrecedente = null
        } else {
            sogg.flagAnnullamento = false
            sogg.rapportoParentelaNuovo = null
            sogg.nuovoCodRp = null
            sogg.nuovaSequenzaRp = null
            if (hasModelloApr4()) {
                (sogg as ISoggettoPraticaIscrizione).rapportoParentela = null
                (sogg as ISoggettoPraticaIscrizione).istRp = null
            }
            sogg.rapportoParentelaPrecedente = sogg.anagrafe.rapportoParentela
            sogg.codRpPrecedente = sogg.anagrafe.rapportoParentela.codiceRapportoParentela
            sogg.sequenzaRpPrecedente = sogg.anagrafe.rapportoParentela.sequenza
        }
        popolaListaDichiaranti()
        impostaRapportoParentelaDefault()
        refreshUi()
    }

    @Command
    void onOpenAvanzamentoPratica() {
        if (readOnly) {
            openAvanzamentoPratica()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES.equals(e.getName())) {
                                openAvanzamentoPratica()
                            }
                        }
                    }
            )
        }

    }

    void openAvanzamentoPratica(Integer idAvanzamento = null) {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneAvanzamentoPratica.zul", self.parent, [id: pratica.id, idAvanzamento: idAvanzamento])
        self.setVisible(false)
        w.addEventListener(Events.ON_CLOSE, { event ->
            caricaDettaglio(pratica.id)
            if (event?.data?.annulla && !readOnly) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Annullamento_Pratica")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener() {
                            void onEvent(Event ev) {
                                if (Messagebox.ON_YES.equals(ev.getName())) {
                                    annullaPratica(true, false)
                                    salva()
                                    refreshComunicazioniEAdempimenti()
                                    onChiudi()
                                }
                                if (Messagebox.ON_NO.equals(ev.getName())) {
                                    log.info("Si è scelto di non annullare la pratica")
                                    refreshUi()
                                }
                            }
                        })

            } else if (event?.data?.perfeziona && !readOnly) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Perfezionamento_Pratica")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                        new org.zkoss.zk.ui.event.EventListener() {
                            void onEvent(Event ev) {
                                if (Messagebox.ON_YES.equals(ev.getName())) {
                                    perfezionaPratica(false)
                                    salva()
                                    refreshComunicazioniEAdempimenti()
                                    onChiudi()
                                }
                                if (Messagebox.ON_NO.equals(ev.getName())) {
                                    log.info("Si è scelto di non perfezionare la pratica")
                                    refreshUi()
                                }
                            }
                        })
            }
            self.setVisible(true)
        })
        w.doEmbedded()
    }

    @Command
    void onOpenAllegati() {
        if (readOnly) {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneAllegatiPratica.zul", self.parent, [id: pratica.id])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                caricaDettaglio(pratica.id)
                refreshUi()
                self.setVisible(true)
            })
            w.doEmbedded()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES.equals(e.getName())) {
                                Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneAllegatiPratica.zul", self.parent, [id: pratica.id])
                                self.setVisible(false)
                                w.addEventListener(Events.ON_CLOSE, { event ->
                                    caricaDettaglio(pratica.id)
                                    refreshUi()
                                    self.setVisible(true)
                                })
                                w.doEmbedded()
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onOpenComunicazioniAnpr() {
        if (readOnly) {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/anprComunicazioni.zul", self.parent, [id: pratica.id, soggetti: soggetti, dichiarazione: dichiarazione])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                caricaDettaglio(pratica.id)
                refreshUi()
                self.setVisible(true)
            })
            w.doEmbedded()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES.equals(e.getName())) {
                                Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/anprComunicazioni.zul", self.parent, [id: pratica.id, soggetti: soggetti, dichiarazione: dichiarazione])
                                self.setVisible(false)
                                w.addEventListener(Events.ON_CLOSE, { event ->
                                    caricaDettaglio(pratica.id)
                                    refreshUi()
                                    self.setVisible(true)
                                })
                                w.doEmbedded()
                            }
                        }
                    }
            )
        }
    }

    @Command
    void onNumeraProtocolloModelloAireCancellazione() {
        if ((pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.protocolloAire == null)) {
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoProtocolloAire = pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoProtocolloAire ?: DataUtils.getAnnoCorrente()
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.protocolloAire = gsdService.getNumeroPratica(ETipoAnagrafe.AIRE, pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoProtocolloAire, ETipoPratica.CANC, ETipoSiNo.SI)
            refreshUi()
        }
    }

    @Command
    void onToggleTuttiSoggetti() {
        // Copia difensiva: onCheckFlagSoggetto() richiama il getter "soggetti", che riordina
        // in-place la collezione Hibernate sottostante, invalidando l'iteratore di questo each
        new ArrayList<>(soggetti).each {
            soggetto ->
                soggetto.flagSoggetto = tuttiSoggettiSelezionati
                onCheckFlagSoggetto(soggetto)
        }
        popolaListaDichiaranti()
        impostaRapportoParentelaDefault()
        refreshUi()
    }

    @Command
    void onOpenComunicazioni(@BindingParam("priorita") Boolean priorita) {
        if (readOnly) {
            Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/comunicazioni/comunicazioniPraticaLista.zul", self.parent, [id: pratica.id, priorita: priorita])
            self.setVisible(false)
            w.addEventListener(Events.ON_CLOSE, { event ->
                caricaDettaglio(pratica.id)
                refreshUi()
                self.setVisible(true)
            })
            w.doEmbedded()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Modifiche_In_Sospeso")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_YES.equals(e.getName())) {
                                Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/comunicazioni/comunicazioniPraticaLista.zul", self.parent, [id: pratica.id, priorita: priorita])
                                self.setVisible(false)
                                w.addEventListener(Events.ON_CLOSE, { event ->
                                    caricaDettaglio(pratica.id)
                                    refreshUi()
                                    self.setVisible(true)
                                })
                                w.doEmbedded()
                            }
                        }
                    }
            )
        }
    }

    void aggiungiSoggetto(ISoggettoPratica soggetto) {
        if (getSoggetti().count { it.anagrafe.matricola == soggetto.anagrafe.matricola } == 0) {
            salvaDichiarazione()
            ISoggettoPratica sogg = getNewSoggetto()
            sogg.anagrafe = soggetto.anagrafe
            sogg.dichiarazione = getDichiarazione()
            sogg.flagSoggetto = true
            sogg.numeroOrdine = getSoggetti().size() + 1
            if (hasModelloApr4()) {
                (sogg as ISoggettoPraticaIscrizione).sesso = (soggetto as ISoggettoPraticaIscrizione).sesso
                (sogg as ISoggettoPraticaIscrizione).codiceTitoloStudioIstat = (soggetto as ISoggettoPraticaIscrizione).titoloStudioIstat?.codiceIstat
                (sogg as ISoggettoPraticaIscrizione).codiceProfessioneIstat = (soggetto as ISoggettoPraticaIscrizione).professioneIstat?.codiceIstat
                (sogg as ISoggettoPraticaIscrizione).rapportoParentela = (soggetto as ISoggettoPraticaIscrizione).rapportoParentela
                (sogg as ISoggettoPraticaIscrizione).istRp = (soggetto as ISoggettoPraticaIscrizione).rapportoParentela?.istRp
            }

            sogg.nuovoCodRp = soggetto.anagrafe.codRp
            sogg.nuovaSequenzaRp = soggetto.anagrafe.sequenzaParentela
            sogg.pratica = pratica
            sogg.idPratica = pratica.idPratica
            sogg.archivioAnagrafe = archivioAnagrafe
            sogg.tipoPratica = tipoPratica

            popolaCampiAggiuntiviSoggetto(sogg)

            salvaSoggetto(sogg)

            getSoggetti().add(sogg)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Soggetto_Presente")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void eliminaSoggetto(ISoggettoPratica sogg) {
        getSoggetti().remove(sogg)
        sogg.dichiarazione = null
    }

    void aggiornaSoggetto(ISoggettoPratica selectedSoggetto, ISoggettoPraticaIscrizione soggetto) {
        int index = getSoggetti().indexOf(selectedSoggetto)
        ISoggettoPratica sogg = getSoggetti().get(index)

        sogg.anagrafe = soggetto.anagrafe
        if(hasModelloApr4()) {
            (sogg as ISoggettoPraticaIscrizione).codiceTitoloStudioIstat = soggetto.titoloStudioIstat?.codiceIstat
            (sogg as ISoggettoPraticaIscrizione).codiceProfessioneIstat = soggetto.professioneIstat?.codiceIstat
            (sogg as ISoggettoPraticaIscrizione).rapportoParentela = soggetto.rapportoParentela
            (sogg as ISoggettoPraticaIscrizione).istRp = soggetto.rapportoParentela?.istRp
        }

        List<AnaRapportoParentela> list = sogg.anagrafe.sesso == ESesso.M ? rapportoParentelaMList : rapportoParentelaFList
        sogg.rapportoParentelaNuovo = list?.find {
            it.codiceRapportoParentela == sogg.anagrafe.codRp
        }
        // Setta i campi nuovoCodRp, nuovaSequenzaRp, rapportoParentela, istRp
        if (sogg.rapportoParentelaNuovo) {
            selezionaRapportoParentela(sogg, 'N', false)
        }

        salvaSoggetto(sogg as ISoggettoPratica)

        getSoggetti().set(index, sogg as ISoggettoPratica)

    }

    protected void popolaCampiAggiuntiviSoggetto(ISoggettoPratica soggetto) {
        // Implementazione vuota di default
        // Implementata in modo specifico per ogni tipologia di pratica
    }

    protected void riempiComuneProvenienza(ETipoComuneAtto tipoComune, ArcComuneBaseDomain c) {
        // Implementazione vuota di default
        // Le variazioni non gestiscono il comune provenienza
    }

    /**
     * Imposta automaticamente i rapporti parentela quando necessario.
     *
     * Esegue SOLO se tipoFamigliaOriginario == tipoFamiglia della dichiarazione.
     *
     * - Rapporto parentela nuovo di default = quello corrente se tutti i soggetti sono selezionati e la variazione NON è un'aggregazione
     * - Rapporto parentela precedente di default = quello corrente per i soggetti non selezionati se l'intestatario scheda non è selezionato
     */
    protected impostaRapportoParentelaDefault() {
        if(dichiarazione.codFamigliaProv != null) {
            if (isRapportoParentelaNuovoNonModificabile()) {
                for (ISoggettoPratica s : soggetti) {
                    if (s.flagSoggetto) {
                        // Trova il rapporto parentela corrispondente nella lista appropriata
                        List<AnaRapportoParentela> list = s.anagrafe.sesso == ESesso.M ? rapportoParentelaMList : rapportoParentelaFList
                        s.rapportoParentelaNuovo = list?.find {
                            it.codiceRapportoParentela == s.anagrafe.codRp
                        }
                        // Setta i campi nuovoCodRp, nuovaSequenzaRp, rapportoParentela, istRp
                        if (s.rapportoParentelaNuovo) {
                            selezionaRapportoParentela(s, 'N', true)
                        }
                    }
                }
            } else if (isRapportoParentelaPrecedenteNonModificabile()) {
                for (ISoggettoPratica s : soggetti) {
                    if (!s.flagSoggetto) {
                        // Trova il rapporto parentela corrispondente nella lista appropriata
                        List<AnaRapportoParentela> list = s.anagrafe.sesso == ESesso.M ? rapportoParentelaMPrecList : rapportoParentelaFPrecList
                        s.rapportoParentelaPrecedente = list?.find {
                            it.codiceRapportoParentela == s.anagrafe.codRp
                        }
                        // Setta i campi codRpPrecedente, sequenzaRpPrecedente
                        if (s.rapportoParentelaPrecedente) {
                            selezionaRapportoParentela(s, 'P', true)
                        }
                    }
                }
            }
        }
    }

    @Command
    void onModificaEvento(@BindingParam("operazione") String operazione) {
        Boolean ripristino = false
        if('E'.equals(operazione)) {
            ripristino = archivioAnagrafe == ETipoAnagrafe.RESIDENTI &&
                         tipoPratica == ETipoPratica.CANC &&
                         dichiarazione.codFamigliaDest == null &&
                         'M'.equals(selectedVariazione.tipoEventoIstat)

        }
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/modificaEvento.zul", self, [id: pratica.id, operazione: operazione, ripristino: ripristino])
        w.addEventListener(Events.ON_CLOSE, { event ->
            caricaDettaglio(pratica.id)
            readOnly = (pratica.flagPerfezionamento || pratica.flagAnnullamento)
            refreshUi()
        })
        w.doModal()
    }

    abstract ISoggettoPratica getNewSoggetto()

    abstract void checkDatiAggiuntiviPratica()

    abstract void checkSoggettiPratica()

    abstract void salvaSoggetto(ISoggettoPratica soggetto)

    abstract void salvaDichiarazione()

    abstract void annullaDichiarazione()

    abstract void inserisciSoggettiFamiglia(AnaFamiglia famiglia, Boolean interoNucleo)

    abstract AnaFamiglia inserisciFamiglia()

    abstract AnaFamiglia updateFamiglia(String id)

    abstract void perfezionaSoggetti(AnaStato stato, Integer fascia, AnaFamiglia famiglia)

    abstract void annullaSoggetti()

    abstract void popolaDefault()

    abstract void popolaRapportoParentelaLists()

    abstract void selezionaRapportoParentela(ISoggettoPratica sogg, String rapporto, boolean mostraMessaggio)

    abstract IDichiarazionePratica getDichiarazione()

    abstract List<ISoggettoPratica> getSoggetti()

    abstract ISoggettoPratica getSoggettoDummy()

    abstract List<ISoggettoPratica> getSoggettiNonOrdinati()

    abstract EFascia getFascia()

    abstract ETipoAnagrafe getArchivioAnagrafe()

    abstract ETipoPratica getTipoPratica()

    abstract void eliminaFamiglia()

    abstract void filtraVariazioni()

    abstract boolean isRettificaIndividuo()

    abstract boolean isRettificaFamiglia()

    abstract void copiaDatiIndirizzo(IndirizzoCivico to, IndirizzoCivico from)
}
