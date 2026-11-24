package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.EmptyReportException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.StampaAttoProvvisorioException
import it.finmatica.de4gsdzk.export.JasperExporter
import it.finmatica.de4gsdzk.export.ReportExportResult
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.gestionetesti.GestioneTestiService
import net.sf.jasperreports.engine.JREmptyDataSource
import org.apache.commons.io.FilenameUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.zkoss.zhtml.Filedownload

import java.nio.charset.StandardCharsets

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@Transactional
@Service
class StampaAttoService {

    private final CivTipoAttoService civTipoAttoService

    private final CivFascicoloAttoService civFascicoloAttoService

    private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    private final JasperReportService jasperReportService

    private final GsdFirmaService gsdFirmaService

    private final CivTestoLiberoService civTestoLiberoService

    private final CivMargineService civMargineService

    private final CivOcchielloService civOcchielloService

    private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

    private final CivAnnotazioneAttoService civAnnotazioneAttoService

    private final GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    private final GestioneTestiService gestioneTestiService

    private final ArcParametroService arcParametroService

    private final GsdMenuDittaService gsdMenuDittaService

    private final GsdService gsdService

    StampaAttoService(JasperReportService jasperReportService, GsdService gsdService, GsdMenuDittaService gsdMenuDittaService,
                      CivTipoAttoService civTipoAttoService, GsdFirmaService gsdFirmaService, ArcParametroService arcParametroService,
                      CivTestoLiberoService civTestoLiberoService, CivMargineService civMargineService, CivOcchielloService civOcchielloService,
                      CivFormulaTestoLiberoService civFormulaTestoLiberoService, CivAnnotazioneAttoService civAnnotazioneAttoService,
                      CivFascicoloAttoService civFascicoloAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService,
                      GestioneTestiGsdModelloService gestioneTestiGsdModelloService, GestioneTestiService gestioneTestiService) {
        this.jasperReportService = jasperReportService
        this.gsdService = gsdService
        this.gsdMenuDittaService = gsdMenuDittaService
        this.civTipoAttoService = civTipoAttoService
        this.gsdFirmaService = gsdFirmaService
        this.arcParametroService = arcParametroService
        this.civTestoLiberoService = civTestoLiberoService
        this.civMargineService = civMargineService
        this.civOcchielloService = civOcchielloService
        this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
        this.civAnnotazioneAttoService = civAnnotazioneAttoService
        this.civFascicoloAttoService = civFascicoloAttoService
        this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
        this.gestioneTestiGsdModelloService = gestioneTestiGsdModelloService
        this.gestioneTestiService = gestioneTestiService
    }

    JasperExporter generaReportAtto(CivAttoBaseDomain atto, CivTestoLibero tli, CivMargine mar, CivOcchiello occ,
                                    List<CivFormulaTestoLibero> formuleMargine, List<CivAnnotazioneAtto> formuleAnnotazioni,
                                    Map<String, String> etichette, Map baseOptions) throws Exception {
        String reportName = "stampa_atto_A4"
        if ( (atto.getTipoAttoEnum() == ETipoAtto.PUB) || (atto.getTipoAttoEnum() == ETipoAtto.PVU) ){
            reportName = "stampa_PubPvu_A4"
        }
        if (atto.isProvvisorio()) {
            throw new StampaAttoProvvisorioException(Etichette.getEtichetta("Errore_stampa_provvisorio"))
        }

        Boolean anscOn = Boolean.FALSE
        Boolean anscInt = Boolean.FALSE
        Boolean corniceOn = Boolean.TRUE
        Boolean margineOn = Boolean.TRUE
        List<ArcParametro> lParams = arcParametroService.listAllByIdIn([ArcParametro.ANSC,
                                                                        ArcParametro.ANSC_INT,
                                                                        ArcParametro.ATTI_A4_FR,
                                                                        ArcParametro.ATTI_MAR])
        for (ArcParametro p: lParams){
            switch(p.id) {
                case ArcParametro.ANSC:
                    anscOn = (p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name())
                    break
                case ArcParametro.ANSC_INT:
                    anscInt = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    break
                case ArcParametro.ATTI_A4_FR:
                    corniceOn = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    break
                case ArcParametro.ATTI_MAR:
                    margineOn = ((p?.valore?.trim()?.toUpperCase() ?: ETipoSN.S.name()) != ETipoSN.N.name())
                    break
            }
        }

        CivMargine margine = null
        if (atto.hasMargine()){
            margine = mar
            if (mar == null){
                margine = civMargineService.getByUkAtto(atto.idAtto)
            }
        }
        int mirror = 0
        if (margineOn) {
            mirror = margine?.isMargineSinistro() ? 1 : 0
        }
        baseOptions.put(JasperReportUtils.OPTION_MIRROR_LAYOUT, mirror)
        baseOptions.put(JasperReportUtils.OPTION_MIRROR_EXCLUDED, [[tipo: "image", delta: -15]])

        CivOcchiello occhiello = occ
        if ( (occ == null) && (atto.getTipoAttoEnum() != ETipoAtto.PUB) && (atto.getTipoAttoEnum() != ETipoAtto.PVU)){
            occhiello = civOcchielloService.getByUkAtto(atto.idAtto)
        }

        Boolean anscIntestazioneOn = (anscOn && anscInt)
        GsdMenuDitta md = gsdMenuDittaService.getUniqueRecord()

        Map<String, ?> attoParams = [
                ID              : atto.id,
                TIPO_ATTO       : atto.tipoAtto,
                CODICE_TIPO_ATTO: atto.getTipoAttoEnum().name(),
                ESTREMI_ATTO    : TestoUtils.getDescrizioneAtto(atto, etichette, md?.id, anscIntestazioneOn),//TODO: estrarlo nella query del report (e spostarlo in noDataSourceParams)
                LABEL_COGNOME   : getEtichetta(etichette, Etichette.getEtichetta("Cognome")),
                LABEL_NOME      : getEtichetta(etichette, Etichette.getEtichetta("Nome")),
                LABEL_SESSO     : getEtichetta(etichette, Etichette.getEtichetta("Sesso"))
        ]

        Map<String, ?> noDataSourceParams = [:]

        if (baseOptions.get(JasperReportUtils.OPTION_DATASOURCE) instanceof JREmptyDataSource) {
            CivTestoLibero testoLibero = tli
            if (tli == null){
                testoLibero = civTestoLiberoService.getByUkAtto(atto.idAtto)
            }
            if (testoLibero == null){
                throw new EmptyReportException(Etichette.getEtichetta("Errore_testo_atto"))
            }

            List<CivFormulaTestoLibero> formuleMargineLista = formuleMargine
            if ( (formuleMargine == null) || formuleMargine.isEmpty() ){
                formuleMargineLista = civFormulaTestoLiberoService.listAllByUKAttoAndRichiamo(atto.idAtto, FormulaUtils.getRichiamoMargine())
            }

            List<CivAnnotazioneAtto> formuleAnnotazioniLista = formuleAnnotazioni
            if ( (formuleAnnotazioni == null) || formuleAnnotazioni.isEmpty() ){
                formuleAnnotazioniLista = civAnnotazioneAttoService.listAllByUkAttoAndStatoAndStampaSuAtto(atto.idAtto, EStatoAnnotazione.E, Boolean.TRUE)
            }

            StringBuilder testoCompleto = new StringBuilder((testoLibero.testo?:""))

            for (CivFormulaTestoLibero f : formuleMargineLista){
                // refs #65653
                if ((f.testo?:"") != ""){
                    testoCompleto.append(TestoUtils.aCapo)
                    testoCompleto.append(f.testo)
                }
            }

            for (CivAnnotazioneAtto f : formuleAnnotazioniLista){
                // refs #65653
                if ((f.testoAtto?:"") != "") {
                    testoCompleto.append(TestoUtils.aCapo)
                    testoCompleto.append(f.testoAtto)
                }
            }

            String testoIntestazioneCia = ""
            String testoCia = ""
            String testoFirmaCia = ""
            InputStream ciaIs = null
            if (baseOptions.cia) {
                testoIntestazioneCia = gsdService.decodificaTestoFormulaCia(ETipoFormulaAggiuntiva.CIA_INT, atto)
                testoCia = gsdService.decodificaTestoFormulaCia(ETipoFormulaAggiuntiva.CIA_TXT, atto)
                testoFirmaCia = gsdService.decodificaTestoFormulaCia(ETipoFormulaAggiuntiva.CIA_FIR, atto)
                ArcParametro logoCia = arcParametroService.get(ArcParametro.LOGO_SCIA)
                if (logoCia.blobAllegato){
                    ciaIs = new ByteArrayInputStream(logoCia.blobAllegato)
                }
            }

            noDataSourceParams = [
                    TESTO            : testoCompleto,
                    COGNOME          : (occhiello?.cognome?:""),
                    NOME             : (occhiello?.nome?:""),
                    SESSO            : (occhiello?.descrizioneSesso?:""),
                    COGNOME_CONIUGE  : (occhiello?.cognomeConiuge?:""),
                    NOME_CONIUGE     : (occhiello?.nomeConiuge?:""),
                    STATO            : (occhiello?.descrizioneStatoNascita?:""),
                    CORNICE_VISIBILE : corniceOn,
                    CIA_VISIBILE     : baseOptions.cia,
                    TESTO_INT_CIA    : testoIntestazioneCia,
                    TESTO_CIA        : testoCia,
                    TESTO_FIRMA_CIA  : testoFirmaCia,
                    LOGO_CIA         : ciaIs,
                    CAMPO1_LUNGO     : ((occhiello?.cognome?:"").length()>TestoUtils.maxGeneralitaLength?"COGNOME":((occhiello?.nome?:"").length()>TestoUtils.maxGeneralitaLength?"NOME":"")),
                    CAMPO2_LUNGO     : ((occhiello?.cognomeConiuge?:"").length()>TestoUtils.maxGeneralitaLength?"COGNOME_CONIUGE":((occhiello?.nomeConiuge?:"").length()>TestoUtils.maxGeneralitaLength?"NOME_CONIUGE":""))
            ]
        }

        Map params = [:]
        params.putAll(attoParams)
        params.putAll(noDataSourceParams)

        return jasperReportService.buildReport(reportName, params, baseOptions)
    }

    ReportExportResult downloadReportAtto(CivAttoBaseDomain atto, CivTestoLibero tli, CivMargine mar, CivOcchiello occ,
                                          List<CivFormulaTestoLibero> formuleMargine, List<CivAnnotazioneAtto> formuleAnnotazioni,
                                          Map<String, String> etichette, Map baseOptions) throws Exception {

        JasperExporter exporter = generaReportAtto(atto, tli, mar, occ, formuleMargine, formuleAnnotazioni, etichette, baseOptions)
        InputStream is = exporter.exportStream()

        String nomeFile = TestoUtils.getNomeReportAtto(atto, baseOptions.cia)

        ReportExportResult res = new ReportExportResult(exporter.getPages())

        if (baseOptions.fascicola){
            if (atto.tipoAttoDomain?.id != null) {
                CivTipoAtto ta = civTipoAttoService.get(atto.tipoAttoDomain.id)
                if (ta.tipoDocumentoFascicoloCia) {
                    CivFascicoloAtto fa = civFascicoloAttoService.createWhereNotExists(atto, ta.tipoDocumentoFascicoloCia)
                    String nomeFileBase = FilenameUtils.removeExtension(nomeFile)
                    Integer nAlle = new Integer(0)
                    if (fa.id != null) {
                        nAlle = (civFascicoloAttoAllegatoService.getNumAllegatiFascicoloByNomeLike(fa.id, null, SqlUtils.endsLike(nomeFileBase))?:new Integer(0))
                    }
                    ++nAlle
                    // Gestione nome file univoco
                    nomeFile = nomeFileBase + "_" + nAlle.toString() + "." + FilenameUtils.getExtension(nomeFile)
                    CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.create(fa, nomeFile)
                    CivFascicoloAttoAllegato falSaved = civFascicoloAttoAllegatoService.save(fal, Boolean.TRUE, is)
                    gsdFirmaService.scaricaAllegato(falSaved.fascicoloAtto, falSaved, false, false)
                    res.errorCode = 0
                } else {
                    Filedownload.save(is, ETipoFile.PDF.contentType, nomeFile)
                    log.warn("Impossibile fascicolare la cia: l'atto non ha fk verso CIVDDO")
                    res.errorCode = 2
                }
            } else {
                log.warn("Impossibile fascicolare la cia: l'atto non ha fk verso CIVDTA")
                res.errorCode = 1
            }
        } else {
            Filedownload.save(is, ETipoFile.PDF.contentType, nomeFile)
        }

        return res
    }

    void downloadEtichetta(String formatoReport, CivAnnotazioneAtto annotazioneAtto, CivAttoBaseDomain atto) {
        String dataFirma = arcParametroService.getGestioneDataFirmaEtichettaAnnotazione()
        String attiLi = ""
        if (atto?.natura == ENaturaAtto.O) {
            attiLi = arcParametroService.getAttiLi()
        }

        String dataReg = DataUtils.fromDateToString(annotazioneAtto.dataRegistrazione)?:"__________"

        if (formatoReport == TestoUtils.formatoCustom){
            // genero la stampa e faccio download
            GestioneTestiGsdModello g = gestioneTestiGsdModelloService.getByAmbitoEtichetta()
            if (g){
                Map<String, ?> parametriQuery =  ["idAnnotazione" : annotazioneAtto.id, "testo": annotazioneAtto.testo,
                                                  "attiLi": attiLi, "dataRegistrazione": dataReg]
                String queryModello = new String (g.tipoModello.query)
                String formato = (g.formatoTesto?.name()?:g.tipo).toLowerCase()
                String nomeFile = "${g.descrizione}.${formato}"
                ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
                InputStream is = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true, StandardCharsets.UTF_8)
                byte[] allegato = is.getBytes()
                Filedownload.save(allegato, FileUtils.getMimeType(formato), nomeFile)
                is.close()
            } else {
                throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Errore_modello_etichetta_non_trovato"))
            }
        } else {
            String testo = TestoUtils.getTestoEtichettaCompleto(annotazioneAtto, formatoReport, dataFirma, attiLi, dataReg)
            Map optionParams = [dataSource: new JREmptyDataSource()]
            jasperReportService.downloadReport("etichetta_" + formatoReport, "etichetta", [ID: annotazioneAtto.id, TESTO: testo], optionParams)
        }
    }

}
