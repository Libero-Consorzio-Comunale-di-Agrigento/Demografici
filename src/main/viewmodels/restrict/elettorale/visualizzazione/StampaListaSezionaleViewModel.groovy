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
class StampaListaSezionaleViewModel extends AbstractStampaListaViewModel implements TraitCancellazioneCampi {

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
    static final int RIGHE_PER_PAGINA = 10

    Map<String, String> arcParametriListeMap

    private static final String LISTE = "LISTE"
    private static final String LETTERA_A = "A"
    private static final String LETTERA_L = "L"
    private static final String LETTERA_M = "M"
    private static final String LETTERA_Z = "Z"

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private EleElettoreListaSezionaleService eleElettoreListaSezionaleService
    @WireVariable
    private EleVistoService eleVistoService
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
        eList.add(Etichette.getEtichetta("Ultima_Pagina_AL"))


        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Stampa_Lista_Sezionale"))

        formLabel = msgTitle?.toUpperCase()

        caricaListeTimbri()
        caricaParametri()
        listaTipoLista = eleTipoListaService.findAll()

        specifiche = new SpecificheListaSezionale(
                timbriUffcioComunale1Lista.find { it.flagDefault },
                timbriUffcioComunale2Lista.find { it.flagDefault },
                timbriUffcioComunale3Lista.find { it.flagDefault },
                timbriCommissioneCircondariale1Lista.find { it.flagDefault },
                timbriCommissioneCircondariale2Lista.find { it.flagDefault },
                timbriCommissioneCircondariale3Lista.find { it.flagDefault },
                utenteCustomService.getLoggedUserUsername(),
                eleTipoListaService.findTipoListaDefault()
        )

        specifiche.timbroUffcioComunaleAL = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 8)
        specifiche.timbroUffcioComunaleMZ = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 9)
        specifiche.timbroCommissioneCircondarialeAL = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 8)
        specifiche.timbroCommissioneCircondarialeMZ = eleTimbroService.findByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 9)

    }

    private void caricaListeTimbri() {
        timbriUffcioComunale1Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 1)
        timbriUffcioComunale2Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 2)
        timbriUffcioComunale3Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.UFFICIO_COMUNALE.id, 3)

        timbriCommissioneCircondariale1Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 1)
        timbriCommissioneCircondariale2Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 2)
        timbriCommissioneCircondariale3Lista = eleTimbroService.findAllByTipoListaAndTipoAndProgressivo(ETipoLista.SEZ, ETipoTimbro.COMMISSIONE_CIRCONDARIALE.id, 3)
    }

    private void caricaParametri() {
        arcParametriListeMap = arcParametroService.mapValoreByIdLike(SqlUtils.endsLike(LISTE))
    }

    private EleTipoLista caricaTipoListaDefault() {
        return eleTipoListaService.findTipoListaDefault()
    }

    private ricaricaTipoLista(String p) {
        if (p.equals("tipoLista")) {
            specifiche.setTipoLista(caricaTipoListaDefault())
        }
    }

    @Command
    void onCancellaCampoSpecifiche(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(specifiche, p)
        ricaricaTipoLista(p)
        if(p.startsWith("sezione")) {
            onChangeSezione()
        }
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

        specifiche.timbroCommissioneCircondariale1Check = false
        specifiche.timbroCommissioneCircondariale2Check = false
        specifiche.timbroCommissioneCircondariale3Check = false
        specifiche.timbroCommissioneCircondarialeALCheck = false
        specifiche.timbroCommissioneCircondarialeMZCheck = false

        if(!paginaInizialeVisibile) {
            specifiche.paginaIniziale = null
        }

        refreshUi()
    }

    @Command
    void onCheckStampaSeggi() {
        specifiche.elezione = null
        specifiche.alfabetico = false
        specifiche.storico = false
        specifiche.filtroCognome = null
        specifiche.politiche = false
        specifiche.amministrative = false
        specifiche.referendum = false
        specifiche.paginaIniziale = null
        refreshUi()
    }

    @Command
    void onCheckAmministrative() {
        if (!specifiche.amministrative) {
            specifiche.descrizioneAmministrative = null
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
        EStatoElettore stato = null
        String cognomeDa = LETTERA_A
        String cognomeA = LETTERA_Z
        if (specifiche.stampaSeggi) {

            if (specifiche.alfabetico) {
                ordinamento = new Sort(Sort.Direction.ASC, "cognomeOrdinamento", "nomeOrdinamento")
                if (!specifiche.storico) {
                    stato = EStatoElettore.E
                }
            }

            if (specifiche.filtroCognome == EFiltroCognome.A_L) {
                cognomeA = LETTERA_L
            } else if (specifiche.filtroCognome == EFiltroCognome.M_Z) {
                cognomeDa = LETTERA_M
            }
        }


        // Crea file virtuali per ogni sezione da comprimere in ZIP
        List<ZipUtils.VirtualFile> virtualFiles = []
        Map<String, Object> parametri = [:]

        String tipoLista = specifiche.tipoLista.descrizioneBreve.replaceAll("\\.", "").replaceAll(" ", "_")
        for (int sezione = specifiche.sezioneDa; sezione <= specifiche.sezioneA; sezione++) {

            //Popolamento timbri
            List<Map<String, Object>> timbri = []
            gsdService.popolaParametriTimbriSezionali(specifiche)
            if (specifiche.stampaChiusura) {

                //Timbro A-L UC
                popolaTimbriSezionali(timbri, "UC", specifiche.timbroUffcioComunaleALCheck,
                        specifiche.timbroUffcioComunaleAL, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)

                //Timbro M-Z UC
                popolaTimbriSezionali(timbri, "UC", specifiche.timbroUffcioComunaleMZCheck,
                        specifiche.timbroUffcioComunaleMZ, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro UC1
                popolaTimbriSezionali(timbri, "UC", specifiche.timbroUffcioComunale1Check,
                        specifiche.timbroUffcioComunale1, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro UC2
                popolaTimbriSezionali(timbri, "UC", specifiche.timbroUffcioComunale2Check,
                        specifiche.timbroUffcioComunale2, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro UC3
                popolaTimbriSezionali(timbri, "UC", specifiche.timbroUffcioComunale3Check,
                        specifiche.timbroUffcioComunale3, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)

                // Timbro A-L CC
                popolaTimbriSezionali(timbri, "CC", specifiche.timbroCommissioneCircondarialeALCheck,
                        specifiche.timbroCommissioneCircondarialeAL, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro M-Z CC
                popolaTimbriSezionali(timbri, "CC", specifiche.timbroCommissioneCircondarialeMZCheck,
                        specifiche.timbroCommissioneCircondarialeMZ, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro CC1
                popolaTimbriSezionali(timbri, "CC", specifiche.timbroCommissioneCircondariale1Check,
                        specifiche.timbroCommissioneCircondariale1, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro CC2
                popolaTimbriSezionali(timbri, "CC", specifiche.timbroCommissioneCircondariale2Check,
                        specifiche.timbroCommissioneCircondariale2, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
                // Timbro CC3
                popolaTimbriSezionali(timbri, "CC", specifiche.timbroCommissioneCircondariale3Check,
                        specifiche.timbroCommissioneCircondariale3, sezione,
                        specifiche.componente, specifiche.firmaInStampa, specifiche.tipoFirma)
            }

            List<EleElettoreListaSezionaleBaseDomain> listaElettori = eleElettoreListaSezionaleService.findAllByParams(sezione, specifiche.progressivoDa, specifiche.progressivoA,
                    stato, cognomeDa, cognomeA, isSoloElettoriAttivi(),
                    specifiche.tipoLista, specifiche.amministrative, ordinamento)

            int countElettoriFromAToL = 0

            if (cognomeDa == LETTERA_M) {
                countElettoriFromAToL = eleElettoreListaSezionaleService.countElettoriByParams(sezione, specifiche.progressivoDa, specifiche.progressivoA,
                        stato, LETTERA_A, LETTERA_L, isSoloElettoriAttivi(),
                        specifiche.tipoLista, specifiche.amministrative)
            }

            if ((listaElettori == null) || (listaElettori.isEmpty())) {
                log.warn("Nessun record trovato per la generazione del PDF della sezione numero " + sezione)
                if (specifiche.sezioneDa == specifiche.sezioneA) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    return
                }
            }

            //Lista finale che conterrà elettori, eventuali righe vuote per completare la pagina, timbri
            List<Map<String, Object>> listaExport = []
            addElettoriToExportList(listaElettori, listaExport, countElettoriFromAToL)
            addRigheVuoteToExportList(listaExport, listaExport, false)
            addTimbriToExportList(timbri, listaExport)
            addRigheVuoteToExportList(listaExport, timbri, true)

            EleVisto eleVisto = eleVistoService.get()

            // Parametri generali per il report
            parametri.put("TITOLO", "${Etichette.getEtichetta('Lista_Sezionale').defaultValue}${specifiche.tipoLista.id != EleTipoListaService.ID_LISTA_ORDINARIA ? " - "+specifiche.tipoLista.descrizioneBreve : ""}".toUpperCase())
            parametri.put("STAMPA_CHIUSURA", specifiche.stampaChiusura)
            parametri.put("TIPO_PRESIDENTE_VISTO", isParamTrue(eleVisto.sottocommissione) ? "Il Presidente della S/C.E.Cir" : "Il Presidente della C.E.Cir")
            parametri.put("STAMPA_VISTO", specifiche.stampaVisto)
            parametri.put("NOME_PRESIDENTE_VISTO", specifiche.stampaVisto ? eleVisto.presidente : null)
            parametri.put("FIRMA_VISTO", getImageFirmaVisto())
            parametri.put("BOLLO_CC", getImageTimbroCC())
            parametri.put("MOSTRA_FIRMA_SEGGIO", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_FIR)))
            parametri.put("COMUNE", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_COM)) ? gsdService.getComuneCliente().getDescrizioneComune() : null)
            parametri.put("MOSTRA_MATRICOLA", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_MAT)))
            parametri.put("MOSTRA_LINEA_CANCELLAZIONE", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_ANN)))
            parametri.put("BOLLO_UC", getImageTimbroUC())
            parametri.put("MOSTRA_NUM_PAG", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PAG)))
            parametri.put("MOSTRA_PROGR_SEZ", isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PSEZ)) && specifiche.alfabetico)
            parametri.put("PAGINA_INIZIALE", specifiche.filtroCognome != EFiltroCognome.M_Z ? 1 : (isPaginaInizialeVisibile() && specifiche.paginaIniziale != null ? specifiche.paginaIniziale + 1 : (int) Math.ceil(countElettoriFromAToL / (double) RIGHE_PER_PAGINA) + 2)) // 1 pagina di timbri e 1 da cui iniziare

            // Campi necessari per il report lista_elettorale_sezionale
            List<ExportField> exportFields = []
            //Campi per elettori
            exportFields.add(new ExportField("numeroOrdine", "Numero d'ordine", ExportUtils.INTEGER_FORMAT))
            exportFields.add(new ExportField("progressivoSezionale", getEtichetta(Etichette.getEtichetta("Progressivo")), ExportUtils.INTEGER_FORMAT))
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
            exportFields.add(new ExportField("riduciFontTesto", "Riduci Font Testo", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("intestazioneFirma", "Intestazione firma", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("testoFirma1", "Testo Firma 1", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("testoFirma2", "Testo Firma 2", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("testoFirma3", "Testo Firma 3", ExportUtils.STRING_FORMAT))
            exportFields.add(new ExportField("numFirme", "Numero Firme", ExportUtils.STRING_FORMAT))

            // Crea ExportObject per la lista sezioni
            ExportObject exportObject = new ExportObject(
                    "stampa_lista_elettorale_sezionale",
                    exportFields,
                    listaExport,
                    parametri,
                    null,
                    null
            )

            // Genera il PDF per questa sezione
            log.info("Generazione PDF per sezione {}: {} record", sezione, listaExport.size())

            // Aggiungi il PDF al file virtuale per il ZIP
            String pdfFileName = "Lista_Sezionale_${tipoLista}_Sezione_${sezione}"
            if (specifiche.sezioneDa == specifiche.sezioneA) {
                InputStream exportStream = exportService.export(ETipoFile.PDF_A, exportObject)
                Filedownload.save(exportStream, ETipoFile.PDF_A.contentType, ExportService.buildFilename(pdfFileName, ETipoFile.PDF_A))
                return
            }
            virtualFiles.add(new ZipUtils.VirtualFile("${pdfFileName}.${ETipoFile.PDF.estensione}", exportService.createPdfA(exportObject)))
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
        String fileName = "Liste_Sezionali_${tipoLista}_${specifiche.sezioneDa}_${specifiche.sezioneA}.zip"
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

    static void addRigheVuoteToExportList(List<Map<String, Object>> listaExport, List<Map<String, Object>> list, Boolean isTimbro) {
        int numeroRigheUltimaPagina = list.size() % RIGHE_PER_PAGINA
        int righeVuote = isTimbro ? RIGHE_PER_PAGINA - numeroRigheUltimaPagina : (RIGHE_PER_PAGINA - numeroRigheUltimaPagina) % RIGHE_PER_PAGINA
        righeVuote.times {
            listaExport << [tipoRiga: "VUOTA"]
        }
    }

    void popolaTimbriSezionali(List<Map<String, Object>> timbri, String tipo, Boolean check, EleTimbro timbro, Integer sezione, String componente, Boolean isFirmaInStampa, ETipoFirma tipoFirma) {
        if (check) {
            String intestazioneTesto = null
            String intestazioneFirma = null
            String firma1 = null
            String firma2 = null
            String firma3 = null
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
                intestazioneTesto = timbro?.flagIntestazione ? "SOTTOCOMMISSIONE ELETTORALE CIRCONDARIALE" : null
                numFirme = 3
                firma1 = timbro?.flagFirme ? "IL PRESIDENTE" : null
                firma2 = timbro?.flagFirme ? "I COMPONENTI" : null
                firma3 = timbro?.flagFirme ? "IL SEGRETARIO" : null
            }
            String testo = gsdService.popolaTestoTimbro(timbro, "X", sezione, specifiche.tipoLista.id)
            timbri << [
                    tipoSezioneTimbro      : tipo + "_TESTO",
                    intestazioneTestoTimbro: intestazioneTesto,
                    testoTimbro            : testo,
                    riduciFontTesto        : isRiduciFontTesto(testo)
            ]
            timbri << [
                    tipoSezioneTimbro      : tipo + "_FIRMA",
                    numFirmeTimbro         : numFirme,
                    intestazioneFirmaTimbro: intestazioneFirma,
                    testoFirma1            : firma1,
                    testoFirma2            : firma2,
                    testoFirma3            : firma3
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
                        riduciFontTesto        : timbro.riduciFontTesto,
                        intestazioneFirma      : timbro.intestazioneFirmaTimbro,
                        testoFirma1            : timbro.testoFirma1,
                        testoFirma2            : timbro.testoFirma2,
                        testoFirma3            : timbro.testoFirma3,
                        numFirme               : timbro.numFirmeTimbro
                ]
            }
        }
    }

    private byte[] getImageFirmaVisto() {
        return arcParametroService.getBlobAllegatoFromId(ArcParametro.LISTE_FIR2)
    }

    private byte[] getImageTimbroUC() {
        return arcParametroService.getBlobAllegatoFromId(ArcParametro.LISTE_TIM1)
    }

    private byte[] getImageTimbroCC() {
        return arcParametroService.getBlobAllegatoFromId(ArcParametro.LISTE_TIM)
    }

    private boolean isParamTrue(String arcParam) {
        return "S".equals(arcParam)
    }

    private boolean isSoloElettoriAttivi() {
        return specifiche.stampaSeggi && specifiche.alfabetico && !specifiche.storico
    }

    static boolean isRiduciFontTesto(String testo) {
        return testo.size() > 350
    }

    boolean isPaginaInizialeVisibile() {
        return isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PAG)) &&
                isParamTrue(arcParametriListeMap.get(ArcParametro.LISTE_PAGM)) &&
                specifiche.sezioneDa != null && specifiche.sezioneA != null &&
                        specifiche.sezioneDa == specifiche.sezioneA &&
                        specifiche.filtroCognome == EFiltroCognome.M_Z
    }

    @Command
    void onChangeSezione() {
        if(!paginaInizialeVisibile) {
            specifiche.paginaIniziale = null
        }
        refreshUi()
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
