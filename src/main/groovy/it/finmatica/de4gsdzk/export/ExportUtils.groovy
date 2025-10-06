package it.finmatica.de4gsdzk.export

import com.opencsv.CSVWriter
import it.finmatica.de4gsdzk.utils.DataUtils
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.*

import java.nio.charset.StandardCharsets
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.text.NumberFormat

class ExportUtils {

    public static final char SEPARATOR = ";"

    public static final String DATE_FORMAT = "D"
    public static final String DATE_TIME_FORMAT = "DT"
    public static final String STRING_FORMAT = "S"
    public static final String NUMBER_FORMAT = "N"
    public static final String INTEGER_FORMAT = "I"

    public static final String DECIMAL_FORMAT_PATTERN = '#,##0.00000'

    static InputStream createCsv (List<ExportField> columnsExportDetails, List<?> exportData, String charsetName=null) {
        String cs = charsetName

        ByteArrayOutputStream out = new ByteArrayOutputStream()
        if (cs == null){
            cs = StandardCharsets.UTF_8.name()
            //https://stackoverflow.com/questions/10136343/opencsv-csvwriter-using-utf-8-doesnt-seem-to-work-for-multiple-languages
            out.write(0xef)
            out.write(0xbb)
            out.write(0xbf)
        }
        CSVWriter writer = new CSVWriter(new OutputStreamWriter(out, cs), SEPARATOR as char)

        // adding header to csv
        List header = []
        for (ExportField sf : columnsExportDetails){
            header.add(sf.getEtichetta())
        }
        writer.writeNext(header as String[])

        // add data to csv
        for (def dataRow: exportData) {
            List csvData = []
            for (ExportField columnDetail:columnsExportDetails){
                String propertyName = columnDetail.getCampo()
                switch (columnDetail.getTipo()) {
                    case DATE_FORMAT:
                        if (columnDetail.getExportClosure() != null ){
                            csvData.add(DataUtils.fromDateToString( ((Date)columnDetail.getExportClosure().call(dataRow, propertyName)) ) )
                        } else {
                            (dataRow."$propertyName")?csvData.add(DataUtils.fromDateToString( ((Date)dataRow."$propertyName") ) ):csvData.add(null)
                        }
                        break
                    case DATE_TIME_FORMAT:
                        if (columnDetail.getExportClosure() != null ){
                            csvData.add(DataUtils.fromDateToString(columnDetail.getExportClosure().call(dataRow, propertyName)), DataUtils.DATE_TIME_FORMAT_PATTERN)
                        } else {
                            (dataRow."$propertyName")?csvData.add(DataUtils.fromDateToString(dataRow."$propertyName", DataUtils.DATE_TIME_FORMAT_PATTERN)):csvData.add(null)
                        }
                        break
                    case NUMBER_FORMAT:
                        BigDecimal bd = (BigDecimal) dataRow."$propertyName"
                        int bdScale = bd.scale()
                        if (bdScale > 0){
                            DecimalFormat df = new DecimalFormat(DECIMAL_FORMAT_PATTERN, new DecimalFormatSymbols(Locale.ITALIAN))
                            if (columnDetail.getExportClosure() != null ){
                                csvData.add(df.format(columnDetail.getExportClosure().call(dataRow, propertyName)))
                            } else {
                                csvData.add(df.format(dataRow."$propertyName"))
                            }
                        } else {
                            NumberFormat intf = NumberFormat.getIntegerInstance()
                            if (columnDetail.getExportClosure() != null ){
                                csvData.add(intf.format(columnDetail.getExportClosure().call(dataRow, propertyName)))
                            } else {
                                String v = ((dataRow."$propertyName" != null)?intf.format(dataRow."$propertyName"):null)
                                csvData.add(v)
                            }
                        }
                        break
                    case INTEGER_FORMAT:
                        NumberFormat intf = NumberFormat.getIntegerInstance()
                        if (columnDetail.getExportClosure() != null ){
                            csvData.add(intf.format(columnDetail.getExportClosure().call(dataRow, propertyName)))
                        } else {
                            String v = ((dataRow."$propertyName" != null)?intf.format(dataRow."$propertyName"):null)
                            csvData.add(v)
                        }
                        break
                    case STRING_FORMAT:
                    default:
                        if (columnDetail.getExportClosure() != null ){
                            csvData.add(columnDetail.getExportClosure().call(dataRow, propertyName))
                        } else {
                            csvData.add(dataRow."$propertyName")
                        }
                        break
                }
            }
            writer.writeNext(csvData as String[])
        }
        writer.flush()
        writer.close()
        return new ByteArrayInputStream(out.toByteArray())
    }

    static InputStream createExcel (List<ExportField> columnsExportDetails, List<?> exportData){
        Workbook wb = new HSSFWorkbook()
        //CreationHelper createHelper = wb.getCreationHelper()
        Sheet sheet = wb.createSheet("QueryExport")

        Font headerFont = wb.createFont()
        headerFont.setBold(true)
        CellStyle headerCellStyle = wb.createCellStyle()
        headerCellStyle.setFont(headerFont)

        // Row for Header
        Row headerRow = sheet.createRow((short)0)

        // Header
        for (int col = 0; col < columnsExportDetails.size(); col++) {
            Cell cell = headerRow.createCell(col)
            cell.setCellValue(columnsExportDetails[col].getEtichetta())
            cell.setCellStyle(headerCellStyle)
        }

        HSSFCellStyle dateCellStyle = wb.createCellStyle()
        dateCellStyle.setDataFormat(wb.createDataFormat().getFormat(DataUtils.DATE_FORMAT_PATTERN))
        HSSFCellStyle datetimeCellStyle = wb.createCellStyle()
        datetimeCellStyle.setDataFormat(wb.createDataFormat().getFormat(DataUtils.DATE_TIME_FORMAT_PATTERN))

        // Data to export
        int rowIdx = 1
        for (def dataRow: exportData) {
            int colIdx = 0
            Row row = sheet.createRow((int) rowIdx++)
            for (ExportField columnDetail:columnsExportDetails){
                Cell cell = row.createCell(colIdx++)
                String propertyName = columnDetail.getCampo()
                switch (columnDetail.getTipo()) {
                    case DATE_FORMAT:
                    case DATE_TIME_FORMAT:
                        cell.setCellStyle(columnDetail.getTipo()==DATE_FORMAT ? dateCellStyle : datetimeCellStyle)
                        Date val = null
                        if (columnDetail.getExportClosure() != null ){
                            val = (Date) columnDetail.getExportClosure().call(dataRow, propertyName)
                        } else {
                            val = (Date) dataRow."$propertyName"
                        }
                        if (val != null){
                            cell.setCellValue(val)
                        } else {
                            cell.setCellValue(null)
                        }
                        break
                    case INTEGER_FORMAT:
                    case NUMBER_FORMAT:
                        try {
                            cell.setCellType(Cell.CELL_TYPE_NUMERIC)
                            if (columnDetail.getExportClosure() != null ){
                                cell.setCellValue(columnDetail.getExportClosure().call(dataRow, propertyName))
                            } else {
                                cell.setCellValue(dataRow."$propertyName")
                            }
                        } catch (Exception e) {
                            if (columnDetail.getExportClosure() != null ){
                                cell.setCellValue(new HSSFRichTextString(columnDetail.getExportClosure().call(dataRow, propertyName)))
                            } else {
                                cell.setCellValue(new HSSFRichTextString(dataRow."$propertyName"))
                            }
                        }
                        break
                    case STRING_FORMAT:
                    default:
                        if (columnDetail.getExportClosure() != null ){
                            cell.setCellValue(columnDetail.getExportClosure().call(dataRow, propertyName))
                        } else {
                            cell.setCellValue(dataRow."$propertyName")
                        }
                        break
                }
            }
        }
        for(int i = 0; i< columnsExportDetails.size(); i++){
            sheet.autoSizeColumn(i)
        }

        ByteArrayOutputStream bos = new ByteArrayOutputStream()
        wb.write(bos)
        bos.close()

        return new ByteArrayInputStream(bos.toByteArray())
    }

    /*
    static InputStream createPDF(JasperReportService service, String reportName, Map reportParams,
                                 List<ExportField> columnsExportDetails, List<?> exportData) {

        Map headers = [:]
        for (ListIterator<ExportField> it = columnsExportDetails.listIterator(); it.hasNext(); ) {
            ExportField exportField = it.next()
            //usa le etichette come parametri dei campi intestazione
            headers.put("label_"+exportField.campo, exportField.etichetta)
            //sostituisce etichetta col nome del campo
            it.set(new ExportField(exportField.campo, exportField.campo, exportField.tipo, exportField.exportClosure))
        }

        ExcelDataSource xlsDS = new ExcelDataSource(createExcel(columnsExportDetails, exportData))
        xlsDS.setUseFirstRowAsHeader(true)
        return service.buildReport(reportName, headers + reportParams, [dataSource: xlsDS]).exportStream()
    }
    */
}
