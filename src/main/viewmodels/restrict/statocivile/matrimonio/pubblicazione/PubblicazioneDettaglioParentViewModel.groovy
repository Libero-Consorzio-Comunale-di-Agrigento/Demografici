package restrict.statocivile.matrimonio.pubblicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggettiDomain
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.AttoSoggettiDettaglioParentViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class PubblicazioneDettaglioParentViewModel extends AttoSoggettiDettaglioParentViewModel{

    CivPubblicazione dettaglio

    List<EDocumentoMatrimonio> listaDocumentiPresentati = []
    List<Map> listaDichiarante = []

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivPubblicazioneService civPubblicazioneService

    void doInit(Window w, Long id, CivTipoAtto tipoAttoDomain) {
        self = w

        initMinuscole(ETipoAtto.PUB)

        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map> eList = []
        eList.addAll(CivPubblicazione.etichetteDomain)
        eList.addAll([Etichette.Comune, Etichette.otto, Etichette.Comune_Atto, Etichette.Sposo, Etichette.Sposa, Etichette.Dati_Certificato,
                      Etichette.Dati_Affissione, Etichette.Documenti_presentati, Etichette.Comuni_pubblicazione,
                      Etichette.durata_giorni_pubblicazione, Etichette.Articolo_Certificato_rilasciato, Etichette.Legge_Certificato_rilasciato])

        eList.addAll(CivDatiProvenienzaAtto.etichetteDomain)
        eList.addAll(CivMargine.etichetteDomain)
        eList.addAll(CivTestimoniAtto.etichetteDomain)
        eList.addAll(CivDocumentoPubblicazione.etichetteDomain)

        // Aggiungo label frammenti specifici
        eList.addAll([Etichette.Dati_Matrimonio, Etichette.Richiedenti, Etichette.Documenti])

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.SEZIONE_INFORMAZIONI_ATTO, Etichette.SEZIONE_RICHIEDENTI, Etichette.SEZIONE_DATI_PUBBLICAZIONE,
                      Etichette.SEZIONE_COMPOSIZIONE, Etichette.SEZIONE_REDAZIONE])

        // Aggiungo etichette natura atto
        listaNatura = NaturaUtils.getValoriVerbalePubblicazione()
        eList.addAll(listaNatura*.etichettaDesc)

        // Aggiungo etichette documenti presentati
        listaDocumentiPresentati = Arrays.asList(EDocumentoMatrimonio.values())
        eList.addAll(listaDocumentiPresentati*.etichettaDesc)

        // Aggiungo etichette tipo dichiarante
        eList.addAll((Arrays.asList(ETipoDichiarantePubblicazione.values()))*.etichettaDesc)

        doInitAllAtti(eList)

        listaDichiarante = [getDCFItem(ETipoDichiarantePubblicazione.SO),
                            getDCFItem(ETipoDichiarantePubblicazione.SA),
                            getDCFItem(ETipoDichiarantePubblicazione.SI),
                            getDCFItem(ETipoDichiarantePubblicazione.AL)]

        msgTitle = getEtichetta(Etichette.Verbale_Pubblicazione)
        tipoAttoLabel = getEtichettaEnum(ETipoAtto.PUB)

        resize()

        if (id){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAttoDomain:tipoAttoDomain])
        }
    }

    List<String> getChiaviFormule(){
        return [FormulaUtils.FORMULA_TESTATA, FormulaUtils.FORMULA_RICHIEDENTI, FormulaUtils.FORMULA_DOCUMENTI,
                FormulaUtils.FORMULA_CHIUSURA, FormulaUtils.FORMULA_TESTO_LIBERO, FormulaUtils.FORMULA_FIRMA]
    }

    void searchFormulaDefault(String chiave, Boolean salva){
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDefault:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaPubblicazione(chiave, tipoOperazione, dettaglio, datiProvenienza, margine, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_RICHIEDENTI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("progressivo", FormulaUtils.getProgressivoRichiedenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiedenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("documentoPresentatoPubblicazione", documentoPubblicazione.documentoPresentatoPubblicazione)
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
                    break
                case FormulaUtils.FORMULA_CHIUSURA:
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    richiamo = FormulaUtils.getRichiamoChiusura()
                    break
                case FormulaUtils.FORMULA_TESTO_LIBERO:
                    params.put("codiceMinuta", dettaglio.tipoAttoDomain?.codiceMinuta)
                    params.put("categoria", dettaglio.tipoAttoDomain?.categoriaDomain?.codice)
                    richiamo = FormulaUtils.getRichiamoTestoLibero()
                    break
                case FormulaUtils.FORMULA_FIRMA:
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("progressivo", FormulaUtils.getProgressivoFirma())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoFirma()
                    break
            }
        }
        if (tipoOperazione.isUpdate() && (richiamo != null) ){
            log.info("Tento recupero ${chiave.toUpperCase()} per il record con id ${dettaglio.id}")
            List<Map<String, Object>> formule = statoCivileService.listFormulePubblicazione(richiamo, params)
            creaFormulaDefault(chiave, richiamo, params)
            aggiornaFormulaFrammento(chiave, formule, salva, Boolean.FALSE)
        }
    }

    void searchFormuleFrammento(String chiave) {
        Map params = [parte: dettaglio.parte, serie: dettaglio.serie, natura: dettaglio.natura, flagDb:Boolean.TRUE]
        Integer richiamo = null
        if (FormulaUtils.addFormulaPubblicazione(chiave, tipoOperazione, dettaglio, datiProvenienza, margine, documentoPubblicazione)) {
            switch (chiave) {
                case FormulaUtils.FORMULA_TESTATA:
                    params.put("progressivo", FormulaUtils.getProgressivoTestata())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoTestata()
                    break
                case FormulaUtils.FORMULA_RICHIEDENTI:
                    params.put("documentoPresentatoMatrimonio", margine.documentoPresentatoMatrimonio)
                    params.put("tipoDichiarante", datiProvenienza.tipoDichiarante)
                    params.put("progressivo", FormulaUtils.getProgressivoRichiedenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoRichiedenti()
                    break
                case FormulaUtils.FORMULA_DOCUMENTI:
                    params.put("progressivo", FormulaUtils.getProgressivoDocumenti())
                    params.put("searchEqual", Boolean.TRUE)
                    richiamo = FormulaUtils.getRichiamoDocumenti()
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
                aggiornaFormulaFrammento(chiave, (List)event.data, Boolean.FALSE)
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
        log.info("Funzionalità da non implementare per le pubblicazioni")
    }

    void eliminaAtto(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civPubblicazioneService.delete(dettaglio)
        }
    }

    @Command void onSelectAutorita(@ContextParam(ContextType.TRIGGER_EVENT) Event event){
        if (dettaglio.isSecondaA() || dettaglio.isSecondaB()){
            super.onSelectAutorita(event)
        }
    }

    @Command void onSelectDocumentoPresentato() {
        switch (margine.documentoPresentatoMatrimonio) {
            case EDocumentoMatrimonio.UNO:
                onCancellaComune(ETipoComuneAtto.CA_PUBB2.name())
                margine.dataAffissioneDa2 = null
                margine.dataAffissioneA2 = null
                break
            case EDocumentoMatrimonio.OME:
                onCancellaComune(ETipoComuneAtto.CA_PUBB1.name())
                margine.dataAffissioneDa1 = null
                margine.dataAffissioneA1 = null
                margine.giorniAffissione = null
                onCancellaComune(ETipoComuneAtto.CA_PUBB2.name())
                margine.dataAffissioneDa2 = null
                margine.dataAffissioneA2 = null
                break
        }
        switch (margine.documentoPresentatoMatrimonio) {
            case EDocumentoMatrimonio.UNO:
            case EDocumentoMatrimonio.DUE:
                ArcComune c = statoCivileService.getComuneCliente()
                riempiComune(margine.comuneAffissione1, c)
                margine.dataAffissioneDa1 = dettaglio.dataPubblicazione
                margine.dataAffissioneA1 = DataUtils.addDays(dettaglio.dataPubblicazione, 8)
                margine.giorniAffissione = getEtichetta(Etichette.otto)
        }
        refreshUi()
    }

    void storicizzaAtto(Long pkAtto) {
        civPubblicazioneService.storicizza(pkAtto)
    }

}