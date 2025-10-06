package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.springframework.dao.EmptyResultDataAccessException
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel
import restrict.statocivile.IRowMotivoRichiesta

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class NascitaDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel implements IRowMotivoRichiesta {
    private static final String MOTIVO_RICHIESTA_FIELD = 'motivoNascita'

    CivNascita dettaglio

    List<ETipoFiliazione> listaFiliazione
    List<Map> listaBoolean
    final List<EStatoNascita> listaStato = Arrays.asList(EStatoNascita.values())
    List<Integer> listaCardinali = []
    final List<ETipoAddettoDichiarazione> listaAddettoDichiarazione = Arrays.asList(ETipoAddettoDichiarazione.values())
    List<Map> listaDichiarante = []
    List<Map> listaComparente = []
    List<Map> listaFirmatario = []
    List<Map> listaDichiaranteRic = []
    List<Map> listaComparenteRic = []
    List<Map> listaFirmatarioRic = []

    final List<EQualifica> listaQualifica = [null] + Arrays.asList(EQualifica.values())
    List<ETipoConsenso> listaTipoConsenso = []
    final List<ETipoConsensoRiconoscimento> listaTipoConsensoRiconoscimento = [null] + Arrays.asList(ETipoConsensoRiconoscimento.values())
    final List<ETipoRiconoscimentoPrenatale> listaTipoRiconoscimento = [null] + Arrays.asList(ETipoRiconoscimentoPrenatale.values())
    final List<ETipoAssenso> listaTipoAssenso = [null] + Arrays.asList(ETipoAssenso.values())
    final List<ETipoSceltaCognome> listaSceltaCognome = [null] + [ETipoSceltaCognome.MP, ETipoSceltaCognome.AG, ETipoSceltaCognome.PC, ETipoSceltaCognome.SC]
    final List<ETipoMancatoConsensoMadre> listaTipoMancatoConsensoMadre = [null] + Arrays.asList(ETipoMancatoConsensoMadre.values())

    List<Map> listaRichiedenteGen = []
    List<Map> listaRichiedenteTrascr = []

    final List<ETipoMargineLaterale> listaMargineLaterale = Arrays.asList(ETipoMargineLaterale.values())

    List<ETipoAccertamentoNascita> listaTipoAccertamento = []

    List<CivCategoriaTipoRichiesta> listaTipoRichiesta

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivNascitaService civNascitaService

    @WireVariable
    private CivCategoriaTipoRichiestaService civCategoriaTipoRichiestaService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.NAS)

        List<Map> eList = []
        eList.addAll(CivNascita.etichetteDomain)
        eList.addAll([Etichette.Richiedente, Etichette.Luogo_Nascita, Etichette.Comune, Etichette.Data_Redazione_Atto_Originale, Etichette.Numero_gemello,
                      Etichette.di, Etichette.Dati_Dichiarante, Etichette.Consenso, Etichette.Riconoscimento_pre_natale,
                      Etichette.Estremi_Centro_Nascita, Etichette.Dati_Richiesta, Etichette.Certificato_sanitario, Etichette.Estremi_Atto_Riconoscimento_Unico,
                      Etichette.Estremi_Atto_Riconoscimento_Paterno, Etichette.Estremi_Atto_Assenso, Etichette.Dati_procura,
                      Etichette.Atto_dichiarazione_anno, Etichette.Data_Richiesta, Etichette.Scelta_cambio_cognome,
                      Etichette.Addetto_Dichiarazione, Etichette.Data_Dichiarazione, Etichette.Altri_Dati, Etichette.Tipo_Accertamento,
                      Etichette.Tipo_consenso_madre, Etichette.Tipo_consenso_padre, Etichette.Tipo_dichiarazione_assenso,
                      Etichette.Generalita_sanitario, Etichette.Generalita_procuratore_padre, Etichette.Generalita_procuratore_madre,
                      Etichette.Dati_della_trascrizione, Etichette.Nuovo_nome, Etichette.Nuovo_cognome, Etichette.Motivo_richiesta])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Filiazione, Etichette.Presentazione, Etichette.Circostanze_Particolari])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_FILIAZIONE, Etichette.SEZIONE_GENITORI, Etichette.SEZIONE_DATI_NASCITA,
                      Etichette.SEZIONE_ATTO_ORIGINALE, Etichette.SEZIONE_REDAZIONE, Etichette.SEZIONE_COMPOSIZIONE])

        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_parto_plurimo, EtichetteMessaggi.Errore_stato_civile_genitori, EtichetteMessaggi.Errore_data_futura,
                      EtichetteMessaggi.Errore_data_nascita_vs_1A, EtichetteMessaggi.Errore_data_nascita_vs_1B,
                      EtichetteMessaggi.Warn_Inserimento_In_Anagrafe])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriNascita()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette tipo filiazione
        eList.addAll((Arrays.asList(ETipoFiliazione.values()))*.etichettaDesc)
        // Aggiungo etichette tipo consenso
        eList.addAll((Arrays.asList(ETipoConsenso.values()))*.etichettaDesc)
        // Aggiungo etichette tipo assenso
        eList.addAll((Arrays.asList(ETipoAssenso.values()))*.etichettaDesc)
        // Aggiungo etichette tipo consenso riconoscimento
        eList.addAll((Arrays.asList(ETipoConsensoRiconoscimento.values()))*.etichettaDesc)
        // Aggiungo etichette tipo riconoscimento
        eList.addAll((Arrays.asList(ETipoRiconoscimentoPrenatale.values()))*.etichettaDesc)
        // Aggiungo etichette tipo scelta cognome
        eList.addAll((Arrays.asList(ETipoSceltaCognome.values()))*.etichettaDesc)
        // Aggiungo etichette mancato consenso madre
        eList.addAll((Arrays.asList(ETipoMancatoConsensoMadre.values()))*.etichettaDesc)

        // Aggiungo etichette sesso
        eList.add(Etichette.Non_conosciuto)
        eList.addAll(Arrays.asList(ESesso.values())*.etichettaDesc)

        // Aggiungo etichette stato nascita
        eList.addAll(Arrays.asList(EStatoNascita.values())*.etichettaDesc)

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiaranteNascita.values()))*.etichettaDesc)
        // Aggiungo etichette soggetti collegati
        eList.addAll(CivSoggettoCollegato.etichetteDomain)
        // Aggiungo etichette qualifica personale sanitario
        eList.addAll((Arrays.asList(EQualifica.values()))*.etichettaDesc)
        // Aggiungo etichette tipo addetto alla dichiarazione
        eList.addAll((Arrays.asList(ETipoAddettoDichiarazione.values()))*.etichettaDesc)
        // Aggiungo etichette margine laterale
        eList.addAll(Arrays.asList(ETipoMargineLaterale.values())*.etichettaDesc)
        // Aggiungo etichette tipo accertamento
        eList.addAll((Arrays.asList(ETipoAccertamentoNascita.values()))*.etichettaDesc)
        //Aggiongo etichetta figlio di ignoti
        eList.add(Etichette.Figlio_di_ingoti)

        doInitAllAtti(eList)

        msgTitle = getEtichetta(Etichette.Atto_Nascita)
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.NAS)

        listaFiliazione = [ETipoFiliazione.L, ETipoFiliazione.C]

        listaTipoAccertamento = Arrays.asList(ETipoAccertamentoNascita.values())

        listaBoolean = [[label: getEtichettaEnum(ETipoSiNo.SI), value: Boolean.TRUE], [label:getEtichettaEnum(ETipoSiNo.NO), value: Boolean.FALSE]]

        listaDichiarante = []
        listaComparente = []
        listaFirmatario = []

        listaDichiaranteRic = []
        listaComparenteRic = []
        listaFirmatarioRic = []

        listaRichiedenteGen = [null] + [getDCFItem(ETipoDichiaranteNascita.IN),
                                        getDCFItem(ETipoDichiaranteNascita.PD),
                                        getDCFItem(ETipoDichiaranteNascita.MD),
                                        getDCFItem(ETipoDichiaranteNascita.AM),
                                        getDCFItem(ETipoDichiaranteNascita.AL)]

        listaRichiedenteTrascr = [null] + [getDCFItem(ETipoDichiaranteNascita.IN),
                                           getDCFItem(ETipoDichiaranteNascita.PD),
                                           getDCFItem(ETipoDichiaranteNascita.MD),
                                           getDCFItem(ETipoDichiaranteNascita.AL)]

        listaTipoConsenso = []

        listaCardinali = [new Integer(1), new Integer(2), new Integer(3), new Integer(4), new Integer(5), new Integer(6)]

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    protected void caricaListaDichiarante(){
        // refs #67749
        if (dettaglio.isRiconoscimentoPrenatale()){
            // Prima dell'integrazione con ANSC la lista valori comprendeva la voce 'EN'
            // che invece non è prevista dai cdu di SOGEI --> per retrocompatibilità
            // ne consento la visualizzazione solo per gli atti pregressi in cui sia stata
            // espressamente scelta dall'USC.
            if (datiProvenienza?.tipoDichiarante == ETipoDichiaranteNascita.EN.name()){
                listaDichiaranteRic = [getDCFItem(ETipoDichiaranteNascita.PD),
                                       getDCFItem(ETipoDichiaranteNascita.MD),
                                       getDCFItem(ETipoDichiaranteNascita.EN)]
            } else {
                listaDichiaranteRic = [getDCFItem(ETipoDichiaranteNascita.PD),
                                       getDCFItem(ETipoDichiaranteNascita.MD)]
            }
        } else if (dettaglio.isRiconoscimentoPostNascita()){
            listaDichiaranteRic = [getDCFItem(ETipoDichiaranteNascita.PD),
                                   getDCFItem(ETipoDichiaranteNascita.MD),
                                   getDCFItem(ETipoDichiaranteNascita.EN),
                                   getDCFItem(ETipoDichiaranteNascita.AL)]
            // refs #67308
        } else if (dettaglio.isCentroNascita()){
            listaDichiarante = [getDCFItem(ETipoDichiaranteNascita.PD),
                                getDCFItem(ETipoDichiaranteNascita.MD),
                                getDCFItem(ETipoDichiaranteNascita.PDMD),
                                getDCFItem(ETipoDichiaranteNascita.PP),
                                getDCFItem(ETipoDichiaranteNascita.PM),
                                getDCFItem(ETipoDichiaranteNascita.OS),
                                getDCFItem(ETipoDichiaranteNascita.AL)]
        } else {
            listaDichiarante = [getDCFItem(ETipoDichiaranteNascita.PD),
                                getDCFItem(ETipoDichiaranteNascita.MD),
                                getDCFItem(ETipoDichiaranteNascita.PP),
                                getDCFItem(ETipoDichiaranteNascita.PM),
                                getDCFItem(ETipoDichiaranteNascita.OS),
                                getDCFItem(ETipoDichiaranteNascita.AL)]
        }
    }

    void caricaListaSesso(){
        // Gestisco la possibilità di non valorizzare il sesso del neonato (es riconoscimento pre-natale)
        listaSesso = []
        if (dettaglio.isRiconoscimentoPrenatale()|| dettaglio.isTestoLibero()){
            listaSesso = [null]
        }
        listaSesso.addAll(Arrays.asList(ESesso.values()))
    }

    void caricaListaFiliazione(){
        if (dettaglio.tipoFiliazione == ETipoFiliazione.S) {
            listaFiliazione = [ETipoFiliazione.L, ETipoFiliazione.C, ETipoFiliazione.S]
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE, FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_DICHIARANTE_FISSA,
                FormulaUtils.FORMULA_DICHIARANTE, FormulaUtils.FORMULA_FILIAZIONE_FISSA, FormulaUtils.FORMULA_FILIAZIONE,
                FormulaUtils.FORMULA_PRESENTAZIONE, FormulaUtils.FORMULA_PARTO_PLURIMO, FormulaUtils.FORMULA_STATO_NASCITA,
                FormulaUtils.FORMULA_CIRCOSTANZE_PARTICOLARI, FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDefault:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaNascita(chiave, tipoOperazione, dettaglio, datiProvenienza)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA_TRASCRIZIONE:
                    params.put("progressivo", FormulaUtils.getProgressivoTestataTrascrizione())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestataTrascrizione()
                    break
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("tipoAddettoDichiarazione", datiProvenienza?.tipoAddettoDichiarazione?.name())
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_DICHIARANTE_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoDichiaranteFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDichiaranteFisso()
                    break
                case FormulaUtils.FORMULA_DICHIARANTE:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione.name())
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                        params.put("tipoConsenso", dettaglio.tipoConsenso)
                        params.put("attoNotarile", datiProvenienza.attoNotarile)
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoDichiaranteGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDichiarante()
                    break
                case FormulaUtils.FORMULA_FILIAZIONE_FISSA:
                    params.put("progressivo", FormulaUtils.getProgressivoFiliazioneFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFiliazioneFisso()
                    break
                case FormulaUtils.FORMULA_FILIAZIONE:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione?.name())
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                        params.put("tipoConsenso", dettaglio.tipoConsenso)
                        params.put("attoNotarile", datiProvenienza.attoNotarile)
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoFiliazioneGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFiliazione()
                    break
                case FormulaUtils.FORMULA_PRESENTAZIONE:
                    richiamo = FormulaUtils.getRichiamoPresentazione()
                    break
                case FormulaUtils.FORMULA_PARTO_PLURIMO:
                    params.put("partoPlurimo", dettaglio.partoPlurimo)
                    params.put("numeroGemello", dettaglio.numeroGemello)
                    params.put("totaleGemelli", dettaglio.totaleGemelli)
                    params.put("progressivo", FormulaUtils.getProgressivoPartoPlurimo())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoPartoPlurimo()
                    break
                case FormulaUtils.FORMULA_STATO_NASCITA:
                    params.put("natoMorto", dettaglio.natoMorto)
                    params.put("progressivo", FormulaUtils.getProgressivoStatoNascita())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoStatoNascita()
                    break
                case FormulaUtils.FORMULA_CIRCOSTANZE_PARTICOLARI:
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoCircostanzeParticolariGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                    }
                    richiamo = FormulaUtils.getRichiamoCircostanzeParticolari()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione.name())
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    params.put("tipoFirmatario", datiProvenienza.tipoFirmatario)
                    params.put("comprensioneDichiarante", datiProvenienza.comprensioneDichiarante?.id)
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("tipoRichiesta", dettaglio.tipoRichiesta?.id)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione.name())
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("tipoFirmatario", datiProvenienza.tipoFirmatario)
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = statoCivileService.listFormuleNascita(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaNascita(chiave, tipoOperazione, dettaglio, datiProvenienza)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    // solo per CNA
                    params.put("tipoAddettoDichiarazione", datiProvenienza?.tipoAddettoDichiarazione?.name())
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_DICHIARANTE:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione.name())
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                        params.put("tipoConsenso", dettaglio.tipoConsenso)
                        params.put("attoNotarile", datiProvenienza.attoNotarile)
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoDichiaranteGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDichiarante()
                    break
                case FormulaUtils.FORMULA_FILIAZIONE_FISSA:
                    // solo per CNA
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("progressivo", FormulaUtils.getProgressivoFiliazioneFisso())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFiliazioneFisso()
                    break
                case FormulaUtils.FORMULA_FILIAZIONE:
                    params.put("tipoFiliazione", dettaglio.tipoFiliazione.name())
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                        params.put("tipoConsenso", dettaglio.tipoConsenso)
                        params.put("attoNotarile", datiProvenienza.attoNotarile)
                    }
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoFiliazioneGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFiliazione()
                    break
                case FormulaUtils.FORMULA_PARTO_PLURIMO:
                    params.put("partoPlurimo", dettaglio.partoPlurimo)
                    params.put("numeroGemello", dettaglio.numeroGemello)
                    params.put("totaleGemelli", dettaglio.totaleGemelli)
                    params.put("progressivo", FormulaUtils.getProgressivoPartoPlurimo())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoPartoPlurimo()
                    break
                case FormulaUtils.FORMULA_STATO_NASCITA:
                    params.put("natoMorto", dettaglio.natoMorto)
                    params.put("progressivo", FormulaUtils.getProgressivoStatoNascita())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoStatoNascita()
                    break
                case FormulaUtils.FORMULA_CIRCOSTANZE_PARTICOLARI:
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoCircostanzeParticolariGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    if (dettaglio.tipoFiliazione == ETipoFiliazione.C) {
                        params.put("tipoRiconoscimento", dettaglio.tipoRiconoscimento)
                    }
                    richiamo = FormulaUtils.getRichiamoCircostanzeParticolari()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    params.put("tipoComparente", datiProvenienza.tipoComparente)
                    params.put("tipoFirmatario", datiProvenienza.tipoFirmatario)
                    params.put("comprensioneDichiarante", datiProvenienza.comprensioneDichiarante?.id)
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    params.put("progressivo", FormulaUtils.getProgressivoGenericoTestoLiberoGreaterThen())
                    params.put("searchGreater", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
            }
        }
        if (richiamo != null){
            Window w = (Window)Executions.createComponents("/restrict/statocivile/formulaListaSelect.zul", self, [tipoAttoEnum: dettaglio.getTipoAttoEnum(), richiamo: richiamo, params: params])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                aggiornaFormulaFrammento(chiave, ((List)event.data), Boolean.FALSE)
            })
            w.doModal()
        }
    }

    List<ETipoFormulaAnnotazioneDaAtto> getChiaviAnnotazioni(){
        return []
    }

    IEstremiAttoNascitaSoggettiDomain getEstremiAttoNascitaDomain(){
        return margine
    }

    IEstremiAttoMatrimonioDomain getEstremiAttoMatrimonioDomain(){
        return null
    }

    Boolean isCaricamentoFormuleAnnotazioneAbilitato(){
        return Boolean.FALSE
    }

    Boolean isCaricamentoAnnotazioniAbilitato(){
        return Boolean.FALSE
    }

    @Command
    void onAggiornaCaseAndAna(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("campoAnagrafe") String campoAnagrafe){
        super.onAggiornaCaseAndAna(e, campoAnagrafe)

        checkCognomeFiglio()
    }

    @Command void onAggiornaCaseAndFiglio(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        onAggiornaCase(e)

        checkCognomeFiglio()
    }

    @Command void onSelectFiliazione() {
        checkCognomeFiglio()
        onSelectComparente()
        if(dettaglio.tipoFiliazione.equals(ETipoFiliazione.L)) {
            svuotaEstremiAtto()
        }
    }

    @Command void onSelectTipoRiconoscimento() {
        onSelectComparente()
    }

    private void checkCognomeFiglio() {
        // refs #66535
        if (civNascitaService.shouldInheritCognome(dettaglio)) {
            // Il nuovo nato deve prendere automaticamente il cognome del PADRE (ove presente) ma modificabile;
            // diversamente il cognome della MADRE
            if ((dettaglio.cognomePadre?.trim() ?: "") != "") {
                dettaglio.cognome = dettaglio.cognomePadre
                minuscole['cognome'] = minuscole['cognomePadre']
            } else {
                if ((dettaglio.cognomeMadre?.trim() ?: "") != "") {
                    dettaglio.cognome = dettaglio.cognomeMadre
                    minuscole['cognome'] = minuscole['cognomeMadre']
                }
            }
        }
        refreshUi()
    }

    void checkResidenzaFiglio(){
        if (civNascitaService.shouldInheritResidenza(dettaglio)) {
            Integer ccr = dettaglio.codiceComuneResidenzaMadre
            String dcr = dettaglio.descrizioneComuneResidenzaMadre
            Integer cpr = dettaglio.codiceProvinciaResidenzaMadre
            String spr = dettaglio.siglaProvinciaResidenzaMadre
            // refs #70404
            Boolean madreIta = Boolean.FALSE
            if ((ccr != null) && (cpr != null)) {
                Boolean comuneResEstero = statoCivileService.checkComuneEstero(cpr, ccr)
                madreIta = ((!(comuneResEstero)) || (comuneResEstero && (dettaglio.nazionalitaMadre?.id == AnaNazionalita.ID_ITALIA)))
            }
            if (madreIta) {
                log.info('Assegno al nato la residenza della madre')
            } else {
                // carico comune residenza padre
                ccr = dettaglio.codiceComuneResidenzaPadre
                dcr = dettaglio.descrizioneComuneResidenzaPadre
                cpr = dettaglio.codiceProvinciaResidenzaPadre
                spr = dettaglio.siglaProvinciaResidenzaPadre
                Boolean padreIta = Boolean.FALSE
                if ((ccr != null) && (cpr != null)) {
                    Boolean comuneResEstero = statoCivileService.checkComuneEstero(cpr, ccr)
                    padreIta = ((!(comuneResEstero)) || (comuneResEstero && (dettaglio.nazionalitaPadre?.id == AnaNazionalita.ID_ITALIA)))
                }
                if (padreIta) {
                    log.info('Assegno al nato la residenza del padre')
                } else {
                    ccr = null
                    dcr = null
                    cpr = null
                    spr = null
                }
            }
            /*
            if ( (ccr == null) && (cpr == null) ){
                ccr = dettaglio.codiceComuneResidenzaPadre
                dcr = dettaglio.descrizioneComuneResidenzaPadre
                cpr = dettaglio.codiceProvinciaResidenzaPadre
                spr = dettaglio.siglaProvinciaResidenzaPadre
            }
            */
            dettaglio.codiceComuneResidenza = ccr
            dettaglio.descrizioneComuneResidenza = dcr
            dettaglio.codiceProvinciaResidenza = cpr
            dettaglio.siglaProvinciaResidenza = spr
        }

        // Se il nato ha la stessa residenza della madre e questa non risiede nel comune utente, devo dare una segnalazione non bloccante
        if (civNascitaService.shouldWarnIfResidenzaDiversaMadreComuneUtente(dettaglio)) {
            Messagebox.show("Attenzione! Madre non residente, verificare il comune residenza del nato nella sezione 'Dati nascita'", msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectDataNascita(){
        if (DataUtils.isDataFutura(dettaglio.dataNascita)){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_data_futura), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onSelectNazionalita(){
        if (civNascitaService.shouldInheritNazionalita(dettaglio)) {
            // refs #56159
            // 1. doppia cittadinanza di cui una italiana: cittadinanza italiana d'ufficio;
            // 2. doppia cittadinanza di cui una di un paese UE: cittadinanza del paese UE d'ufficio;
            // 3. doppia cittadinanza entrambe di paese UE o entrambe non di paese non UE: sono i genitori a dichiarare per iscritto
            //    quale cittadinanza desiderano che sia attribuita al figlio.
            // N:B: I controlli valgono se le nazionalità sono valorizzate
            Boolean madreIta = (dettaglio.nazionalitaMadre?.id == AnaNazionalita.ID_ITALIA)
            Boolean padreIta = (dettaglio.nazionalitaPadre?.id == AnaNazionalita.ID_ITALIA)
            if (dettaglio.nazionalitaMadre && dettaglio.nazionalitaPadre && (madreIta || padreIta)) {
                if (madreIta) {
                    dettaglio.nazionalita = dettaglio.nazionalitaMadre
                } else {
                    dettaglio.nazionalita = dettaglio.nazionalitaPadre
                }
                refreshUi()
            } else {
                Boolean isMadreUE = dettaglio.nazionalitaMadre?.paeseUE
                Boolean isPadreUE = dettaglio.nazionalitaPadre?.paeseUE
                if (dettaglio.nazionalitaMadre && isMadreUE && dettaglio.nazionalitaPadre && (!(isPadreUE))) {
                    dettaglio.nazionalita = dettaglio.nazionalitaMadre
                    refreshUi()
                } else {
                    if (dettaglio.nazionalitaPadre && isPadreUE && dettaglio.nazionalitaMadre && (!(isMadreUE))) {
                        dettaglio.nazionalita = dettaglio.nazionalitaPadre
                        refreshUi()
                    } else {
                        if (dettaglio.nazionalitaMadre && (!(isMadreUE)) && dettaglio.nazionalitaPadre && (!(isPadreUE))) {
                            // refs #61616
                            dettaglio.nazionalita = ((dettaglio.nazionalitaMadre.id == dettaglio.nazionalitaPadre.id) ? dettaglio.nazionalitaMadre : null)
                            refreshUi()
                        }
                    }
                }
            }
        }
        checkResidenzaFiglio()
        refreshUi()
    }

    protected void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        super.selezionaComune(tca, c)

        switch (tca) {
            case ETipoComuneAtto.CN_PADRE:
                riempiComune(dettaglio.comuneNascitaPadre, c)
                break
            case ETipoComuneAtto.CR_PADRE:
                Boolean checkResidenza = Boolean.TRUE
                if (ComuneUtils.stessiCodici(dettaglio.codiceComuneResidenzaPadre, dettaglio.codiceProvinciaResidenzaPadre, c?.codiceComune, c?.codiceProvincia)){
                    checkResidenza = Boolean.FALSE
                }
                dettaglio.codiceComuneResidenzaPadre = c?.codiceComune
                dettaglio.descrizioneComuneResidenzaPadre = c?.descrizioneComune
                dettaglio.codiceProvinciaResidenzaPadre = c?.codiceProvincia
                dettaglio.siglaProvinciaResidenzaPadre = c?.siglaProvincia
                if (checkResidenza) {
                    checkResidenzaFiglio()
                }
                break
            case ETipoComuneAtto.CN_MADRE:
                riempiComune(dettaglio.comuneNascitaMadre, c)
                break
            case ETipoComuneAtto.CR_MADRE:
                Boolean checkResidenza = Boolean.TRUE
                if (ComuneUtils.stessiCodici(dettaglio.codiceComuneResidenzaMadre, dettaglio.codiceProvinciaResidenzaMadre, c?.codiceComune, c?.codiceProvincia)){
                    checkResidenza = Boolean.FALSE
                }
                dettaglio.codiceComuneResidenzaMadre = c?.codiceComune
                dettaglio.descrizioneComuneResidenzaMadre = c?.descrizioneComune
                dettaglio.codiceProvinciaResidenzaMadre = c?.codiceProvincia
                dettaglio.siglaProvinciaResidenzaMadre = c?.siglaProvincia
                if (checkResidenza) {
                    checkResidenzaFiglio()
                }
                break
            case ETipoComuneAtto.CN_NATO:
                dettaglio.codiceComuneNascita = c?.codiceComune
                dettaglio.descrizioneComuneNascita = c?.descrizioneComune
                dettaglio.codiceProvinciaNascita = c?.codiceProvincia
                dettaglio.siglaProvinciaNascita = c?.siglaProvincia
                if ( (datiProvenienza.comuneAttoOriginale.codice == null) && (datiProvenienza.comuneAttoOriginale.codiceProvincia == null) && (dettaglio.natura == ENaturaAtto.T) ){
                    riempiComune(datiProvenienza.comuneAttoOriginale, c)
                }
                break
        }
        refreshUi()
    }

    @Override
    protected void caricaDatiPadre(AnaAnagrafeBaseDomain ana){
        caricaDatiPadreFromAnagrafe(ana)

        // Se siamo nel matrimonio e il padre risulta coniugato
        if (dettaglio.tipoFiliazione.equals(ETipoFiliazione.L) && (ana.statoCivile == EStatoCivile.CN ) ) {
            if ((ana instanceof AnaAnagrafe) && ana.coniuge?.idAnagrafe != null) {
                AnaAnagrafe anaM = anaAnagrafeService.get(ana.coniuge.idAnagrafe, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT]]])
                caricaDatiMadreFromAnagrafe(anaM)
            } else {
                // se il soggetto è stato recuperato da anpr oppure se coniuge.idAnagrafe = null
                caricaDatiMadreFromAnagrafe(null)
                dettaglio.cognomeMadre = ana.coniuge?.cognome
                dettaglio.nomeMadre = ana.coniuge?.nome
                // se arrivo da anpr ho anche altre info di dettaglio da inserire in maschera
                if (ana instanceof AnpAnagrafe) {
                    if (ana.coniuge?.idAnagrafe != null) {
                        try{
                            AnaAnagrafe anaMAnp = anaAnagrafeService.get(ana.coniuge.idAnagrafe, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT]]])
                            anagrafe.anagrafe2 = anaMAnp
                        } catch (EmptyResultDataAccessException e) {
                            log.warn("Errore in recupero matricola madre da anagrafe locale con matricola coniuge da ANPR")
                            anagrafe.anagrafe2 = null
                        }
                    }
                    dettaglio.dataNascitaMadre = ana?.coniuge?.dataNascita

                    dettaglio.comuneNascitaMadre.codice = ana?.coniuge?.comuneNascita?.codice
                    dettaglio.comuneNascitaMadre.descrizione = ana?.coniuge?.comuneNascita?.descrizione
                    dettaglio.comuneNascitaMadre.codiceProvincia = ana?.coniuge?.comuneNascita?.codiceProvincia
                    dettaglio.comuneNascitaMadre.siglaProvincia = ana?.coniuge?.comuneNascita?.siglaProvincia

                    dettaglio.nazionalitaMadre = ana?.coniuge?.nazionalita
                    dettaglio.codiceComuneResidenzaMadre = ana?.coniuge?.comuneResidenza?.codice
                    dettaglio.descrizioneComuneResidenzaMadre = ana?.coniuge?.comuneResidenza?.descrizione
                    dettaglio.codiceProvinciaResidenzaMadre = ana?.coniuge?.comuneResidenza?.codiceProvincia
                    dettaglio.siglaProvinciaResidenzaMadre = ana?.coniuge?.comuneResidenza?.siglaProvincia
                }
            }
        }
        checkCognomeFiglio()
        onSelectNazionalita() // lancia anche il controllo/l'assegnazione della residenza

        super.caricaDatiPadre(ana)
    }
    // aggiorna o svuota
    void caricaDatiPadreFromAnagrafe(AnaAnagrafeBaseDomain ana){
        if (anagrafe) {
            if (ana instanceof AnpAnagrafe){
                anagrafe.anagrafe1 = ana?.anagrafe
            } else {
                anagrafe.anagrafe1 = (AnaAnagrafe) ana
            }
        }
        dettaglio.cognomePadre = ana?.cognome
        dettaglio.nomePadre = ana?.nome
        dettaglio.dataNascitaPadre = ana?.dataNascita

        dettaglio.comuneNascitaPadre.codice = ana?.codiceComuneNascita
        dettaglio.comuneNascitaPadre.descrizione = ana?.descrizioneComuneNascita
        dettaglio.comuneNascitaPadre.codiceProvincia = ana?.codiceProvinciaNascita
        dettaglio.comuneNascitaPadre.siglaProvincia = ana?.siglaProvinciaNascita

        dettaglio.nazionalitaPadre = ana?.nazionalita
        dettaglio.codiceComuneResidenzaPadre = ana?.comuneResidenza?.codice
        dettaglio.descrizioneComuneResidenzaPadre = ana?.comuneResidenza?.descrizione
        dettaglio.codiceProvinciaResidenzaPadre = ana?.comuneResidenza?.codiceProvincia
        dettaglio.siglaProvinciaResidenzaPadre = ana?.comuneResidenza?.siglaProvincia
    }

    @Override
    protected void caricaDatiMadre(AnaAnagrafeBaseDomain ana){
        caricaDatiMadreFromAnagrafe(ana)

        // Se siamo nel matrimonio e la madre risulta coniugata
        if (dettaglio.tipoFiliazione.equals(ETipoFiliazione.L) && (ana.statoCivile == EStatoCivile.CN)){
            if ((ana instanceof AnaAnagrafe) && ana.coniuge?.idAnagrafe != null) {
                AnaAnagrafe anaP = anaAnagrafeService.get(ana.coniuge.idAnagrafe, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT]]])
                caricaDatiPadreFromAnagrafe(anaP)
            } else {
                // se il soggetto è stato recuperato da anpr oppure se coniuge.idAnagrafe = null
                caricaDatiPadreFromAnagrafe(null)
                dettaglio.cognomePadre = ana.coniuge?.cognome
                dettaglio.nomePadre = ana.coniuge?.nome
                // se arrivo da anpr ho anche altre info di dettaglio da inserire in maschera
                if (ana instanceof AnpAnagrafe) {
                    if (ana.coniuge?.idAnagrafe != null) {
                        try {
                            AnaAnagrafe anaPAnp = anaAnagrafeService.get(ana.coniuge.idAnagrafe, [fetch: [[campo: 'nazionalita', tipo: JoinType.LEFT]]])
                            anagrafe.anagrafe1 = anaPAnp
                        } catch (EmptyResultDataAccessException e) {
                            log.warn("Errore in recupero matricola padre da anagrafe locale con matricola coniuge da ANPR")
                            anagrafe.anagrafe1 = null
                        }
                    }
                    dettaglio.dataNascitaPadre = ana?.coniuge?.dataNascita

                    dettaglio.comuneNascitaPadre.codice = ana?.coniuge?.comuneNascita?.codice
                    dettaglio.comuneNascitaPadre.descrizione = ana?.coniuge?.comuneNascita?.descrizione
                    dettaglio.comuneNascitaPadre.codiceProvincia = ana?.coniuge?.comuneNascita?.codiceProvincia
                    dettaglio.comuneNascitaPadre.siglaProvincia = ana?.coniuge?.comuneNascita?.siglaProvincia

                    dettaglio.nazionalitaPadre = ana?.coniuge?.nazionalita
                    dettaglio.codiceComuneResidenzaPadre = ana?.coniuge?.comuneResidenza?.codice
                    dettaglio.descrizioneComuneResidenzaPadre = ana?.coniuge?.comuneResidenza?.descrizione
                    dettaglio.codiceProvinciaResidenzaPadre = ana?.coniuge?.comuneResidenza?.codiceProvincia
                    dettaglio.siglaProvinciaResidenzaPadre = ana?.coniuge?.comuneResidenza?.siglaProvincia
                }
            }
        }
        // Il bambino deve sempre prendere il cognome del padre se questo risulta valorizzato
        checkCognomeFiglio()
        onSelectNazionalita() // lancia anche il controllo/l'assegnazione della residenza

        super.caricaDatiMadre(ana)
    }
    // aggiorna o svuota
    void caricaDatiMadreFromAnagrafe(AnaAnagrafeBaseDomain ana){
        if (anagrafe) {
            if (ana instanceof AnpAnagrafe){
                anagrafe.anagrafe2 = ana?.anagrafe
            } else {
                anagrafe.anagrafe2 = (AnaAnagrafe) ana
            }
        }
        dettaglio.cognomeMadre = ana?.cognome
        dettaglio.nomeMadre = ana?.nome
        dettaglio.dataNascitaMadre = ana?.dataNascita

        dettaglio.comuneNascitaMadre.codice = ana?.codiceComuneNascita
        dettaglio.comuneNascitaMadre.descrizione = ana?.descrizioneComuneNascita
        dettaglio.comuneNascitaMadre.codiceProvincia = ana?.codiceProvinciaNascita
        dettaglio.comuneNascitaMadre.siglaProvincia = ana?.siglaProvinciaNascita

        dettaglio.nazionalitaMadre = ana?.nazionalita
        dettaglio.codiceComuneResidenzaMadre = ana?.comuneResidenza?.codice
        dettaglio.descrizioneComuneResidenzaMadre = ana?.comuneResidenza?.descrizione
        dettaglio.codiceProvinciaResidenzaMadre = ana?.comuneResidenza?.codiceProvincia
        dettaglio.siglaProvinciaResidenzaMadre = ana?.comuneResidenza?.siglaProvincia
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civNascitaService.delete(dettaglio)
        }
    }

    @Command void onSelectAutorita(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isPrimaA() || dettaglio.isPrimaB()){
            log.info("Non occorre caricare lista valori 'Autorita' ")
        } else {
            super.onSelectAutorita(event)
        }
    }

    @Command void onSelectLuogoNascita(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isPrimaA() || dettaglio.isPrimaB() || dettaglio.isSecondaA() || dettaglio.isCentroNascita() || dettaglio.isTestoLibero()) {
            CivLuogoNascita c = null
            if (event?.target?.selectedItem instanceof CivLuogoNascita) {
                c = event.target.selectedItem
            }
            datiProvenienza.nelLuogoNascita = c?.nel
            datiProvenienza.luogoNascita = c?.descrizione
            refreshUi()
        }
    }

    /*
    @Command void onChangeLuogoNascita(@ContextParam(ContextType.TRIGGER_EVENT) InputEvent event){
        if ((event.previousValue?:"") != (event.value?:"")){
            log.info("onChangeLuogoNascita " + (event.value?:""))
            // 21/12/2021 commentata per evitare che l'articolo venga vuotato se l'utente digita il luogo anziché selezionare da popup
            //datiProvenienza.nelLuogoNascita = null
        }
    }
    */

    @Command void onCancellaLuogoNascita(){
        onSelectLuogoNascita(null)
    }

    @Command void onSelectDichiarante(){
        if (dettaglio.isRiconoscimento()){
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteNascita.PD.name():
                    listaComparenteRic = [null] + [getDCFItem(ETipoDichiaranteNascita.PD),
                                                   getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.MD.name():
                    listaComparenteRic = [null] + [getDCFItem(ETipoDichiaranteNascita.MD),
                                                   getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.EN.name():
                    listaComparenteRic = [null] + [getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.AL.name():
                    listaComparenteRic = [null] + [getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
            }
            if (datiProvenienza?.tipoComparente) {
                Boolean exists = listaComparenteRic*.get("value").contains(datiProvenienza.tipoComparente)
                if (!(exists)) {
                    datiProvenienza.tipoComparente = null
                }
            }
        } else
        if (dettaglio.isCambioGeneralita()) {
            //non devo fare nulla perché le liste sono fisse
        } else
        if (dettaglio.isDicCompFirmNasVisibile()) {
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteNascita.PDMD.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.PDMD),
                                                getDCFItem(ETipoDichiaranteNascita.PDMDIT)]
                    break
                case ETipoDichiaranteNascita.PD.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.PD),
                                                getDCFItem(ETipoDichiaranteNascita.PDMD),
                                                getDCFItem(ETipoDichiaranteNascita.PDIT),
                                                getDCFItem(ETipoDichiaranteNascita.PDMDIT)]
                    break
                case ETipoDichiaranteNascita.MD.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.MD),
                                                getDCFItem(ETipoDichiaranteNascita.PDMD),
                                                getDCFItem(ETipoDichiaranteNascita.MDIT),
                                                getDCFItem(ETipoDichiaranteNascita.PDMDIT)]
                    break
                case ETipoDichiaranteNascita.PP.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.PP),
                                                getDCFItem(ETipoDichiaranteNascita.PPMD)]
                    break
                case ETipoDichiaranteNascita.PM.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.PM),
                                                getDCFItem(ETipoDichiaranteNascita.PMPD)]
                    break
                case ETipoDichiaranteNascita.OS.name():
                    // refs #72216
                    // Se comparente sanitario, escludere la dichiarazione sostitutiva
                    if (dettaglio.isTipoAccertamentoVisibile()) {
                        listaTipoAccertamento = [ETipoAccertamentoNascita.AN, ETipoAccertamentoNascita.CP]
                    }
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.OS)]
                    break
                case ETipoDichiaranteNascita.AL.name():
                    listaComparente = [null] + [getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
            }
            if (datiProvenienza?.tipoComparente) {
                Boolean exists = listaComparente*.get("value").contains(datiProvenienza.tipoComparente)
                if (!(exists)) {
                    datiProvenienza.tipoComparente = null
                }
            }
        }
        onSelectComparente()
    }

    @Command void onSelectComparente(){
        listaTipoConsenso = [null]
        if (dettaglio.isRiconoscimento()){
            switch (datiProvenienza.tipoDichiarante) {
                case ETipoDichiaranteNascita.PD.name():
                    listaFirmatarioRic = [null] + [getDCFItem(ETipoDichiaranteNascita.PD),
                                                   getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.MD.name():
                    listaFirmatarioRic = [null] + [getDCFItem(ETipoDichiaranteNascita.MD),
                                                   getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.EN.name():
                    listaFirmatarioRic = [null] + [getDCFItem(ETipoDichiaranteNascita.EN),
                                                   getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
                case ETipoDichiaranteNascita.AL.name():
                    listaFirmatarioRic = [null] + [getDCFItem(ETipoDichiaranteNascita.AL)]
                    break
            }
            if (datiProvenienza?.tipoFirmatario) {
                Boolean exists = listaFirmatarioRic*.get("value").contains(datiProvenienza.tipoFirmatario)
                if (!(exists)) {
                    datiProvenienza.tipoFirmatario = null
                }
            }
        } else if (dettaglio.isCambioGeneralita()) {
            //non devo fare nulla perché le liste sono fisse
        } else if (dettaglio.isDicCompFirmNasVisibile()) {

            List<Map> listaSoloGenitoriONessuno = [null] + [getDCFItem(ETipoDichiaranteNascita.PD),
                                                            getDCFItem(ETipoDichiaranteNascita.MD),
                                                            getDCFItem(ETipoDichiaranteNascita.PDMD),
                                                            getDCFItem(ETipoDichiaranteNascita.NE)]
            switch (datiProvenienza.tipoComparente) {
                case ETipoDichiaranteNascita.PD.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PD),
                                                getDCFItem(ETipoDichiaranteNascita.NE)]
                    caricaListaConsenso([ETipoConsenso.CM, ETipoConsenso.SM])
                    break
                case ETipoDichiaranteNascita.MD.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.MD),
                                                getDCFItem(ETipoDichiaranteNascita.NE)]
                    caricaListaConsenso([ETipoConsenso.CP, ETipoConsenso.SP])
                    break
                case ETipoDichiaranteNascita.PDMD.name():
                    // refs #72216
                    // Se nascita tardiva e comparenti padre e madre, firmatari per forza entrambi
                    if (dettaglio.isPrimaB()){
                        if ([ETipoDichiaranteNascita.PD.name(), ETipoDichiaranteNascita.MD.name()].contains(datiProvenienza.tipoFirmatario)){
                            // per retrocompatibilità in modo da evitare cancellazione
                            listaFirmatario = listaSoloGenitoriONessuno
                        } else {
                            // per atti nuovi
                            listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PDMD),
                                                        getDCFItem(ETipoDichiaranteNascita.NE)]
                        }
                    } else {
                        listaFirmatario = listaSoloGenitoriONessuno
                    }
                    caricaListaConsenso([])
                    break
                case ETipoDichiaranteNascita.PP.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PP)]
                    caricaListaConsenso([ETipoConsenso.CM, ETipoConsenso.SM])
                    break
                case ETipoDichiaranteNascita.PM.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PM)]
                    caricaListaConsenso([ETipoConsenso.CP, ETipoConsenso.SP])
                    break
                case ETipoDichiaranteNascita.PPMD.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PP),
                                                getDCFItem(ETipoDichiaranteNascita.PPMD)]
                    caricaListaConsenso([])
                    break
                case ETipoDichiaranteNascita.PMPD.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PM),
                                                getDCFItem(ETipoDichiaranteNascita.PMPD)]
                    caricaListaConsenso([])
                    break
                case ETipoDichiaranteNascita.PDIT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.IT),
                                                getDCFItem(ETipoDichiaranteNascita.PDIT)]
                    caricaListaConsenso([ETipoConsenso.CM, ETipoConsenso.SM])
                    break
                case ETipoDichiaranteNascita.MDIT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.IT),
                                                getDCFItem(ETipoDichiaranteNascita.MDIT)]
                    caricaListaConsenso([ETipoConsenso.CP, ETipoConsenso.SP])
                    break
                case ETipoDichiaranteNascita.PDMDIT.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.PDIT),
                                                getDCFItem(ETipoDichiaranteNascita.MDIT),
                                                getDCFItem(ETipoDichiaranteNascita.IT),
                                                getDCFItem(ETipoDichiaranteNascita.PDMDIT)]
                    caricaListaConsenso([])
                    break
                case ETipoDichiaranteNascita.OS.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.OS)]
                    caricaListaConsenso([])
                    break
                case ETipoDichiaranteNascita.AL.name():
                    listaFirmatario = [null] + [getDCFItem(ETipoDichiaranteNascita.AL)]
                    caricaListaConsenso([])
                    break
            }
            if (datiProvenienza?.tipoFirmatario) {
                Boolean exists = listaFirmatario*.get("value").contains(datiProvenienza.tipoFirmatario)
                if (!(exists)) {
                    datiProvenienza.tipoFirmatario = null
                }
            }
            checkSoggettoCollegato()
        }
        refreshUi()
    }

    void caricaListaConsenso(List<ETipoConsenso> lCons){
        /*se tipo_riconoscimento 'MD' (materno) il tipo_consenso deve essere abilitato
          se tipo_riconoscimento 'PD' o 'PDMD' il tipo_consenso deve essere disabilitato
          se tipo_riconoscimento resta vuoto, tipo_consenso viene manipolato come già previsto in partenza, e cioè in funzione del tipo_comparente*/
        listaTipoConsenso = [null]
        boolean madreDichiaranteComparente = datiProvenienza?.tipoDichiarante?.equals(ETipoDichiaranteNascita.MD.name()) && datiProvenienza?.tipoComparente?.equals(ETipoDichiaranteNascita.MD.name())
        if (dettaglio.isTipoConsensoEnabled() && !madreDichiaranteComparente && (lCons.size() > 0)) {
            listaTipoConsenso.addAll(lCons)
        }
        if (dettaglio.tipoConsenso){
            Boolean exists = listaTipoConsenso.contains(dettaglio.tipoConsenso)
            if (!(exists)) {
                dettaglio.tipoConsenso = null
            }
        }
        refreshUi()
    }

    void checkSoggettoCollegato(){
        if (anscOn) {
            if (datiProvenienza?.isComparenteProcuratorePadre() && (getProcuratorePadre() == null)) {
                CivSoggettoCollegato scProcuratorePadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.PP)
                listaSoggettiCollegati.add(scProcuratorePadre)
            }
            if (datiProvenienza?.isComparenteProcuratoreMadre() && (getProcuratoreMadre() == null)) {
                CivSoggettoCollegato scProcuratoreMadre = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.PM)
                listaSoggettiCollegati.add(scProcuratoreMadre)
            }
            if (datiProvenienza?.isComparenteSanitario() && (getSanitario() == null)) {
                CivSoggettoCollegato scSanitario = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.OS)
                listaSoggettiCollegati.add(scSanitario)
            }
            if (datiProvenienza?.isComparenteInterprete() && (getInterprete() == null)) {
                CivSoggettoCollegato scInterprete = new CivSoggettoCollegato(tipoSoggettoCollegato: ETipoSoggettoCollegato.IT)
                listaSoggettiCollegati.add(scInterprete)
            }
        }
    }

    private void svuotaEstremiAtto() {
        dettaglio.tipoRiconoscimento = null
        //1
        datiProvenienza.numeroAttoRiconoscimento1 = null
        datiProvenienza.parteAttoRiconoscimento1 = null
        datiProvenienza.serieAttoRiconoscimento1 = null
        datiProvenienza.ufficioAttoRiconoscimento1 = null
        datiProvenienza.annoAttoRiconoscimento1 = null
        datiProvenienza.idAttoAnscRiconoscimento1 = null
        datiProvenienza.comuneAttoRiconoscimento1.descrizione = null
        datiProvenienza.comuneAttoRiconoscimento1.codice = null
        datiProvenienza.comuneAttoRiconoscimento1.codiceProvincia = null
        datiProvenienza.comuneAttoRiconoscimento1.siglaProvincia = null
        datiProvenienza.dataAttoRiconoscimento1 = null
        //2
        datiProvenienza.numeroAttoRiconoscimento2 = null
        datiProvenienza.parteAttoRiconoscimento2 = null
        datiProvenienza.serieAttoRiconoscimento2 = null
        datiProvenienza.ufficioAttoRiconoscimento2 = null
        datiProvenienza.annoAttoRiconoscimento2 = null
        datiProvenienza.idAttoAnscRiconoscimento2 = null
        datiProvenienza.comuneAttoRiconoscimento2.descrizione = null
        datiProvenienza.comuneAttoRiconoscimento2.codice = null
        datiProvenienza.comuneAttoRiconoscimento2.codiceProvincia = null
        datiProvenienza.comuneAttoRiconoscimento2.siglaProvincia = null
        datiProvenienza.dataAttoRiconoscimento2 = null



    }

    // -------------------- IRowMotivoRichiesta - INIZIO --------------------

    @Override
    void caricaListaTipoRichiesta() {
        listaTipoRichiesta = civCategoriaTipoRichiestaService.listAllByCivCategoriaTipoAtto(atto.tipoAttoDomain?.categoriaDomain)
    }

    @Override
    @Command
    void onSelectTipoRichiesta() {
        refreshUi()
    }

    @Override
    @Command
    void onCaricaMotiviRichiesta() {
        CivCategoriaTipoAtto categoria = dettaglio.tipoAttoDomain?.categoriaDomain
        if (categoria) {
            Window w = (Window) Executions.createComponents("/restrict/statocivile/nascita/motivoNascitaSelect.zul", self, [categoria: categoria, tipoRichiesta: dettaglio.tipoRichiesta])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof CivMotivoRichiesta) {
                    dettaglio.motivoNascita = (CivMotivoRichiesta) event.data
                    checkSoggettoCollegato()
                    refreshUi()
                }
            })
            w.doModal()
        }
    }

    @Override
    String getMotivoRichiestaField() {
        if (!dettaglio.hasProperty(MOTIVO_RICHIESTA_FIELD)) {
            throw new RuntimeException("Motivo richiesta non presente per il campo ${MOTIVO_RICHIESTA_FIELD}")
        }
        return MOTIVO_RICHIESTA_FIELD
    }

    // -------------------- IRowMotivoRichiesta - FINE --------------------

    @Override
    void aggiornaDatiSupplementariEstremiAttoNascitaSoggetto1DaAttoDiNascita(CivNascita nascita){
        margine.dataAttoNascita = nascita.dataRegistrazione
    }

    void storicizzaAtto(Long pkAtto) {
        civNascitaService.storicizza(pkAtto)
    }

}