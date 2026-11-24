package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.statocivile.TraitTemplateTrasportoESeppellimento

/**
 * Documento in Uscita
 */
@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DocumentoUscitaDettaglioViewModel extends AbstractDettaglioViewModel implements TraitTemplateTrasportoESeppellimento {

    CivAttoBaseDomain atto

    /** Seleziona se espandere il dettaglio vuoto (se mancano i dati di TrasportoESeppellimento) */
    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]
    /** Maschio/Femmina */
    List<ESesso> listaSesso = []

    String tipoAttoLabel = ""

    /** Verifica se consentire l'inserimento delle minuscole in alcuni campi testuali (tipo nome e cognome) */
    Map<String,Boolean> minuscole = [:]

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private CivTrasportoESeppellimentoService civTrasportoESeppellimentoService

    // ------------------ Servizi per Trait TrasportoESeppellimento ---------------------
    //
    @WireVariable
    private CivRegistroDocumentiUscitaService civRegistroDocumentiUscitaService

    @WireVariable
    CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService
    //
    // -------------------- ---------------------------- --------------------------

    @WireVariable
    private CivMorteService civMorteService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private ArcParametroService arcParametroService

    /** Apre un {@link CivTrasportoESeppellimento} in modifica in base all'ID_ATTO */
    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("identificativoAtto") String identificativoAtto) {

        self = w

        saveRecordEnabled = true

        minuscole = [cognomeRichiedente:Boolean.FALSE, nomeRichiedente: Boolean.FALSE,
                     cognomeIncaricatoTrasporto:Boolean.FALSE, nomeIncaricatoTrasporto: Boolean.FALSE]
        arcParametroService.checkMinuscoleOn(minuscole)

        List<Map> eList = [Etichette.getEtichetta("DOCUMENTO_USCITA"), Etichette.getEtichetta("Gestione_Documenti_Uscita"), Etichette.getEtichetta("Dati_Richiedente")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_Numero_Protocollo")])
        eList.addAll(etichetteDettaglioDefault)
        eList.addAll(CivTrasportoESeppellimento.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichetta tipo documento
        eList.add(Etichette.getEtichetta("Uscita"))

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        // Aggiungo etichette sesso
        listaSesso = Arrays.asList(ESesso.values())
        eList.addAll(listaSesso*.etichettaDesc)

        // Aggiungo titoli sezioni
        eList.addAll([Etichette.getEtichetta("SEZIONE_ESTREMI_ATTO"), Etichette.getEtichetta("SEZIONE_ESTREMI_TRASPORTO"), Etichette.getEtichetta("SEZIONE_ESTREMI_CREMAZIONE")])

        // Aggiungo etichette di base CivMorte
        eList.addAll(CivMorte.etichetteDomain)

        // Aggiungo etichette sezione trasporto
        eList.addAll(etichetteTsDefault)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        initTrasporto(civRegistroDocumentiUscitaService)

        msgTitle = getEtichetta(Etichette.getEtichetta("Gestione_Documenti_Uscita"))

        formLabel = getEtichetta(Etichette.getEtichetta("DOCUMENTO_USCITA"))

        tipoAttoLabel = getEtichettaEnum(ETipoAtto.MOR)

        resize()

        atto = civMorteService.getByIdentificativoAtto( identificativoAtto )

        ricercaSoggettoInANPROn = arcParametroService.isRicercaSoggettoInANPRAttiva()

        if (id) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    @Override void caricaDettaglio(def id) {
        trasporto = civTrasportoESeppellimentoService.get(id)

        allineaTestoTrasportoMinuscole()

        initNumerazioneDocumenti()
        refreshUi()
    }

    @Override void creaDettaglio(Map params) {
        trasporto = new CivTrasportoESeppellimento()
        DomainUtils.initFromAtto(trasporto, atto)
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    /**
     * TRUCCO: Metodo aggiunto per forzare ZK a leggere il trasporto anche come variabile 'dettaglio'
     * per far funzionare la controlbar
     *
     * @return il dettaglio (trasporto)
     */
    CivTrasportoESeppellimento getDettaglio() {
        return trasporto
    }

    @Command void onSalvaRecord() {
        if (dettaglio && saveRecordEnabled) {
            String msg = checkEstremiProtocollo()
            if (msg){
                Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
            Map<String, CivNumerazioneDocumentiUscita> nd = [:]
            nd.put(CivTipoRegistro.ID_TRASPORTO, numerazioneDocumentoTrasporto)
            nd.put(CivTipoRegistro.ID_SEPPELLIMENTO, numerazioneDocumentoSeppellimento)
            nd.put(CivTipoRegistro.ID_CREMAZIONE, numerazioneDocumentoCremazione)
            CivTrasportoESeppellimento c = civTrasportoESeppellimentoService.save(dettaglio, nd, atto.isCodRec0())
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            if (c) {
                caricaDettaglio(c.id)
            }
        }
    }

    @Override
    boolean isMinuscole(String campo) {
        return minuscole[campo]
    }

    void allineaTestoTrasportoMinuscole(){
        DomainUtils.allineaTestoMinuscole(trasporto, minuscole)
    }

}
