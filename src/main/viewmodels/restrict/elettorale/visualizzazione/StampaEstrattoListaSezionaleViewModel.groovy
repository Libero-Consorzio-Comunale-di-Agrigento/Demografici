package restrict.elettorale.visualizzazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.elettorale.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
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
class StampaEstrattoListaSezionaleViewModel extends AbstractStampaListaViewModel implements TraitCancellazioneCampi {

    SpecificheListaSezionale specifiche

    List<EFiltroCognome> filtriCognomeList = [null] + EFiltroCognome.values().toList()

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
    private static final String LETTERA_A = "A"
    private static final String LETTERA_L = "L"
    private static final String LETTERA_M = "M"
    private static final String LETTERA_Z = "Z"

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private EleElettoreEstrattoListaSezionaleService eleElettoreEstrattoListaSezionaleService
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
    @WireVariable
    private EleSezioneService eleSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pdfExportEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Stampa_Lista_Sezionale"), Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Nessun_record_trovato")]
        eList.addAll(SpecificheListaSezionale.etichetteDomain)
        eList.addAll(ETipoFirma.values()*.getEtichettaDesc())
        eList.addAll(EFiltroCognome.values()*.getEtichettaDesc())


        doInit(eList)

        msgTitle = "Stampa Estratto Lista Sezionale"

        formLabel = msgTitle?.toUpperCase()

        caricaListeTimbri()
        caricaParametri()
        listaTipoLista = eleTipoListaService.findAll()

        specifiche = new SpecificheListaSezionale(
                timbriUffcioComunale1Lista.find { it.flagDefaultEstratto },
                timbriUffcioComunale2Lista.find { it.flagDefaultEstratto },
                timbriUffcioComunale3Lista.find { it.flagDefaultEstratto },
                timbriCommissioneCircondariale1Lista.find { it.flagDefaultEstratto },
                timbriCommissioneCircondariale2Lista.find { it.flagDefaultEstratto },
                timbriCommissioneCircondariale3Lista.find { it.flagDefaultEstratto },
                utenteCustomService.getLoggedUserUsername(),
                eleTipoListaService.findTipoListaDefault()
        )

        specifiche.stampaSeggi = true
        specifiche.timbroUffcioComunaleAL = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 8)
        specifiche.timbroUffcioComunaleMZ = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 9)
        specifiche.timbroCommissioneCircondarialeAL = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 8)
        specifiche.timbroCommissioneCircondarialeMZ = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 9)

    }

    private void caricaListeTimbri() {
        timbriUffcioComunale1Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 1)
        timbriUffcioComunale2Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 2)
        timbriUffcioComunale3Lista = eleTimbroService.findAllByTipoListaAndTipoAndFlagDefaultEstrattoIsTrue(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id)
    }

    private void caricaParametri() {
        arcParametriListeMap = arcParametroService.mapValoreByIdLike(SqlUtils.endsLike(LISTE))
    }

    private EleTipoLista caricaTipoListaDefault() {
        return eleTipoListaService.findTipoListaDefault()
    }

    private ricaricaTipoLista(String p) {
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

    @Command
    void azzeraCheck() {
        specifiche.timbroUffcioComunale1Check = false
        specifiche.timbroUffcioComunale2Check = false
        specifiche.timbroUffcioComunale3Check = false
        specifiche.timbroUffcioComunaleALCheck = false
        specifiche.timbroUffcioComunaleMZCheck = false

        refreshUi()
    }

    @Command
    void onCheckAmministrative() {
        if(!specifiche.amministrative) {
            specifiche.descrizioneAmministrative = null
        }
        refreshUi()
    }

    @Command
    void onCheckAlfabetico() {
        if(!specifiche.alfabetico) {
            specifiche.depennati = null
        }
        refreshUi()
    }

    void esporta(ETipoFile tipo) {
        if (tipo != ETipoFile.PDF) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Errore_Operazione_non_consentita"))
        }

        if ((specifiche.sezioneDa > specifiche.sezioneA) ||
                (specifiche.sezioneDa != null && specifiche.sezioneA == null) ||
                (specifiche.sezioneDa == null && specifiche.sezioneA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_Correttamente_Sezione"))
        }

        if ((specifiche.progressivoDa > specifiche.progressivoA) ||
                (specifiche. progressivoDa != null && specifiche.progressivoDa < 1) ||
                (specifiche.progressivoDa != null && specifiche.progressivoA == null) ||
                (specifiche.progressivoDa == null && specifiche.progressivoA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_Correttamente_Progressivo"))
        }

        if(specifiche.stampaSeggi && specifiche.elezione == null) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori)
        }

        int sezioneMax = eleSezioneService.getSezioneMax()
        if (specifiche.sezioneDa == null) {
            specifiche.sezioneDa = eleSezioneService.getSezioneMin()
            specifiche.sezioneA = sezioneMax
        } else {
            specifiche.sezioneA = specifiche.sezioneA > sezioneMax ? sezioneMax : specifiche.sezioneA
        }

        Sort ordinamento = new Sort(Sort.Direction.ASC, "progressivoSezionale")
        EStatoElettore stato = EStatoElettore.E
        String cognomeDa = LETTERA_A
        String cognomeA = LETTERA_Z
        if (specifiche.stampaSeggi) {

            if (specifiche.alfabetico) {
                ordinamento = new Sort(Sort.Direction.ASC, "cognomeOrdinamento", "nomeOrdinamento")
            }

            if (specifiche.filtroCognome == EFiltroCognome.A_L) {
                cognomeA = LETTERA_L
            } else if (specifiche.filtroCognome == EFiltroCognome.M_Z) {
                cognomeDa = LETTERA_M
            }
        }

        gsdService.popolaParametriTimbriSezionaliEstratto(specifiche)

        // Crea file virtuali per ogni sezione da comprimere in ZIP
        List<ZipUtils.VirtualFile> virtualFiles = []
        Map<String, Object> parametri = [:]

        String tipoLista = specifiche.tipoLista.descrizioneBreve.replaceAll("\\.", "").replaceAll(" ", "_")
        for (int sezione = specifiche.sezioneDa; sezione <= specifiche.sezioneA; sezione++) {

            //Popolamento timbri
            List<Map<String, Object>> timbri = []
            if (specifiche.stampaChiusura) {
                // Timbro UC3
                popolaTimbroEstrattoListaSezionale(timbri, "UC", specifiche.timbroUffcioComunale3Check,
                        specifiche.timbroUffcioComunale3, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            }

            List<EleElettoreListaSezionaleBaseDomain> listaElettori = eleElettoreEstrattoListaSezionaleService.findAllByParams(sezione, specifiche.progressivoDa, specifiche.progressivoA,
                    stato, cognomeDa, cognomeA, isSoloElettoriAttivi(),
                    specifiche.tipoLista, specifiche.amministrative, ordinamento)

            int countElettoriFromAToL = 0

            if (cognomeDa == LETTERA_M) {
                countElettoriFromAToL = eleElettoreEstrattoListaSezionaleService.countElettoriByParams(sezione, specifiche.progressivoDa, specifiche.progressivoA,
                        stato, LETTERA_A, LETTERA_L, isSoloElettoriAttivi(),
                        specifiche.tipoLista, specifiche.amministrative)
            }

            if ((listaElettori == null) || (listaElettori.isEmpty())) {
                log.warn("Nessun record trovato per la generazione del PDF della sezione numero " + sezione)
                if (specifiche.sezioneDa == specifiche.sezioneA) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    return
                }
                continue
            }

            //Lista finale che conterrà elettori, eventuali righe vuote per completare la pagina, timbri
            List<Map<String, Object>> listaExport = []
            addElettoriToExportList(listaElettori, listaExport, countElettoriFromAToL)
            addTimbriToExportList(timbri, listaExport)

            // Parametri generali per il report
            parametri.put("TITOLO", "Stampa Estratto Liste Sezionali")
            parametri.put("STAMPA_CHIUSURA", specifiche.stampaChiusura)
            parametri.put("COMUNE", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_COM)) ? gsdService.getComuneCliente().getDescrizioneComune() : null)
            parametri.put("MOSTRA_NUM_PAG", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PAG)))
            parametri.put("label_progressivoSezionale", "Progr.")
            parametri.put("label_cognomeNome", "Cognome Nome")
            parametri.put("label_indirizzo", "Indirizzo")
            parametri.put("label_luogoDataNascita", "Data e Luogo di Nascita")
            parametri.put("label_annotazioni", "Annotazioni")
            parametri.put("label_sezione", "SEZIONE N. ")
            parametri.put("SEZIONE", sezione)
            parametri.put("TOTAL_ELETTORI", listaElettori.size())
            parametri.put("ALFABETICO", specifiche.alfabetico)

            // Campi necessari per il report lista_elettorale_sezionale
            List<ExportField> exportFields = []
            //Campi per elettori
            exportFields.add(new ExportField("numeroOrdine", "Numero d'ordine", ExportUtils.INTEGER_FORMAT))
            exportFields.add(new ExportField("progressivoSezionale", getEtichetta(Etichette.getEtichetta("Progressivo")), ExportUtils.INTEGER_FORMAT))
            exportFields.add(new ExportField("progressivo", getEtichetta(Etichette.getEtichetta("Progressivo")), ExportUtils.INTEGER_FORMAT))
            exportFields.add(new ExportField("sezione", getEtichetta(Etichette.getEtichetta("Sezione")), ExportUtils.INTEGER_FORMAT))
            exportFields.add(new ExportField("cognomeNome", getEtichetta(Etichette.getEtichetta("Cognome_Nome")), ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("luogoDataNascita", getEtichetta(Etichette.getEtichetta("Luogo_Nascita")), ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("indirizzo", getEtichetta(Etichette.getEtichetta("Indirizzo")), ExportUtils.STRING_FORMAT))
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
            exportFields.add(new ExportField("testoFirma3", "Testo Firma 3", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("numFirme", "Numero Firme", ExportUtils.STRING_FORMAT))

            // Crea ExportObject per la lista sezioni
            ExportObject exportObject = new ExportObject(
                    "stampa_estratto_liste_elettorali",
                    exportFields,
                    listaExport,
                    parametri,
                    null,
                    null
            )

            // Genera il PDF per questa sezione
            log.info("Generazione PDF per sezione {}: {} record", sezione, listaExport.size())

            // Aggiungi il PDF al file virtuale per il ZIP
            String pdfFileName = "Estratto_Sezionale_${tipoLista}_Sezione_${sezione}"
            if (specifiche.sezioneDa == specifiche.sezioneA) {
                InputStream exportStream = exportService.export(ETipoFile.PDF_A, exportObject)
                Filedownload.save(exportStream, ETipoFile.PDF_A.contentType, ExportService.buildFilename(pdfFileName, ETipoFile.PDF_A))
                return
            }
            virtualFiles.add(new ZipUtils.VirtualFile(pdfFileName + "." + ETipoFile.PDF.estensione, exportService.createPdfA(exportObject)))
            log.info("PDF sezione {} aggiunto al ZIP", sezione)
        }

        if (virtualFiles.isEmpty()) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        // Comprimi tutti i PDF in un unico ZIP
        log.info("Compressione di {} file PDF in ZIP", virtualFiles.size())
        byte[] zipContent = ZipUtils.zipFiles(virtualFiles)
        String contentType = FileUtils.getMimeType("zip")

        // Scarica il ZIP nel browser
        String fileName = "Estratto_Sezionali_${tipoLista}_${specifiche.sezioneDa}_${specifiche.sezioneA}.zip"
        Filedownload.save(zipContent, contentType, fileName)

    }

    static void addElettoriToExportList(List<EleElettoreListaSezionaleBaseDomain> listaElettori, List<Map<String, Object>> listaExport, int countElettoriFromAToL) {
        int count = 0
        listaElettori.each { elettore ->
            listaExport << [
                    tipoRiga            : "ELETTORE",
                    numeroOrdine        : count + 1 + countElettoriFromAToL,
                    progressivoSezionale: elettore.progressivoSezionale?.toString() ?: "",
                    progressivo         : elettore.progressivo?.toString() ?: "",
                    anno                : elettore.anno?.toString() ?: "",
                    fascicolo           : elettore.fascicolo?.toString() ?: "",
                    sezione             : elettore.sezione?.toString() ?: "",
                    matricola           : elettore.getMatricola()?.toString() ?: "",
                    cognomeNome         : JasperReportUtils.sanitizeXml(elettore.cognomeNome) ?: "",
                    luogoDataNascita    : JasperReportUtils.sanitizeXml(elettore.luogoDataNascita) ?: "",
                    atto                : JasperReportUtils.sanitizeXml(elettore.atto?.toString()) ?: "",
                    tribunale           : JasperReportUtils.sanitizeXml(elettore.tribunale) ?: "",
                    indirizzo           : JasperReportUtils.sanitizeXml(elettore.indirizzo) ?: "",
                    stato               : elettore.stato.getId(),
                    emigrato            : JasperReportUtils.sanitizeXml(elettore.emigrato),
                    motivo1             : JasperReportUtils.sanitizeXml(elettore.motivo1),
                    motivo2             : JasperReportUtils.sanitizeXml(elettore.motivo2),
                    verbale1            : JasperReportUtils.sanitizeXml(elettore.verbale1),
                    verbale2            : JasperReportUtils.sanitizeXml(elettore.verbale2)
            ]
            count++
        }
    }

    void popolaTimbroEstrattoListaSezionale(List<Map<String, Object>> timbri, String tipo, Boolean check, EleTimbro timbro, Integer sezione, String componente, Boolean isFirmaInStampa, ETipoFirma tipoFirma) {
        if (check) {
            String intestazioneFirma = null
            String firma1 = null
            String firma2 = null
            int numFirme = 0
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
            String testo = gsdService.popolaTestoTimbro(timbro, "X", sezione, specifiche.tipoLista.id)
            timbri << [
                    testoTimbro            : testo,
                    numFirmeTimbro         : numFirme,
                    intestazioneFirmaTimbro: intestazioneFirma,
                    testoFirma1            : firma1,
                    testoFirma2            : firma2
            ]
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
                        testoFirma3            : timbro.testoFirma3,
                        numFirme               : timbro.numFirmeTimbro
                ]
            }
        }
    }

    private boolean isParamTrue(String arcParam) {
        return "S".equals(arcParam)
    }

    private boolean isSoloElettoriAttivi() {
        return specifiche.stampaSeggi && specifiche.alfabetico && !specifiche.depennati
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
