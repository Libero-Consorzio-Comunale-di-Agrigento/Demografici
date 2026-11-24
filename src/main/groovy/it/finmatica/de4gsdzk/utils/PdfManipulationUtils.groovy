package it.finmatica.de4gsdzk.utils;

import com.lowagie.text.Rectangle
import com.lowagie.text.pdf.AcroFields
import com.lowagie.text.pdf.BaseFont
import com.lowagie.text.pdf.PdfArray
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfFormField
import com.lowagie.text.pdf.PdfName
import com.lowagie.text.pdf.PdfNumber
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfStamper
import com.lowagie.text.pdf.TextField
import groovy.json.JsonSlurper
import groovy.util.logging.Slf4j

@Slf4j
public class PdfManipulationUtils {

    static final String TEMPLATE_DUE_COMPONENTI = 'DUE_COMPONENTI'
    static final String TEMPLATE_UN_COMPONENTE = 'UN_COMPONENTE'
    static final String ETICHETTA_B0 = 'B0'
    static final String ETICHETTA_A8 = 'A8'
    static final String ETICHETTA_C4 = 'C4'

    static final String APR4_MAPPING_JSON_PATH = "/apr4-pdf-mapping.json"
    static final String APR4_MAPPING_PREFIX_DUE_COMPONENTI = "apr4.dueComponenti."
    static final String APR4_MAPPING_PREFIX_UN_COMPONENTE = "apr4.unComponente."

    static String extractValueFromEntity(Object entity, String fieldName, String separator = "") {
        if (fieldName && fieldName.contains(",")) {
            return extractAndConcatenateValues(entity, fieldName, separator)
        }

        def value = entity
        fieldName.split("\\.").each { property ->
            if (value == null) {
                return
            }
            try {
                value = value?.getProperty(property)
            } catch (MissingPropertyException e) {
                value = null
                return
            }
        }
        return value ? value.toString() : null
    }

    static String extractAndConcatenateValues(Object entity, String fieldNames, String separator = "") {
        List<String> fields = fieldNames.split(",").collect { it.trim() }
        List<String> values = []

        fields.each { fieldName ->
            def singleValue = extractValueFromEntity(entity, fieldName)
            if (singleValue) {
                values.add(singleValue)
            }
        }

        String result = values ? values.join(separator) : null
        return result
    }

    /**
     * Applica trasformazioni ai valori estratti dal DB.
     * Tipi supportati: none, removeSpaces, trim, uppercase, lowercase, toX,
     * padLeft3, padLeft4, removeSpacesThenPadLeft3, removeSpacesThenPadLeft4,
     * padLeft2SingleDigit, booleanValue ("1"), booleanValueYes ("Yes").
     */
    static String applyTransformation(String value, String transformType) {
        if (!value || !transformType) {
            return value
        }

        switch (transformType) {
            case "none":
                return value

            case "removeSpaces":
                return value.replaceAll(/\s+/, "")

            case "trim":
                return value.trim()

            case "uppercase":
                return value.toUpperCase()

            case "lowercase":
                return value.toLowerCase()

            case "toX":
                return (value && value.toString().trim().toLowerCase() in ["si", "yes", "vero", "true", "x", "on", "1"]) ? "X" : ""

            case "padLeft3":
                String converted = value.toString()
                String padded = converted.padLeft(3, "0")
                return padded

            case "padLeft4":
                String converted4 = value.toString()
                String padded4 = converted4.padLeft(4, "0")
                return padded4

            case "removeSpacesThenPadLeft3":
                String noSpaces = value.toString().replaceAll(/\s+/, "")
                String padded3 = noSpaces.padLeft(3, "0")
                return padded3

            case "removeSpacesThenPadLeft4":
                String noSpaces4 = value.toString().replaceAll(/\s+/, "")
                String padded4b = noSpaces4.padLeft(4, "0")
                return padded4b

            case "padLeft2SingleDigit":
                String converted2 = value.toString()
                String padded2 = converted2.length() == 1 ? "0" + converted2 : converted2
                return padded2

            case "booleanValue":
                return (value && value != "null") ? "1" : ""

            case "booleanValueYes":
                return (value && value != "null") ? "Yes" : ""

            default:
                return value
        }
    }

    static Map<String, String> parseMappingLine(String line) {
        Map<String, String> config = [:]
        line.split("\\|").each { part ->
            if (part.contains(":")) {
                def tokens = part.split(":", 2)
                if (tokens.size() == 2) {
                    String key = tokens[0].trim()
                    String value = tokens[1].trim()
                    config[key] = value
                }
            }
        }
        return config
    }

    static List<String> splitValueByLengths(String value, List<Integer> lengths) {
        List<String> parts = []
        int offset = 0

        lengths.each { length ->
            if (offset < value.length()) {
                int endIndex = Math.min(offset + length, value.length())
                parts.add(value.substring(offset, endIndex))
                offset = endIndex
            } else {
                parts.add("")
            }
        }

        return parts
    }

    static Map<String, Object> getFieldCoordinates(def form, String fieldName) {
        def area = form.getFieldArea(fieldName)
        if (area) {
            float llx = area.llx
            float lly = area.lly
            float urx = area.urx
            float ury = area.ury
            int page = form.getFieldType(fieldName) != null ? 1 : 0

            return [page: page, llx: llx, lly: lly, urx: urx, ury: ury]
        }

        def positions = form.getFieldPositions(fieldName)
        if (positions && positions.size() > 0) {
            float llx = positions[0]
            float lly = positions[1]
            float urx = positions[2]
            float ury = positions[3]
            int page = positions[4]

            return [page: page, llx: llx, lly: lly, urx: urx, ury: ury]
        }
        return null
    }

    static Map<String, Map<String, Number>> loadDirectTextCoordinates() {
        String jsonContent = PdfManipulationUtils.class.getResourceAsStream("/pdf-direct-text-coordinates.json")?.text
        if (!jsonContent) return [:]
        return new groovy.json.JsonSlurper().parseText(jsonContent)
    }

    static void writeDirectTextToPdf(def stamper, int page, float x, float y, String text, float fontSize = 10) {
        def content = stamper.getOverContent(page)
        if (!content) {
            return
        }

        com.lowagie.text.pdf.BaseFont baseFont = com.lowagie.text.pdf.BaseFont.createFont(
            com.lowagie.text.pdf.BaseFont.HELVETICA, com.lowagie.text.pdf.BaseFont.WINANSI, false)

        content.beginText()
        content.setFontAndSize(baseFont, fontSize)
        content.setTextMatrix(x, y)
        content.showText(text)
        content.endText()
    }

    static void writeCompoundFieldDirectToPdf(def stamper, String etichetta, String value, String template) {
        Map<String, Map<String, Number>> coordinates = loadDirectTextCoordinates()
        Map<String, Number> coords = coordinates[etichetta]

        if (!coords) {
            return
        }

        if (coords.template && coords.template != template) {
            return
        }

        if (value.length() < 4) {
            return
        }

        String valPart1 = value.substring(0, 2)
        String valPart2 = value.substring(2, 4)

        float x1 = coords.x1 as float
        float x2 = coords.x2 as float
        float y = coords.y as float
        float fontSize = coords.fontSize ? (coords.fontSize as float) : 10f

        writeDirectTextToPdf(stamper, 1, x1, y, valPart1, fontSize)
        writeDirectTextToPdf(stamper, 1, x2, y, valPart2, fontSize)
    }

    static void fillPdfForm(def form, Map<String, String> dataByLabel, Map<String, Map<String, String>> fullMapping,
                            def stamper = null, Map<String, String> specialFields = [:], boolean checkFieldExists = false,
                            List<String> compoundFieldEtichette = [], String compoundFieldTemplate = null) {
        // Rimuovi XFA per garantire che i valori AcroForm vengano utilizzati dal viewer PDF
        if (form instanceof AcroFields && form.xfa?.xfaPresent) {
            form.removeXfa()
        }
        // Forza la rigenerazione delle apparenze /AP preimpostate (residui XFA / appearance stream)
        // così il flag Comb sui field con MaxLen distribuisce correttamente ogni cifra in una cella.
        if (form instanceof AcroFields) {
            form.setGenerateAppearances(true)
        }

        Map<String, String> fieldMapping = [:]
        fullMapping.each { etichetta, config ->
            fieldMapping[etichetta] = config.get("pdfField")
        }

        List<String> availableFields = checkFieldExists ? (form.fields.keySet() as List) : null

        dataByLabel.each { etichetta, value ->
            if (value && !value.toString().trim().isEmpty()) {
                if (specialFields.containsKey(etichetta)) {
                    String fontSizeStr = fullMapping[etichetta]?.get("fontSize")
                    if (fontSizeStr) {
                        form.setFieldProperty(specialFields[etichetta], "textsize", fontSizeStr as float, null)
                    }
                    form.setField(specialFields[etichetta], value.toString())
                    return
                }

                String fieldName = fieldMapping[etichetta]
                if (!fieldName) {
                    return
                }

                if (checkFieldExists && !availableFields.contains(fieldName)) {
                    return
                }

                if (stamper && etichetta in compoundFieldEtichette && value.toString().length() == 4) {
                    writeCompoundFieldDirectToPdf(stamper, etichetta, value.toString(), compoundFieldTemplate)
                } else {
                    try {
                        String fontSizeStr = fullMapping[etichetta]?.get("fontSize")
                        if (fontSizeStr) {
                            form.setFieldProperty(fieldName, "textsize", fontSizeStr as float, null)
                        }
                        form.setField(fieldName, value.toString())
                    } catch (Exception e) {
                        log.warn("PDF fill: impossibile scrivere il campo '{}' (etichetta '{}'): {}", fieldName, etichetta, e.message)
                    }
                }
            }
        }
    }

    static void coverAndWriteText(PdfContentByte content, BaseFont font, float fontSize,
                                    float x, float y, float rectW, float rectH, String text) {
        content.saveState()
        content.setColorFill(java.awt.Color.WHITE)
        content.rectangle(x, (y - 2) as float, rectW, rectH)
        content.fill()
        content.restoreState()

        content.beginText()
        content.setFontAndSize(font, fontSize)
        content.setTextMatrix(x, y)
        content.showText(text)
        content.endText()
    }

    static void resizeFieldToSingleLine(AcroFields form, String fieldName, float height) {
        def item = form.getFieldItem(fieldName)
        if (!item) return

        for (int i = 0; i < item.size(); i++) {
            def widget = item.getWidget(i)
            if (!widget) continue

            PdfArray rect = widget.getAsArray(PdfName.RECT)
            if (!rect || rect.size() < 4) continue

            float llx = rect.getAsNumber(0).floatValue()
            float ury = rect.getAsNumber(3).floatValue()
            float urx = rect.getAsNumber(2).floatValue()
            float newLly = ury - height

            PdfArray newRect = new PdfArray()
            newRect.add(new PdfNumber(llx))
            newRect.add(new PdfNumber(newLly))
            newRect.add(new PdfNumber(urx))
            newRect.add(new PdfNumber(ury))
            widget.put(PdfName.RECT, newRect)
        }
    }

    static void addEditableTextField(PdfStamper stamper, int page, String fieldName,
                                      float llx, float lly, float urx, float ury, String defaultValue) {
        TextField tf = new TextField(stamper.getWriter(), new Rectangle(llx, lly, urx, ury), fieldName)
        tf.setFontSize(9f)
        tf.setBorderWidth(0f)
        tf.setFont(BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, false))
        if (defaultValue) {
            tf.setText(defaultValue)
        }
        PdfFormField field = tf.getTextField()
        stamper.addAnnotation(field, page)
    }

    static void addRifPraticaFooter(PdfStamper stamper, PdfReader reader, String rifPratica) {
        BaseFont font = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, false)
        float fontSize = 7f
        float marginRight = 30f
        float marginBottom = 15f

        float textWidth = font.getWidthPoint(rifPratica, fontSize)

        for (int page = 1; page <= reader.getNumberOfPages(); page++) {
            Rectangle pageSize = reader.getPageSizeWithRotation(page)
            float x = pageSize.getRight() - marginRight - textWidth
            float y = marginBottom

            PdfContentByte content = stamper.getOverContent(page)
            content.beginText()
            content.setFontAndSize(font, fontSize)
            content.setTextMatrix(x, y)
            content.showText(rifPratica)
            content.endText()
        }
    }

    static Map<String, Map<String, String>> loadMappingFromJson(String prefix) {
        return loadMappingFromJson(APR4_MAPPING_JSON_PATH, prefix)
    }

    static Map<String, Map<String, String>> loadMappingFromJson(String classpathResource, String prefix) {
        Map<String, Map<String, String>> mapping = [:]

        String jsonContent = PdfManipulationUtils.class.getResourceAsStream(classpathResource)?.text
        if (!jsonContent) return mapping

        JsonSlurper slurper = new JsonSlurper()
        Map<String, Object> jsonData = slurper.parseText(jsonContent)

        // Naviga il JSON usando il prefix come path separato da punti
        String path = prefix.replaceAll('\\.$', '')
        Object section = jsonData
        path.split('\\.').each { key ->
            section = section?."${key}"
        }

        if (section instanceof Map) {
            mapping.putAll(section as Map<String, Map<String, String>>)
        }

        return mapping
    }

}
