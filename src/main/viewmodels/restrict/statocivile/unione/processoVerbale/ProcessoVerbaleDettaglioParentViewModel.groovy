package restrict.statocivile.unione.processoVerbale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class ProcessoVerbaleDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivProcessoVerbale dettaglio
    List<Map> listaImpossibilitato = []

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivProcessoVerbaleService civProcessoVerbaleService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.PVU)

        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map> eList = []
        eList.addAll(CivProcessoVerbale.etichetteDomain)
        eList.addAll([Etichette.Comune, Etichette.Impossibilitato,Etichette.Certificato_del, Etichette.Comune_Atto, Etichette.Dati_Certificato,
                      Etichette.Documenti_presentati, Etichette.Dati_Tribunale, Etichette.Autorizzazione_tribunale_di])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivDocumentoPubblicazione.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Richiedenti, Etichette.Documenti])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_RICHIEDENTI, Etichette.SEZIONE_DATI_PUBBLICAZIONE,
                      Etichette.SEZIONE_COMPOSIZIONE, Etichette.SEZIONE_REDAZIONE])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriProcessoVerbale()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette sesso
        listaSesso = [null] + ESesso.values().toList()
        eList.addAll(ESesso.values()*.getEtichettaDesc())

        // Aggiungo etichette per FCC/PDV Impossibilitato
        eList.addAll(Arrays.asList(EImpossibilitato.values())*.etichettaDesc)

        doInitAllAtti(eList)

        listaImpossibilitato = [null]
        listaImpossibilitato.addAll([getDCFItem(EImpossibilitato.C1),
                                     getDCFItem(EImpossibilitato.C2),
                                     getDCFItem(EImpossibilitato.EN)])

        msgTitle = getEtichetta(Etichette.Processo_Verbale)
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.PVU)

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_RICHIEDENTI, FormulaUtils.FORMULA_DOCUMENTI, FormulaUtils.FORMULA_DOCUMENTI_ALTRO,
                FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [natura: dettaglio.natura, flagDefault:Boolean.TRUE,
                      searchEqual: Boolean.TRUE, categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaProcessoVerbale(chiave, tipoOperazione, dettaglio, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_RICHIEDENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoRichiedenti())
                    richiamo = FormulaUtils.getRichiamoRichiedenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("documentoPresentatoPubblicazione", documentoPubblicazione.documentoPresentatoPubblicazione)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI_ALTRO:
                    params.put("documentoPresentatoPubblicazione", documentoPubblicazione.documentoPresentatoPubblicazione)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumentiAltro())
                    richiamo = FormulaUtils.getRichiamoDocumentiAltro()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = statoCivileService.listFormuleProcessoVerbale(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [natura: dettaglio.natura, flagDb:Boolean.TRUE, categoria: dettaglio.tipoAttoDomain?.categoriaDomain?.codice]
        Integer richiamo = null
        if (FormulaUtils.addFormulaProcessoVerbale(chiave, tipoOperazione, dettaglio, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_RICHIEDENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoRichiedenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiedenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI_ALTRO:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumentiAltro())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumentiAltro()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
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
            Window w = (Window) Executions.createComponents("/restrict/statocivile/formulaListaSelect.zul", self, [tipoAttoEnum: dettaglio.getTipoAttoEnum(), richiamo: richiamo, params: params])
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
        return sposi
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

    void apriPreviewAnnotazioni(){
        log.info("Funzionalità da non implementare per i processi verbali")
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civProcessoVerbaleService.delete(dettaglio)
        }
    }

    void storicizzaAtto(Long pkAtto) {
        civProcessoVerbaleService.storicizza(pkAtto)
    }

}