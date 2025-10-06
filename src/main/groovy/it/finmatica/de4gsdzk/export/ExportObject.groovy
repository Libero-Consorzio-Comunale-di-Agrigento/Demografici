package it.finmatica.de4gsdzk.export

class ExportObject {

    private final String reportName
    private final List<ExportField> exportFields
    private final List<?> exportData

    private final Map reportParams
    private final Map reportOptions

    private final String csvCharsetName

    ExportObject(String reportName, List<ExportField> exportFields, List<?> exportData, Map reportParams, Map reportOptions, String csvCharsetName){
        this.reportName = reportName
        this.exportFields = exportFields
        this.exportData = exportData
        this.reportParams = reportParams
        this.reportOptions = reportOptions
        this.csvCharsetName = csvCharsetName
    }

    String getReportName() {
        return reportName
    }

    List<ExportField> getExportFields() {
        return exportFields
    }

    List<?> getExportData() {
        return exportData
    }

    Map getReportParams() {
        return reportParams
    }

    Map getReportOptions() {
        return reportOptions
    }

    String getCsvCharsetName() {
        return csvCharsetName
    }
}
