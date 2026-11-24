package it.finmatica.de4gsdzk.anagrafe.pratiche

import com.lowagie.text.pdf.*
import groovy.json.JsonSlurper
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaDichiarazioneResidenza
import it.finmatica.de4gsdzk.anagrafe.AnaDichiarazioneResidenzaRepository
import it.finmatica.de4gsdzk.anagrafe.AnaSoggettoDichiarazioneResidenza
import it.finmatica.de4gsdzk.anagrafe.AnaSoggettoDichiarazioneResidenzaRepository
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.PdfManipulationUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class DichiarazioneResidenzaPdfService {

    private final AnaDichiarazioneIscrizioneResService anaDichiarazioneIscrizioneResService
    private final AnaDichiarazioneResidenzaRepository anaDichiarazioneResidenzaRepository
    private final AnaSoggettoDichiarazioneResidenzaRepository anaSoggettoDichiarazioneResidenzaRepository

    DichiarazioneResidenzaPdfService(AnaDichiarazioneIscrizioneResService anaDichiarazioneIscrizioneResService,
                                     AnaDichiarazioneResidenzaRepository anaDichiarazioneResidenzaRepository,
                                     AnaSoggettoDichiarazioneResidenzaRepository anaSoggettoDichiarazioneResidenzaRepository) {
        this.anaDichiarazioneIscrizioneResService = anaDichiarazioneIscrizioneResService
        this.anaDichiarazioneResidenzaRepository = anaDichiarazioneResidenzaRepository
        this.anaSoggettoDichiarazioneResidenzaRepository = anaSoggettoDichiarazioneResidenzaRepository
    }

    byte[] generateDichiarazioneResidenzaPdf(AnaPratica pratica) {
        PdfReader reader = null
        PdfStamper stamper = null

        try {
            byte[] templateBytes = this.class.getResourceAsStream("/templates/Dichiarazione-di-residenza.pdf").bytes

            List<AnaSoggettoDichiarazioneResidenza> soggetti = anaSoggettoDichiarazioneResidenzaRepository
                .findByAnnoPraticaAndPraticaAndTipoEventoOrderByWord1AscWord2Asc(pratica.anno, pratica.numero, pratica.tipoPratica.id)
            int numeroPersone = Math.max(soggetti.size(), 1)

            Map<String, Map<String, String>> mapping = PdfManipulationUtils
                .loadMappingFromJson("/dichiarazione-lt-pdf-mapping.json", "dichiarazione.residenza.")

            Map<String, String> dataByEtiquette = getPdfFormData(pratica, soggetti, mapping)

            // I campi "Rapporto di parentela" vengono posizionati troppo in basso dal form-fill
            // AcroForm (il dato sta sul fondo e il discendente di 'g'/'p' viene tagliato). Li
            // estraiamo dal fill e li disegniamo come overlay diretto a baseline controllata.
            Map<String, String> parentelaByField = extractParentelaFields(dataByEtiquette, mapping)

            byte[] pdfBytes = buildPdfWithDynamicPages(templateBytes, numeroPersone)

            ByteArrayOutputStream baos = new ByteArrayOutputStream()
            reader = new PdfReader(pdfBytes)
            stamper = new PdfStamper(reader, baos)
            AcroFields form = stamper.getAcroFields()

            fillPdfForm(form, dataByEtiquette, mapping, stamper)


            fixCheckboxes(form, dataByEtiquette, mapping)

            drawParentelaValues(stamper, form, parentelaByField)

            int numeroPagine3 = calcolaNumeroPagine3(numeroPersone)
            for (int i = 1; i < numeroPagine3; i++) {
                int pagina = 3 + i
                int numTop = 3 + (i * 2)
                int numBottom = 4 + (i * 2)
                overwritePersonNumbers(stamper, pagina, numTop, numBottom)
            }

            addHeaderOverlay(stamper, dataByEtiquette)

            int firmaPage = 3 + numeroPagine3
            addFirmaFamigliaOverlay(stamper, firmaPage)

            String rifPratica = dataByEtiquette["ZF"]
            if (rifPratica) {
                PdfManipulationUtils.addRifPraticaFooter(stamper, reader, rifPratica)
            }

            stamper.setFormFlattening(true)
            stamper.close()
            stamper = null
            byte[] filledPdfBytes = baos.toByteArray()
            reader.close()
            reader = null

            return filledPdfBytes

        } catch (Exception e) {
            log.error("Errore in generazione pdf dichiarazione residenza: ${e.message}", e)
            throw new De4gsdzkRuntimeException("Errore nella generazione del PDF dichiarazione residenza: ${e.message}", e)
        } finally {
            try { if (stamper != null) stamper.close() } catch (Exception ignored) {}
            try { if (reader != null) reader.close() } catch (Exception ignored) {}
        }
    }


    /**
     * Spunta correttamente i checkbox del PDF dichiarazione residenza.
     * Un checkbox AcroForm si attiva SOLO impostando il suo vero "on-state"
     * (ricavato dalle appearance states del widget, es. "Yes"/"On"/"1"),
     * non un valore arbitrario tipo "X". Va invocato dopo fillPdfForm e prima
     * del flattening. Idempotente per i checkbox gia corretti.
     */
    private void fixCheckboxes(AcroFields form, Map<String, String> dataByEtiquette,
                               Map<String, Map<String, String>> mapping) {
        dataByEtiquette.each { String etichetta, String value ->
            // Risolve la config base gestendo le copie pagina-3 col prefisso pN_
            String baseEtichetta = etichetta.replaceFirst(/^p\d+_/, "")
            String prefix = (etichetta == baseEtichetta) ? "" : etichetta.substring(0, etichetta.length() - baseEtichetta.length())
            Map<String, String> cfg = mapping[baseEtichetta]
            String pdfField = cfg?.get("pdfField")
            if (!pdfField) {
                return
            }

            String realField = prefix + pdfField
            if (form.getFieldType(realField) != AcroFields.FIELD_TYPE_CHECKBOX) {
                return
            }

            if (isTruthy(value)) {
                String onState = (form.getAppearanceStates(realField) as List).find { it != "Off" }
                String toSet = onState ?: value
                form.setField(realField, toSet)
            } else {
                form.setField(realField, "Off")
            }
        }
    }

    private static boolean isTruthy(String v) {
        if (!v) {
            return false
        }
        return !(v.trim().toLowerCase() in ["0", "false", "no", "off", "n"])
    }

    // pdfField dei campi "Rapporto di parentela" (persona 2/3/4); le copie pagina-3 li riusano col prefisso pN_.
    private static final List<String> PARENTELA_PDF_FIELDS = ["Casella di testo 33", "Casella di testo 49", "Casella di testo 66"]

    /**
     * Estrae dal set di dati i valori "Rapporto di parentela" (rimuovendoli dal fill form,
     * che li posizionerebbe troppo in basso) e li restituisce mappati sul nome reale del
     * campo PDF (gestendo il prefisso pN_ delle copie pagina-3).
     */
    private Map<String, String> extractParentelaFields(Map<String, String> dataByEtiquette,
                                                       Map<String, Map<String, String>> mapping) {
        Map<String, String> result = [:]
        List<String> keysToRemove = []
        dataByEtiquette.each { String etichetta, String value ->
            String baseEtichetta = etichetta.replaceFirst(/^p\d+_/, "")
            String prefix = (etichetta == baseEtichetta) ? "" : etichetta.substring(0, etichetta.length() - baseEtichetta.length())
            String pdfField = mapping[baseEtichetta]?.get("pdfField")
            if (pdfField && PARENTELA_PDF_FIELDS.contains(pdfField)) {
                result[prefix + pdfField] = value
                keysToRemove.add(etichetta)
            }
        }
        keysToRemove.each { dataByEtiquette.remove(it) }
        return result
    }

    /**
     * Disegna i valori "Rapporto di parentela" come testo diretto, centrato verticalmente
     * nel box del campo (baseline controllata), evitando il posizionamento basso del form-fill.
     * Va invocato dopo fillPdfForm e prima del flattening (richiede i campi ancora presenti).
     */
    private void drawParentelaValues(PdfStamper stamper, AcroFields form, Map<String, String> parentelaByField) {
        if (!parentelaByField) {
            return
        }
        Map config = loadOverlayConfig()?.rapportoParentela ?: [:]
        float fontSize = (config.fontSize ?: 8) as float
        float baselineOffset = (config.baselineOffset ?: 2.5) as float
        float indentX = (config.indentX ?: 2) as float
        BaseFont font = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, false)

        parentelaByField.each { String fieldName, String value ->
            def positions = form.getFieldPositions(fieldName)
            if (!positions || positions.size() < 5) {
                return
            }
            // getFieldPositions ritorna [page, llx, lly, urx, ury] (la pagina e' il primo elemento)
            int page = positions[0] as int
            float llx = positions[1] as float
            float lly = positions[2] as float

            PdfContentByte content = stamper.getOverContent(page)
            if (content == null) {
                return
            }
            content.beginText()
            content.setFontAndSize(font, fontSize)
            content.setTextMatrix((llx + indentX) as float, (lly + baselineOffset) as float)
            content.showText(value)
            content.endText()
        }
    }


    private int calcolaNumeroPagine3(int numeroPersone) {
        if (numeroPersone <= 2) return 0
        return Math.ceil((numeroPersone - 2) / 2.0) as int
    }


    private byte[] buildPdfWithDynamicPages(byte[] templateBytes, int numeroPersone) {
        int numeroPagine3 = calcolaNumeroPagine3(numeroPersone)

        // I percorsi 0/1 sezioni-extra devono passare per PdfCopyFields come il ramo >=2.
        // Un semplice selectPages + PdfStamper lascia intatto il grafo oggetti del template e
        // il successivo setFormFlattening(true) (OpenPDF 1.3.34) lo corrompe: riferimenti a
        // oggetti inesistenti + 2 pagine perse. Il PdfReader di OpenPDF e' permissivo e non lo
        // segnala, ma Adobe/Edge rifiutano il file (errore di apertura "(14)"). PdfCopyFields
        // ricostruisce un grafo pulito che si appiattisce senza corruzione (stesso motivo per
        // cui il ramo >=2 ha sempre funzionato) e preserva i campi AcroForm per il fill successivo.
        if (numeroPagine3 == 0) {
            return rebuildPagesViaCopyFields(templateBytes, "1-2,4-6")
        }

        if (numeroPagine3 == 1) {
            return rebuildPagesViaCopyFields(templateBytes, "1-6")
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PdfCopyFields merger = new PdfCopyFields(baos)

        PdfReader partA = new PdfReader(templateBytes)
        partA.selectPages("1-3")
        merger.addDocument(partA)

        List<PdfReader> extraReaders = []
        for (int i = 1; i < numeroPagine3; i++) {
            byte[] renamedPage = createRenamedPage3Copy(templateBytes, i)
            PdfReader extraReader = new PdfReader(renamedPage)
            extraReaders.add(extraReader)
            merger.addDocument(extraReader)
        }

        PdfReader partC = new PdfReader(templateBytes)
        partC.selectPages("4-6")
        merger.addDocument(partC)

        merger.close()
        partA.close()
        extraReaders.each { it.close() }
        partC.close()

        return baos.toByteArray()
    }


    /**
     * Ricostruisce le pagine selezionate del template tramite PdfCopyFields, producendo un
     * grafo oggetti "pulito" e preservando i campi AcroForm (necessari per il fill successivo).
     * Indispensabile perche' il flattening su un template selezionato col solo selectPages
     * genera riferimenti a oggetti inesistenti (vedi commento in buildPdfWithDynamicPages).
     */
    private byte[] rebuildPagesViaCopyFields(byte[] templateBytes, String pages) {
        PdfReader reader = new PdfReader(templateBytes)
        reader.selectPages(pages)
        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PdfCopyFields merger = new PdfCopyFields(baos)
        merger.addDocument(reader)
        merger.close()
        reader.close()
        return baos.toByteArray()
    }


    private byte[] createRenamedPage3Copy(byte[] templateBytes, int copyIndex) {
        PdfReader reader = new PdfReader(templateBytes)
        reader.selectPages("3")

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PdfStamper stamper = new PdfStamper(reader, baos)
        AcroFields form = stamper.getAcroFields()

        int personaTop = 3 + (copyIndex * 2)
        String prefix = "p${personaTop}_"

        List<String> fieldNames = new ArrayList<>(form.getFields().keySet())
        fieldNames.each { String oldName ->
            form.renameField(oldName, prefix + oldName)
        }

        stamper.close()
        reader.close()
        return baos.toByteArray()
    }


    private void overwritePersonNumbers(PdfStamper stamper, int page, int numTop, int numBottom) {
        Map config = loadOverlayConfig()?.personNumberOverlay ?: [:]
        PdfContentByte content = stamper.getOverContent(page)
        // Il template usa numeri con font serif non in grassetto (vedi "4)" originale):
        // default TIMES_ROMAN per non far stonare le copie. Override via config "font"/"bold".
        String fontName = config.font ?: (config.bold ? BaseFont.TIMES_BOLD : BaseFont.TIMES_ROMAN)
        BaseFont font = BaseFont.createFont(fontName as String, BaseFont.WINANSI, false)

        float fontSize = (config.fontSize ?: 10) as float
        float topX = (config.topX ?: 56) as float
        float topY = (config.topY ?: 785) as float
        float bottomX = (config.bottomX ?: 56) as float
        float bottomY = (config.bottomY ?: 395) as float
        float rectW = (config.rectW ?: 20) as float
        float rectH = (config.rectH ?: 14) as float
        float descent = (config.rectDescent ?: 2) as float


        coverAndWriteNumber(content, font, fontSize, topX, topY, rectW, rectH, descent, "${numTop})".toString())
        coverAndWriteNumber(content, font, fontSize, bottomX, bottomY, rectW, rectH, descent, "${numBottom})".toString())
    }

    private void coverAndWriteNumber(PdfContentByte content, BaseFont font, float fontSize,
                                     float x, float y, float rectW, float rectH, float descent, String text) {
        content.saveState()
        content.setColorFill(java.awt.Color.WHITE)
        content.rectangle(x, (y - descent) as float, rectW, rectH)
        content.fill()
        content.restoreState()

        content.beginText()
        content.setFontAndSize(font, fontSize)
        content.setTextMatrix(x, y)
        content.showText(text)
        content.endText()
    }


    private Set<String> derivePage3Etiquettes(Map<String, Map<String, String>> etiquetteToSourceMapping) {
        Set<String> page3Etiquettes = [] as Set
        etiquetteToSourceMapping.each { etichetta, sourceMapping ->
            if (sourceMapping.get("source") == "AnaSoggettoDichiarazioneResidenza") {
                Integer subjectIndex = sourceMapping.get("subjectIndex") != null
                    ? (sourceMapping.get("subjectIndex") as Integer) : 0
                if (subjectIndex >= 2) {
                    page3Etiquettes.add(etichetta)
                }
            }
        }
        return page3Etiquettes
    }

    Map<String, String> getPdfFormData(AnaPratica pratica, List<AnaSoggettoDichiarazioneResidenza> soggetti,
                                      Map<String, Map<String, String>> etiquetteToSourceMapping) {
        if (pratica == null) {
            throw new IllegalArgumentException("Pratica non può essere null")
        }

        AnaDichiarazioneIscrizioneRes dichiarazione = anaDichiarazioneIscrizioneResService.findByPratica(pratica)

        if (!dichiarazione) {
            throw new De4gsdzkRuntimeException("AnaDichiarazioneIscrizioneRes non trovato per pratica=${pratica.id}")
        }

        AnaDichiarazioneResidenza dichiarazioneRes = anaDichiarazioneResidenzaRepository
            .findByAnnoPraticaAndPraticaAndTipoEvento(pratica.anno, pratica.numero, pratica.tipoPratica.id)

        Map<String, String> dataByEtiquette = [:]

        etiquetteToSourceMapping.each { etichetta, sourceMapping ->
            String value = extractValueFromMapping(sourceMapping, dichiarazione, dichiarazioneRes, soggetti)
            if (value) {
                dataByEtiquette[etichetta] = value
            }
        }

        Set<String> page3Etiquettes = derivePage3Etiquettes(etiquetteToSourceMapping)
        int numPagine3 = calcolaNumeroPagine3(soggetti.size())

        for (int copy = 1; copy < numPagine3; copy++) {
            int personaTop = 3 + (copy * 2)
            String prefix = "p${personaTop}_"
            int offset = copy * 2

            etiquetteToSourceMapping.each { etichetta, sourceMapping ->
                if (page3Etiquettes.contains(etichetta)) {
                    String value = extractValueFromMapping(sourceMapping, dichiarazione, dichiarazioneRes, soggetti, offset)
                    if (value) {
                        dataByEtiquette[prefix + etichetta] = value
                    }
                }
            }
        }

        return dataByEtiquette
    }


    private String extractValueFromMapping(Map<String, String> sourceMapping,
                                           AnaDichiarazioneIscrizioneRes dichiarazione,
                                           AnaDichiarazioneResidenza dichiarazioneRes,
                                           List<AnaSoggettoDichiarazioneResidenza> soggetti,
                                           int subjectOffset = 0) {
        String source = sourceMapping.get("source")
        String fieldName = sourceMapping.get("field")
        String transformType = sourceMapping.get("transform")
        String separator = sourceMapping.get("separator") ?: ""

        String value = null

        if (source == "AnaDichiarazioneIscrizioneRes") {
            value = PdfManipulationUtils.extractValueFromEntity(dichiarazione, fieldName, separator)
        } else if (source == "AnaDichiarazioneResidenza" && dichiarazioneRes) {
            value = PdfManipulationUtils.extractValueFromEntity(dichiarazioneRes, fieldName, separator)
        } else if (source == "AnaSoggettoDichiarazioneResidenza") {
            Integer subjectIndex = sourceMapping.get("subjectIndex") != null
                ? (sourceMapping.get("subjectIndex") as Integer) : 0
            Integer actualIndex = subjectOffset + subjectIndex
            if (actualIndex < soggetti.size()) {
                AnaSoggettoDichiarazioneResidenza soggetto = soggetti[actualIndex]
                if (sourceMapping.get("soloSeMaggiorenne") && !isMaggiorenne(soggetto.fDataNasS)) {
                    return null
                }
                value = PdfManipulationUtils.extractValueFromEntity(soggetto, fieldName, separator)
            }
        }

        if (value && transformType) {
            value = PdfManipulationUtils.applyTransformation(value, transformType)
        }

        return value
    }

    /**
     * Un soggetto senza data di nascita valorizzata/parsabile viene considerato
     * non maggiorenne (non stampato), per non firmare erroneamente come maggiorenne
     * in assenza del dato certo.
     */
    private static boolean isMaggiorenne(String fDataNasS) {
        try {
            Date dataNascita = DataUtils.fromStringToDate(fDataNasS)
            return dataNascita != null && !dataNascita.after(DataUtils.substractYears(new Date(), 18))
        } catch (Exception e) {
            log.warn("Impossibile calcolare l'età da fDataNasS='{}': {}", fDataNasS, e.message)
            return false
        }
    }

    private Map loadOverlayConfig() {
        String jsonText = this.class.getResourceAsStream("/dichiarazione-lt-overlay-config.json")?.text
        if (!jsonText) return [:]
        return new JsonSlurper().parseText(jsonText)
    }


    private void addHeaderOverlay(PdfStamper stamper, Map<String, String> dataByEtiquette = [:]) {
        Map config = loadOverlayConfig()?.headerOverlay ?: [:]
        int page = (config.page ?: 1) as int
        PdfContentByte content = stamper.getOverContent(page)

        BaseFont fontBold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, false)
        BaseFont fontItalic = BaseFont.createFont(BaseFont.HELVETICA_OBLIQUE, BaseFont.WINANSI, false)

        Map wr = config.whiteRect ?: [x:20, y:720, w:555, h:122]
        content.saveState()
        content.setColorFill(java.awt.Color.WHITE)
        content.rectangle(wr.x as float, wr.y as float, wr.w as float, wr.h as float)
        content.fill()
        content.restoreState()

        Map box = config.box ?: [x:290, y:762, w:270, h:68]
        float boxX = box.x as float
        float boxY = box.y as float
        float boxW = box.w as float
        float boxH = box.h as float

        content.saveState()
        content.setColorStroke(java.awt.Color.BLACK)
        content.setLineWidth(0.5f)
        content.rectangle(boxX, boxY, boxW, boxH)
        content.stroke()
        content.restoreState()

        float labelX = (config.labelX ?: boxX + 6) as float
        float fontSize = (config.fontSize ?: 9) as float
        float ls = (config.lineSpacing ?: 14) as float
        float topY = (boxY + boxH - 14) as float
        float row2Y = (topY - ls) as float
        float row3Y = (topY - ls * 2) as float
        float row4Y = (topY - ls * 3 - 2) as float

        content.beginText()
        content.setFontAndSize(fontBold, fontSize)
        content.setTextMatrix(labelX, topY)
        content.showText("Pratica N.")
        content.setTextMatrix(labelX, row2Y)
        content.showText("Data Presentazione")
        content.setTextMatrix(labelX, row3Y)
        content.showText("Operatore")
        content.setFontAndSize(fontItalic, 7f)
        content.setTextMatrix(labelX, row4Y)
        content.showText("(Spazio riservato all'ufficio)")
        content.endText()

        float fieldOffsetX = (config.fieldOffsetX ?: 125) as float
        float fieldX = (labelX + fieldOffsetX) as float

        BaseFont fontValue = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, false)
        content.beginText()
        content.setFontAndSize(fontValue, fontSize)
        content.setTextMatrix(fieldX, topY)
        content.showText((dataByEtiquette["Z7"] ?: "") as String)
        content.setTextMatrix(fieldX, row2Y)
        content.showText((dataByEtiquette["Z8"] ?: "__/__/____") as String)
        content.setTextMatrix(fieldX, row3Y)
        content.showText((dataByEtiquette["Z9"] ?: "") as String)
        content.endText()
    }

    private void addFirmaFamigliaOverlay(PdfStamper stamper, int pageOverride = -1) {
        Map config = loadOverlayConfig()?.firmaFamigliaOverlay ?: [:]
        int page = (pageOverride > 0) ? pageOverride : ((config.page ?: 4) as int)
        PdfContentByte content = stamper.getOverContent(page)

        BaseFont fontNormal = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, false)
        BaseFont fontItalic = BaseFont.createFont(BaseFont.HELVETICA_OBLIQUE, BaseFont.WINANSI, false)

        float leftRectX = (config.leftRectX ?: 56) as float
        float rightRectX = (config.rightRectX ?: 298) as float
        float rectY = (config.rectY ?: 470) as float
        float rectW = (config.rectW ?: 238) as float
        float rectH = (config.rectH ?: 30) as float

        content.saveState()
        content.setColorFill(java.awt.Color.WHITE)
        content.rectangle(leftRectX, rectY, rectW, rectH)
        content.rectangle(rightRectX, rectY, rectW, rectH)
        content.fill()
        content.restoreState()

        float firmaY = (config.firmaY ?: 480) as float
        float firmaLeftX = (config.firmaLeftX ?: 63) as float
        float firmaRightX = (config.firmaRightX ?: 305) as float
        float firmaFontSize = (config.firmaFontSize ?: 8) as float
        String firmaText = config.firmaText ?: "Firma ______________________________ (1)"

        content.beginText()
        content.setFontAndSize(fontNormal, firmaFontSize)
        content.setTextMatrix(firmaLeftX, firmaY)
        content.showText(firmaText)
        content.setTextMatrix(firmaRightX, firmaY)
        content.showText(firmaText)
        content.endText()

        float noteY = (config.noteY ?: 462) as float
        float noteFontSize = (config.noteFontSize ?: 6.5) as float
        String noteText = config.noteText ?: "(1) Firma di un componente della famiglia gi\u00E0 residente nel medesimo alloggio. Allegare fotocopia del documento di riconoscimento di tale componente."

        content.beginText()
        content.setFontAndSize(fontItalic, noteFontSize)
        content.setTextMatrix(leftRectX, noteY)
        content.showText(noteText)
        content.endText()

        AcroFields form = stamper.getAcroFields()
        List<String> fieldsToResize = (config.resizeFields ?: ["tipo familiare"]) as List
        float resizeHeight = (config.resizeFieldHeight ?: 14) as float

        fieldsToResize.each { String fieldName ->
            PdfManipulationUtils.resizeFieldToSingleLine(form, fieldName, resizeHeight)
        }
    }


    private void fillPdfForm(def form, Map<String, String> dataByLabel,
                              Map<String, Map<String, String>> mapping, def stamper = null) {
        // Le copie pagina-3 (>4 soggetti) usano chiavi dati "pN_<etichetta>" e campi PDF
        // rinominati "pN_<pdfField>" (vedi createRenamedPage3Copy). Il mapping base non
        // contiene queste chiavi: senza arricchirlo, fillPdfForm le salterebbe lasciando
        // le sezioni aggiuntive vuote. Generiamo qui le voci pN_ derivandole dalle base.
        Map<String, Map<String, String>> effectiveMapping = new LinkedHashMap<>(mapping)
        dataByLabel.keySet().each { String key ->
            def m = (key =~ /^(p\d+_)(.+)$/)
            if (m.find() && !effectiveMapping.containsKey(key)) {
                String prefix = m.group(1)
                String baseEtichetta = m.group(2)
                Map<String, String> baseCfg = mapping[baseEtichetta]
                if (baseCfg?.get("pdfField")) {
                    Map<String, String> cloned = new LinkedHashMap<>(baseCfg)
                    cloned.put("pdfField", prefix + baseCfg.get("pdfField"))
                    effectiveMapping.put(key, cloned)
                }
            }
        }
        PdfManipulationUtils.fillPdfForm(form, dataByLabel, effectiveMapping, stamper, [:], false, [], null)
    }

}
