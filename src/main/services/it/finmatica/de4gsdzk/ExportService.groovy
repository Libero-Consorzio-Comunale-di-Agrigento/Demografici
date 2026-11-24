package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileUtils
import net.sf.jasperreports.engine.data.ExcelDataSource
import org.springframework.stereotype.Service

@Service
class ExportService {

    private final ThymeLeafExportService thymeLeafExportService
    private final JasperReportService jasperReportService

    ExportService(ThymeLeafExportService thymeLeafExportService, JasperReportService jasperReportService) {
        this.thymeLeafExportService = thymeLeafExportService
        this.jasperReportService = jasperReportService
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

    InputStream export(ETipoFile tipo, ExportObject eo, Map customMandatoryParams=null) {
        switch(tipo) {
            case ETipoFile.XLS:
                return ExportUtils.createExcel(eo.exportFields, eo.exportData)
            case ETipoFile.CSV:
                return ExportUtils.createCsv(eo.exportFields, eo.exportData, eo.csvCharsetName)
            case ETipoFile.XML:
                validaDati(customMandatoryParams)
                String xml = thymeLeafExportService.createXML(eo.reportName, eo.reportParams)
                return new ByteArrayInputStream(xml.getBytes('UTF-8'))
            case ETipoFile.PDF_A:
            case ETipoFile.PDF: //ogni pdf esportato sarà della tipologia pdf/a
                validaDati(customMandatoryParams)
                InputStream is = createPdf(eo)
                return new ByteArrayInputStream(FileUtils.convertPdfToPdfA(is))
            default:
                throw new De4gsdzkRuntimeException("Unsupported export type")
        }
    }

    /**
     * @param args
     *  <ul>
     *  <li>reportName: il report (file .jasper)</li>
     *  <li>reportParams: (i parametri da sostituire)</li>
     *  <li>reportOptions: (le opzioni di esportazione Jasper)</li>
     *  </ul>
     * @return export stream che produce un XML
     * @see it.finmatica.de4gsdzk.export.JasperExporter
     */
    InputStream createPdf(ExportObject eo) {
        //validazione parametri
        String reportName = eo.reportName
        Map reportParams = (eo.reportParams ?: [:]) as Map
        Map reportOptions = (eo.reportOptions ?: [:]) as Map
        List<?> exportData = (eo.exportData ?: []) as List<?>
        List<ExportField> columnsExportDetails = eo.exportFields
        Objects.requireNonNull(reportName, "Il nome del report non è specificato")
        Objects.requireNonNull(columnsExportDetails, "Le colonne/campi non sono specificati")

        //sostituzione etichette
        Map headers = [:]
        for (ListIterator<ExportField> it = columnsExportDetails.listIterator(); it.hasNext(); ) {
            ExportField exportField = it.next()
            //usa le etichette come parametri dei campi intestazione
            headers.put("label_"+exportField.campo, exportField.etichetta)
            //sostituisce etichetta col nome del campo
            it.set(new ExportField(exportField.campo, exportField.campo, exportField.tipo, exportField.exportClosure))
        }

        //creazione datasource (export in formato secondario)
//        JRCsvDataSource csvDS = new JRCsvDataSource(csvExportService.export(args + [charsetName: "ISO-8859-1"]))
//        csvDS.setFieldDelimiter(SEPARATOR)
//        csvDS.setUseFirstRowAsHeader(true)
        ExcelDataSource xlsDS = new ExcelDataSource(ExportUtils.createExcel(columnsExportDetails, exportData))
        xlsDS.setUseFirstRowAsHeader(true)

        //compilazione report
        return (jasperReportService.buildReport(reportName, headers + reportParams, [dataSource: xlsDS] + reportOptions).exportStream())
    }

    InputStream createPdfA(ExportObject eo) {
        InputStream is = createPdf(eo)
        return new ByteArrayInputStream(FileUtils.convertPdfToPdfA(is))
    }

    static String buildFilename(String name, ETipoFile tipo) {
        return "${name.replaceAll(' ', '_')}.${tipo.estensione}"
    }

}
