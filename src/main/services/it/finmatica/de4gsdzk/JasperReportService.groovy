package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.confapps.ConfappsEnvPostProcessor
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.EmptyReportException
import it.finmatica.de4gsdzk.errors.MultiplePagesException
import it.finmatica.de4gsdzk.export.JasperExporter
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.JasperReportUtils
import net.sf.jasperreports.engine.JRDataSource
import net.sf.jasperreports.engine.JasperFillManager
import net.sf.jasperreports.engine.JasperPrint
import net.sf.jasperreports.engine.JasperReport
import net.sf.jasperreports.engine.util.JRLoader
import org.springframework.core.env.Environment
import org.springframework.core.io.FileSystemResource
import org.springframework.core.io.Resource
import org.springframework.stereotype.Service
import org.zkoss.zhtml.Filedownload

import javax.sql.DataSource
import java.sql.Connection

@Slf4j
@Service
class JasperReportService {

    // directory in cui si trovano i report
    private static final String REPORT_DIR = "WEB-INF"+ File.separator + "reports"
    private static final String APP_DIR = "de4gsdzk"

    private final DataSource dataSource
    private final Environment env

    JasperReportService(DataSource dataSource, Environment env) {
        this.dataSource = dataSource
        this.env = env
    }

    /**
     * <P>
     * Download di un report jasper (compilato) riempito con i parametri passati, in formato PDF
     *
     * <P>
     * <H3>Layout a specchio:</H3>
     * <P>Per specchiare pagine pari e dispari, in particolare i margini e le colonne dell'intestazione:
     *      specificare l'opzione "mirror" = true
     *
     * <P>
     * <H3>Controlla che la stampa non vada su 2 o più pagine</H3>
     * <P>Per controllare che la stampa non sfori, passare l'opzione "checkSinglePage" = true
     *
     * @param reportName il nome del file del report (senza estensione)
     * @param reportFilename il nome del file che verrà scaricato (senza estensione)
     * @param params i parametri per la compilazione
     * @param options le opzioni
     *      <ul>
     *          <li><b>dataSource</b>: usa il datasource specificato (se non specificato usa la connessione DB)</li>
     *          <li><b>checkSinglePage</b>: controlla che il report venga stampato su una sola pagina
     *              e lancia un'eccezione in caso contrario</li>
     *          <li><b>mirrorLayout</b>: 0 = specchia il layout sulle pagine pari, 1 = specchia sulle pagine dispari</li>
     *      </ul>
     * @return il numero di pagine stampato
     * @throws Exception
     */
    int downloadReport(String reportName, String reportFilename, Map params, Map options=[:]) throws Exception {
        JasperExporter exporter = buildReport(reportName, params, options)
        Filedownload.save(exporter.exportStream(), ETipoFile.PDF.contentType, reportFilename + "." + ETipoFile.PDF.estensione)
        return exporter.getPages()
    }

    private void validaDati(Map customMandatoryParams){
        if (customMandatoryParams){
            for (val in customMandatoryParams.values()) {
                if (val == null){
                    throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
                }
            }
        }
    }

    int downloadReportCustom(String reportName, String reportFilename, Map params, Map options, Map customMandatoryParams=null) throws Exception {
        validaDati(customMandatoryParams)

        return downloadReport(reportName, reportFilename, params, options)
    }

    /**
     * <P>
     * Esporta un report jasper (compilato) riempito con i parametri passati, in formato PDF
     *
     * <P>
     * <H3>Layout a specchio:</H3>
     * <P>Per specchiare pagine pari e dispari, in particolare i margini e le colonne dell'intestazione:
     *      specificare l'opzione "mirrorLayout"
     *
     * <P>
     * <H3>Controlla che la stampa non vada su 2 o più pagine</H3>
     * <P>Per controllare che la stampa non sfori, passare l'opzione "checkSinglePage" = true
     *
     * @param reportName il nome del file del report (senza estensione)
     * @param params i parametri per la compilazione
     * @param options le opzioni
     *      <ul>
     *          <li><b>dataSource</b>: usa il datasource specificato (se non specificato usa la connessione DB)</li>
     *          <li><b>checkSinglePage</b>: controlla che il report venga stampato su una sola pagina
     *              e lancia un'eccezione in caso contrario</li>
     *          <li><b>mirrorLayout</b>: 0 = specchia il layout sulle pagine pari, 1 = specchia sulle pagine dispari</li>
     *          <li><b>mirrorMargins</b>: if true specchia solamente i margini, non gli elementi contenuti nella pagina</li>
     *      </ul>
     * @return il numero di pagine stampato
     * @throws Exception
     */
    JasperExporter buildReport(String reportName, Map params, Map options=[:]) throws Exception {

        JasperReport report = loadJasper(reportName+".jasper")

        params.put("SUBREPORT_DIR", getReport("", REPORT_DIR).getFile().getAbsolutePath() + File.separator)

        Connection c = null//connessione DB nel caso non sia specificata una JRDataSource

        try {

            JasperPrint print
            JRDataSource jrDataSource = (JRDataSource) options.get(JasperReportUtils.OPTION_DATASOURCE)
            if (jrDataSource == null) {
                c = dataSource.getConnection()
                print = JasperFillManager.fillReport(report, params, c)
            } else {
                print = JasperFillManager.fillReport(report, params, jrDataSource)
            }

            if (!print.getPages()) {
                throw new EmptyReportException(Etichette.getEtichetta("Errore_report_vuoto"))
            }

            if (options.get(JasperReportUtils.OPTION_CHECK_SINGLE_PAGE) && print.getPages().size() > 1) {
                throw new MultiplePagesException()
            }

            JasperExporter exporter = new JasperExporter(print, { -> c?.close() })

            if (options.containsKey(JasperReportUtils.OPTION_MIRROR_LAYOUT)) {
                boolean mirrorMargins = options.containsKey(JasperReportUtils.OPTION_MIRROR_MARGINS) ? (Boolean) options.get(JasperReportUtils.OPTION_MIRROR_MARGINS) : false
                exporter.mirror((Integer) options.get(JasperReportUtils.OPTION_MIRROR_LAYOUT), mirrorMargins, options.get(JasperReportUtils.OPTION_MIRROR_EXCLUDED))
            }

            return exporter

        } catch(Exception exc) {
            c?.close()
            throw exc
        }

    }

    private JasperReport loadJasper(String reportName, String reportSubFolder=null) {
        String reportFolderPath = (getCustomReportFolder(reportName, reportSubFolder)?:REPORT_DIR)
        String reportPath = reportFolderPath + File.separator + reportName
        Resource resource = getReport(reportName, reportPath)
        return (JasperReport) JRLoader.loadObject(resource.getInputStream())
    }

    //rivedere tutto il service
    /*
    ByteArrayOutputStream generatePdfReport(String reportName, String reportSubFolder, Map<String, Object> parametri) {
        String reportFolderPath = getCustomReportFolder(reportName, reportSubFolder)?:("${REPORT_DIR}" + (reportSubFolder?File.separator:"") + (reportSubFolder?:""))
        String reportPath = reportFolderPath + File.separator + reportName

        Resource resource = getReport(reportName, reportPath)

        JRPdfExporter exporter = new JRPdfExporter()
        ByteArrayOutputStream byteArray = new ByteArrayOutputStream()
        exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(byteArray))

        //exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8")
        //parametri.REPORT_PATH = reportFolderPath + File.separator
        JasperPrint jasperPrint = JasperFillManager.fillReport(resource.inputStream, parametri, dataSource.getConnection())
        exporter.setExporterInput(new SimpleExporterInput(jasperPrint))

        exporter.exportReport()

        return byteArray
    }
    */

    String getCustomReportFolder(String reportName, String reportSubFolder){
        String confappsLocation = env.getProperty(ConfappsEnvPostProcessor.CONFAPPS_PROPERTY)
        String customReportPath = confappsLocation + File.separator + APP_DIR + File.separator + "reports" + (reportSubFolder?File.separator:"") + (reportSubFolder?:"")
        File reportFile = new File((customReportPath + File.separator + reportName))
        if (reportFile.exists()){
            return customReportPath
        } else {
            return null
        }
    }

    private Resource getReport(String reportName, String reportPath) {
        Resource result = Holders.getApplicationContext().getResource(reportPath)
        if (result.exists()) {
            return result
        }

        result = new FileSystemResource(reportPath)
        if (result.exists()) {
            return result
        }

        throw new De4gsdzkRuntimeException("Report non trovato: ${reportName} ")
    }

}
