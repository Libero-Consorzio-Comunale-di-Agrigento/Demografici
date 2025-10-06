package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.utils.ETipoFile
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import net.sf.jasperreports.engine.data.ExcelDataSource
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.zkoss.zul.Filedownload

@Service
class ExportService {

    @Autowired
    private ThymeLeafExportService thymeLeafExportService

    @Autowired
    private JasperReportService jasperReportService

    private void validaDati(Map customMandatoryParams){
        if (customMandatoryParams){
            for (val in customMandatoryParams.values()) {
                if (val == null){
                    throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori)
                }
            }
        }
    }

    void export(ETipoFile tipo, ExportObject eo, String filename, Map customMandatoryParams=null) {
        String fn = "${filename.toString().replaceAll(" ", "_")}.${tipo.estensione}"
        switch(tipo) {
            case ETipoFile.XLS:
                InputStream is = ExportUtils.createExcel(eo.exportFields, eo.exportData)
                download(is, tipo, fn)
                break
            case ETipoFile.CSV:
                InputStream is = ExportUtils.createCsv(eo.exportFields, eo.exportData, eo.csvCharsetName)
                download(is, tipo, fn)
                break
            case ETipoFile.PDF:
                validaDati(customMandatoryParams)
                InputStream is = createPdf(eo)
                download(is, tipo, fn)
                break
            case ETipoFile.XML:
                validaDati(customMandatoryParams)
                String xml = thymeLeafExportService.createXML(eo.reportName, eo.reportParams)
                download(xml, tipo, fn)
                break
            default:
                throw new De4gsdzkRuntimeException("Unsupported export type")
        }
    }

    private void download(InputStream is, ETipoFile tipo, String filename){
        Filedownload.save(is, tipo.contentType, filename)
    }

    private void download(String s, ETipoFile tipo, String filename){
        Filedownload.save(s, tipo.contentType, filename)
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

}
