package restrict.elettorale.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.elettorale.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.BindingParam
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
import org.zkoss.zul.Window
import restrict.AbstractStampaListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaListaGeneraleViewModel extends AbstractStampaListaViewModel implements TraitCancellazioneCampi {

    SpecificheListaGenerale specifiche

    List<EleTimbro> timbriUffcioComunale1Lista
    List<EleTimbro> timbriUffcioComunale2Lista
    List<EleTimbro> timbriUffcioComunale3Lista

    List<EleTipoLista> listaTipoLista
    List<ETipoFirma> tipiFirmaList = ETipoFirma.values().toList()

    List<EleTimbro> timbriCommissioneCircondariale1Lista
    List<EleTimbro> timbriCommissioneCircondariale2Lista
    List<EleTimbro> timbriCommissioneCircondariale3Lista

    Map<String, String> arcParametriListeMap

    private static final String LISTE = "LISTE"
    private static final int RIGHE_PER_PAGINA = 10

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private EleElettoreListaGeneraleService eleElettoreListaGeneraleService
    @WireVariable
    private EleTimbroService eleTimbroService
    @WireVariable
    private UtenteCustomService utenteCustomService
    @WireVariable
    private ExportService exportService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private ArcParametroService arcParametroService
    @WireVariable
    private EleTipoListaService eleTipoListaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pdfExportEnabled = true

        caricaTipiLista()

        List<Map<String, String>> eList = [Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"), Etichette.getEtichetta("Stampa_Lista_Generale"), Etichette.getEtichetta("Nessun_record_trovato")]
        eList.addAll(SpecificheListaGenerale.etichetteDomain)
        eList.addAll(ETipoFirma.values()*.getEtichettaDesc())


        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Stampa_Lista_Generale"))

        formLabel = msgTitle?.toUpperCase()

        caricaListeTimbri()
        caricaParametri()

        specifiche = new SpecificheListaGenerale(
                timbriUffcioComunale1Lista.find { it.flagDefault },
                timbriUffcioComunale2Lista.find { it.flagDefault },
                timbriUffcioComunale3Lista.find { it.flagDefault },
                timbriCommissioneCircondariale1Lista.find { it.flagDefault },
                timbriCommissioneCircondariale2Lista.find { it.flagDefault },
                timbriCommissioneCircondariale3Lista.find { it.flagDefault },
                utenteCustomService.getLoggedUserUsername(),
                caricaTipoListaDefault()
        )

    }

    private void caricaTipiLista() {
        listaTipoLista = eleTipoListaService.findAll()
    }

    private EleTipoLista caricaTipoListaDefault() {
        return eleTipoListaService.findTipoListaDefault()
    }

    private void caricaListeTimbri() {
        timbriUffcioComunale1Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.UFFICIO_COMUNALE.id, 1)
        timbriUffcioComunale2Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.UFFICIO_COMUNALE.id, 2)
        timbriUffcioComunale3Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.UFFICIO_COMUNALE.id, 3)

        timbriCommissioneCircondariale1Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 1)
        timbriCommissioneCircondariale2Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 2)
        timbriCommissioneCircondariale3Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.GEN, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 3)
    }

    private void caricaParametri() {
        arcParametriListeMap = arcParametroService.mapValoreByIdLike(SqlUtils.endsLike(LISTE))
    }

    private ricaricaTipoLista(String p){
        if(p.equals("tipoLista")){
            specifiche.setTipoLista(caricaTipoListaDefault())
        }
    }

    @Command
    void onCancellaCampoSpecifiche(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(specifiche, p)
        ricaricaTipoLista(p)
    }

    @Command
    void onSelectElezione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        EleElezione q = null
        if (event?.target?.selectedItem instanceof EleElezione) {
            q = event.target.selectedItem
        }
        specifiche.elezione = q
        refreshUi()

    }

    @Command
    void onSelectRevisione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        EleRevisioneElettorale q = null
        if (event?.target?.selectedItem instanceof EleRevisioneElettorale) {
            q = event.target.selectedItem
        }
        specifiche.revisione = q
        refreshUi()

    }

    @Command
    void onSelectComponente(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        EleComponenteCommissione q = null
        if (event?.target?.selectedItem instanceof EleComponenteCommissione) {
            q = event.target.selectedItem
        }
        specifiche.componente = q.cognomeNome
        refreshUi()
    }

    @Command
    void onChangeComponente(@BindingParam("valore") String valore) {
        specifiche.componente = valore
        refreshUi()
    }


    void esporta(ETipoFile tipo) {
        if (tipo != ETipoFile.PDF) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Errore_Operazione_non_consentita"))
        }

        if ((specifiche.progressivoDa > specifiche.progressivoA) ||
                (specifiche. progressivoDa != null && specifiche.progressivoDa < 1) ||
                (specifiche.progressivoDa != null && specifiche.progressivoA == null) ||
                (specifiche.progressivoDa == null && specifiche.progressivoA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_Correttamente_Progressivo"))
        }

        List<EleElettoreListaBaseDomain> listaElettori = eleElettoreListaGeneraleService.findAllOrderByProgressivo(specifiche.progressivoDa, specifiche.progressivoA, specifiche.tipoLista)

        if ((listaElettori == null) || (listaElettori.isEmpty())) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        //Lista finale che conterrà elettori, eventuali righe vuote per completare la pagina, timbri
        List<Map<String, Object>> listaExport = []
        addElettoriToExportList(listaElettori, listaExport)
        addRigheVuoteToExportList(listaExport, listaExport, false)

        //Popolamento timbri
        List<Map<String, Object>> timbri = []
        gsdService.popolaParametriTimbriGenerali(specifiche)
        if (specifiche.stampaChiusura) {

            // Timbro UC1
            popolaTimbriGenerali(timbri, "UC", specifiche.timbroUffcioComunale1Check,
                    specifiche.timbroUffcioComunale1,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            // Timbro UC2
            popolaTimbriGenerali(timbri, "UC", specifiche.timbroUffcioComunale2Check,
                    specifiche.timbroUffcioComunale2,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            // Timbro UC3
            popolaTimbriGenerali(timbri, "UC", specifiche.timbroUffcioComunale3Check,
                    specifiche.timbroUffcioComunale3,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            // Timbro CC1
            popolaTimbriGenerali(timbri, "CC", specifiche.timbroCommissioneCircondariale1Check,
                    specifiche.timbroCommissioneCircondariale1,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            // Timbro CC2
            popolaTimbriGenerali(timbri, "CC", specifiche.timbroCommissioneCircondariale2Check,
                    specifiche.timbroCommissioneCircondariale2,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            // Timbro CC3
            popolaTimbriGenerali(timbri, "CC", specifiche.timbroCommissioneCircondariale3Check,
                    specifiche.timbroCommissioneCircondariale3,
                    specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            addTimbriToExportList(timbri, listaExport)
        }

        // Completamento pagina dei timbri con righe vuote se necessario
        addRigheVuoteToExportList(listaExport, timbri, true)

        // ========== POPOLAMENTO PARAMETRI e CAMPI ==========

        // Parametri generali
        Map parametri = [:]
        parametri.put("TITOLO", "${Etichette.getEtichetta('Lista_Elettorale').defaultValue}${specifiche.tipoLista.id != EleTipoListaService.ID_LISTA_ORDINARIA ? " - "+specifiche.tipoLista.descrizioneBreve : ""}".toUpperCase())
        parametri.put("COMUNE", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_COM)) ? gsdService.getComuneCliente().getDescrizioneComune() : null)
        parametri.put("MOSTRA_MATRICOLA", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_MAT)))
        parametri.put("MOSTRA_LINEA_CANCELLAZIONE", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_ANN)))
        parametri.put("BOLLO_UC", getImageTimbroUC())
        parametri.put("MOSTRA_NUM_PAG", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PAG)))

        // Campi necessari per il report JRXML lista_elettorale
        List<ExportField> exportFields = []
        //Campi per elettori
        exportFields.add(new ExportField("progressivo", getEtichetta(Etichette.getEtichetta("Progressivo")), ExportUtils.INTEGER_FORMAT))
        exportFields.add(new ExportField("anno", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.INTEGER_FORMAT))
        exportFields.add(new ExportField("fascicolo", getEtichetta(Etichette.getEtichetta("Fascicolo")), ExportUtils.NUMBER_FORMAT))
        exportFields.add(new ExportField("sezione", getEtichetta(Etichette.getEtichetta("Sezione")), ExportUtils.INTEGER_FORMAT))
        exportFields.add(new ExportField("matricola", getEtichetta(Etichette.getEtichetta("Matricola")), ExportUtils.NUMBER_FORMAT))
        exportFields.add(new ExportField("cognomeNome", getEtichetta(Etichette.getEtichetta("Cognome_Nome")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("luogoDataNascita", getEtichetta(Etichette.getEtichetta("Luogo_Nascita")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("atto", getEtichetta(Etichette.getEtichetta("Atto")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("tribunale", getEtichetta(Etichette.getEtichetta("Tribunale")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("indirizzo", getEtichetta(Etichette.getEtichetta("Indirizzo")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("stato", getEtichetta(Etichette.getEtichetta("Stato")), ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("emigrato", "Emigrato", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("motivo1", "Motivo 1", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("motivo2", "Motivo 2", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("verbale1", "Verbale 1", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("verbale2", "Verbale 2", ExportUtils.STRING_FORMAT))
        //Campi per timbri
        exportFields.add(new ExportField("tipoRiga", "Tipo Riga", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("tipoSezioneTimbro", "Tipo Sezione Timbro", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("intestazioneTestoTimbro", "Intestazione Timbro", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("testoTimbro", "Testo Timbro", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("intestazioneFirma", "Intestazione firma", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("testoFirma1", "Testo Firma 1", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("testoFirma2", "Testo Firma 2", ExportUtils.STRING_FORMAT))
        exportFields.add(new ExportField("numFirme", "Numero Firme", ExportUtils.STRING_FORMAT))

        String tipoLista = specifiche.tipoLista.descrizioneBreve.replaceAll("\\.", "").replaceAll(" ", "_")
        StringBuilder filename = new StringBuilder("Lista_Generale_${tipoLista}${specifiche.progressivoDa ? "_" + specifiche.progressivoDa + "_" + specifiche.progressivoA : ''}")

        ExportObject eo = new ExportObject("stampa_lista_elettorale_generale", exportFields, listaExport, parametri, null, null)

        InputStream exportStream = exportService.export(ETipoFile.PDF_A, eo)
        Filedownload.save(exportStream, ETipoFile.PDF_A.contentType, ExportService.buildFilename(filename.toString(), ETipoFile.PDF_A))

    }

    static void addElettoriToExportList(List<EleElettoreListaBaseDomain> listaElettori, List<Map<String, Object>> listaExport) {
        listaElettori.each { elettore ->
            listaExport << [
                    tipoRiga        : "ELETTORE",
                    progressivo     : elettore.progressivo,
                    anno            : elettore.anno,
                    fascicolo       : elettore.fascicolo,
                    sezione         : elettore.sezione,
                    matricola       : elettore.matricola,
                    cognomeNome     : JasperReportUtils.sanitizeXml(elettore.cognomeNome),
                    luogoDataNascita: JasperReportUtils.sanitizeXml(elettore.luogoDataNascita),
                    atto            : JasperReportUtils.sanitizeXml(elettore.atto),
                    tribunale       : JasperReportUtils.sanitizeXml(elettore.tribunale),
                    indirizzo       : JasperReportUtils.sanitizeXml(elettore.indirizzo),
                    stato           : elettore.stato.getId(),
                    emigrato        : JasperReportUtils.sanitizeXml(elettore.emigrato),
                    motivo1         : JasperReportUtils.sanitizeXml(elettore.motivo1),
                    motivo2         : JasperReportUtils.sanitizeXml(elettore.motivo2),
                    verbale1        : JasperReportUtils.sanitizeXml(elettore.verbale1),
                    verbale2        : JasperReportUtils.sanitizeXml(elettore.verbale2)
            ]
        }
    }

    static void addRigheVuoteToExportList(List<Map<String, Object>> listaExport, List<Map<String, Object>> list, Boolean isTimbro) {
        int numeroRigheUltimaPagina = list.size() % RIGHE_PER_PAGINA
        int righeVuote = isTimbro ? RIGHE_PER_PAGINA - numeroRigheUltimaPagina : (RIGHE_PER_PAGINA - numeroRigheUltimaPagina) % RIGHE_PER_PAGINA
        righeVuote.times {
            listaExport << [tipoRiga: "VUOTA"]
        }
    }

    void popolaTimbriGenerali(List<Map<String, Object>> timbri, String tipo, Boolean check, EleTimbro timbro, String componente, Boolean isFirmaInStampa, ETipoFirma tipoFirma) {
        if (check) {
            String intestazioneTesto = null
            String intestazioneFirma = null
            String firma1 = null
            String firma2 = null
            int numFirme = 0
            if (tipo == "UC") {
                intestazioneTesto = timbro?.flagIntestazione ? "UFFICIO ELETTORALE COMUNALE" : null
                if (timbro?.flagFirme) {
                    intestazioneFirma = tipoFirma.getIntestazioneFirma()
                    if (tipoFirma == ETipoFirma.CEC) {
                        numFirme = 2
                        firma1 = "IL PRESIDENTE"
                        firma2 = "IL SEGRETARIO"
                    } else if (isFirmaInStampa) {
                        numFirme = 1
                        firma1 = componente
                        firma2 = null
                    }
                }
            } else if (tipo == "CC") {
                intestazioneTesto = timbro?.flagIntestazione ? "COMMISSIONE ELETTORALE CIRCONDARIALE" : null
                numFirme = 2
                firma1 = timbro?.flagFirme ? "IL PRESIDENTE" : null
                firma2 = timbro?.flagFirme ? "IL SEGRETARIO" : null
            }
            String testo = gsdService.popolaTestoTimbro(timbro, "X", null, specifiche.tipoLista.id)
            timbri << [
                    tipoSezioneTimbro      : tipo + "_TESTO",
                    intestazioneTestoTimbro: intestazioneTesto,
                    testoTimbro            : testo]
            timbri << [
                    tipoSezioneTimbro      : tipo + "_FIRMA",
                    numFirmeTimbro         : numFirme,
                    intestazioneFirmaTimbro: intestazioneFirma,
                    testoFirma1            : firma1,
                    testoFirma2            : firma2]
        }
    }

    static void addTimbriToExportList(List<Map<String, String>> timbri, List<Map<String, Object>> listaExport) {
        if (timbri != null) {
            timbri.each { timbro ->
                listaExport << [
                        tipoRiga               : "TIMBRO",
                        tipoSezioneTimbro      : timbro.tipoSezioneTimbro,
                        intestazioneTestoTimbro: timbro.intestazioneTestoTimbro,
                        testoTimbro            : timbro.testoTimbro,
                        intestazioneFirma      : timbro.intestazioneFirmaTimbro,
                        testoFirma1            : timbro.testoFirma1,
                        testoFirma2            : timbro.testoFirma2,
                        numFirme               : timbro.numFirmeTimbro
                ]
            }
        }
    }

    private byte[] getImageTimbroUC() {
        return arcParametroService.getBlobAllegatoFromId(ArcParametro.LISTE_TIM1)
    }

    private boolean isParamTrue(String arcParam) {
        return "S".equals(arcParam)
    }

    @Override
    IRicerca getRicerca() {
        return null
    }

    @Override
    void caricaLista() {

    }

    @Override
    Paginazione eseguiQuery(Boolean usePaging) {
        return null
    }

    @Override
    Object getDettaglio() {
        return specifiche
    }
}