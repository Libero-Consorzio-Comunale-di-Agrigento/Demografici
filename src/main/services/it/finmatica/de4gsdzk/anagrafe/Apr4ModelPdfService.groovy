package it.finmatica.de4gsdzk.anagrafe

import com.lowagie.text.pdf.AcroFields
import com.lowagie.text.pdf.BaseFont
import com.lowagie.text.pdf.PdfCopyFields
import com.lowagie.text.pdf.PdfDictionary
import com.lowagie.text.pdf.PdfName
import com.lowagie.text.pdf.PdfNumber
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfStamper
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.PdfManipulationUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Service
@Transactional
class Apr4ModelPdfService {

    private final AnaSoggettoModelloApr4Repository anaSoggettoModelloApr4Repository
    private final AnaTestataModelloApr4Repository anaTestataModelloApr4Repository
    private final GsdService gsdService

    private static final List<String> ETICHETTE_CANCELLAZIONE_DUE = ['P4', 'P5', 'P6', 'P7']
    private static final List<String> ETICHETTE_CANCELLAZIONE_UN = ['P4', 'P5', 'P6', 'P7', 'G2', 'E6', 'D5', 'A8']

    Apr4ModelPdfService(AnaSoggettoModelloApr4Repository anaSoggettoModelloApr4Repository,
                        AnaTestataModelloApr4Repository anaTestataModelloApr4Repository,
                        GsdService gsdService) {
        this.anaSoggettoModelloApr4Repository = anaSoggettoModelloApr4Repository
        this.anaTestataModelloApr4Repository = anaTestataModelloApr4Repository
        this.gsdService = gsdService
    }

    private boolean isComuneEstero(AnaTestataModelloApr4 testata) {
        if (!testata?.t1c8 || !testata?.t1c6) {
            return false
        }
        try {
            String rawProv = testata.t1c8.toString().replaceAll(/\s+/, '')
            String rawCom = testata.t1c6.toString().replaceAll(/\s+/, '')
            Integer codProv = rawProv as Integer
            Integer codCom = rawCom as Integer
            return gsdService.checkComuneEstero(codProv, codCom)
        } catch (Exception e) {
            return false
        }
    }

    byte[] generateApr4DueComponenti(Integer anno, Integer numeroDic, String ufficialeAnagrafe) {
        PdfReader reader1 = null
        PdfStamper stamper1 = null
        List<Map<String, String>> listaMappeDati = new ArrayList<>()

        int numSoggetti = getSubjectsNumber(numeroDic, anno)
        try {
            byte[] pdfBytes = this.class.getResourceAsStream("/templates/MOD_APR4_DUE_COMPONENTI.pdf").bytes

            AnaTestataModelloApr4 testata = anaTestataModelloApr4Repository.findByNumeroDicAndAnnoDicAndTipoEvento(numeroDic, anno, ETipoPratica.ISC)
            boolean comuneEstero = isComuneEstero(testata)

            for (int i = 0; i < numSoggetti; i += 2) {
                Map<String, String> dataByEtiquette = getPdfFormDataByKeyWithEtiquettes(numeroDic, anno, i, comuneEstero)
                // Aggiungi etichette ufficiale anagrafe
                dataByEtiquette.put("Q2", ufficialeAnagrafe)
                dataByEtiquette.put("Q3", ufficialeAnagrafe)
                listaMappeDati.add(dataByEtiquette)
            }

            if (listaMappeDati.isEmpty()) {
                return null
            }

            List<byte[]> filledParts = []
            for (Map<String, String> dataByEtiquette : listaMappeDati) {
                ByteArrayOutputStream baos = new ByteArrayOutputStream()

                reader1 = new PdfReader(pdfBytes)
                stamper1 = new PdfStamper(reader1, baos)
                AcroFields form1 = stamper1.getAcroFields()

                fillPdfDueComponenti(form1, dataByEtiquette, stamper1)

                stamper1.setFormFlattening(true)
                stamper1.close()
                filledParts.add(baos.toByteArray())
                reader1.close()
            }

            return mergeApr4Parts(filledParts)

        } catch (Exception e) {
            log.error("Errore in generazione pdf ${e.message}")
            return null
        } finally {
            if (stamper1) stamper1.close()
            if (reader1) reader1.close()
        }
    }

    private byte[] mergeApr4Parts(List<byte[]> filledParts) {
        if (filledParts.size() == 1) {
            return filledParts[0]
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PdfCopyFields merger = new PdfCopyFields(baos)
        List<PdfReader> readers = []
        try {
            filledParts.eachWithIndex { byte[] partBytes, int idx ->
                PdfReader reader = new PdfReader(renameFormFields(partBytes, "part${idx + 1}_"))
                readers.add(reader)
                merger.addDocument(reader)
            }
            merger.close()
            return baos.toByteArray()
        } finally {
            readers.each { it.close() }
        }
    }

    private byte[] renameFormFields(byte[] pdfBytes, String prefix) {
        PdfReader reader = new PdfReader(pdfBytes)
        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        PdfStamper stamper = new PdfStamper(reader, baos)
        AcroFields form = stamper.getAcroFields()

        new ArrayList<>(form.getFields().keySet()).each { String oldName ->
            form.renameField(oldName, prefix + oldName)
        }

        stamper.close()
        reader.close()
        return baos.toByteArray()
    }

    byte[] generateApr4UnComponenti(Integer anno, Integer numeroDic, String ufficialeAnagrafe) {
        PdfReader reader1 = null
        PdfStamper stamper1 = null

        try {
            byte[] pdfBytesUnComponente = this.class.getResourceAsStream("/templates/MOD_APR4_UN_COMPONENTE.pdf").bytes

            AnaTestataModelloApr4 testata = anaTestataModelloApr4Repository.findByNumeroDicAndAnnoDicAndTipoEvento(numeroDic, anno, ETipoPratica.ISC)
            boolean comuneEstero = isComuneEstero(testata)

            Map<String, String> dataUnComponente = getPdfFormDataUnComponente(numeroDic, anno, 0, comuneEstero)
            // Aggiungi etichette ufficiale anagrafe
            dataUnComponente.put("G8", ufficialeAnagrafe)
            dataUnComponente.put("I3", ufficialeAnagrafe)

            ByteArrayOutputStream baosUnComponente = new ByteArrayOutputStream()

            reader1 = new PdfReader(pdfBytesUnComponente)
            stamper1 = new PdfStamper(reader1, baosUnComponente)
            AcroFields form1UnComponente = stamper1.getAcroFields()

            fillPdfUnComponente(form1UnComponente, dataUnComponente, stamper1)

            stamper1.setFormFlattening(true)
            stamper1.close()
            byte[] filledPdfBytesUnComponente = baosUnComponente.toByteArray()
            reader1.close()

            return filledPdfBytesUnComponente

        } catch (Exception e) {
            log.error("Errore in generazione pdf ${e.message}")
            return null
        } finally {
            if (stamper1) stamper1.close()
            if (reader1) reader1.close()
        }
    }


    Map<String, String> getPdfFormDataByKeyWithEtiquettes(Integer numeroDic, Integer anno, Integer startSubjectIndex = 0, boolean comuneEstero = false) {
        if (numeroDic == null || anno == null) {
            throw new IllegalArgumentException("Numero dichiarazione e anno non possono essere null")
        }

        List<AnaSoggettoModelloApr4> listaSoggetti = anaSoggettoModelloApr4Repository.findAllByNumeroDicAndAnnoDicAndTipoEvento(numeroDic, anno, ETipoPratica.ISC)

        AnaTestataModelloApr4 anaTestataModelloApr4 = anaTestataModelloApr4Repository.findByNumeroDicAndAnnoDicAndTipoEvento(numeroDic, anno, ETipoPratica.ISC)

        if (listaSoggetti.isEmpty()) {
            throw new De4gsdzkRuntimeException("AnaSoggettoModelloApr4 non trovato per numeroDic=$numeroDic, anno=$anno")
        }

        if (!anaTestataModelloApr4) {
            throw new De4gsdzkRuntimeException("AnaTestataModelloApr4 non trovato per numeroDic=$numeroDic, anno=$anno")
        }

        Map<String, Map<String, String>> etiquetteToSourceMapping = PdfManipulationUtils.loadMappingFromJson(PdfManipulationUtils.APR4_MAPPING_PREFIX_DUE_COMPONENTI)

        Map<String, String> dataByEtiquette = [:]
        etiquetteToSourceMapping.each { etichetta, sourceMapping ->
            String source = sourceMapping.get("source")
            String fieldName = sourceMapping.get("field")
            String transformType = sourceMapping.get("transform")
            String separator = sourceMapping.get("separator") ?: ""
            Integer subjectIndex = sourceMapping.get("subjectIndex") ? (sourceMapping.get("subjectIndex") as Integer) : 0

            String value = null

            if (source == "AnaSoggettoModelloApr4") {
                Integer actualIndex = startSubjectIndex + subjectIndex

                if (actualIndex < listaSoggetti.size()) {
                    AnaSoggettoModelloApr4 soggetto = listaSoggetti[actualIndex]
                    value = PdfManipulationUtils.extractValueFromEntity(soggetto, fieldName, separator)
                }
            } else if (source == "AnaTestataModelloApr4") {
                if (anaTestataModelloApr4) {
                    value = PdfManipulationUtils.extractValueFromEntity(anaTestataModelloApr4, fieldName, separator)
                }
            }

            if (value && transformType) {
                value = PdfManipulationUtils.applyTransformation(value, transformType)
            }

            if (value) {
                dataByEtiquette[etichetta] = value
            }
        }

        if (comuneEstero) {
            ETICHETTE_CANCELLAZIONE_DUE.each { dataByEtiquette.remove(it) }
        }

        return dataByEtiquette
    }

    Map<String, String> getPdfFormDataUnComponente(Integer numeroDic, Integer anno, Integer startSubjectIndex = 0, boolean comuneEstero = false) {
        if (numeroDic == null || anno == null) {
            throw new IllegalArgumentException("Numero dichiarazione e anno non possono essere null")
        }

        List<AnaSoggettoModelloApr4> listaSoggetti = anaSoggettoModelloApr4Repository.findAllByNumeroDicAndAnnoDic(numeroDic, anno)
        AnaTestataModelloApr4 anaTestataModelloApr4 = anaTestataModelloApr4Repository.findByNumeroDicAndAnnoDicAndTipoEvento(numeroDic, anno, ETipoPratica.ISC)

        if (listaSoggetti.isEmpty()) {
            throw new De4gsdzkRuntimeException("AnaSoggettoModelloApr4 non trovato per numeroDic=$numeroDic, anno=$anno")
        }

        if (!anaTestataModelloApr4) {
            throw new De4gsdzkRuntimeException("AnaTestataModelloApr4 non trovato per numeroDic=$numeroDic, anno=$anno")
        }

        Map<String, Map<String, String>> etiquetteToSourceMappingUnComponente = PdfManipulationUtils.loadMappingFromJson(PdfManipulationUtils.APR4_MAPPING_PREFIX_UN_COMPONENTE)
        Map<String, Map<String, String>> etiquetteToSourceMappingDueComponenti = PdfManipulationUtils.loadMappingFromJson(PdfManipulationUtils.APR4_MAPPING_PREFIX_DUE_COMPONENTI)

        Map<String, String> dataByEtiquette = [:]
        etiquetteToSourceMappingUnComponente.each { etichetta, apr4UnComponenteConfig ->
            String originalEtiquette = apr4UnComponenteConfig.get("originalEtiquette")

            if (!originalEtiquette) {
                return
            }

            Map<String, String> sourceMapping = etiquetteToSourceMappingDueComponenti[originalEtiquette]
            if (!sourceMapping) {
                return
            }

            String source = sourceMapping.get("source")
            String fieldName = sourceMapping.get("field")
            String transformType = sourceMapping.get("transform")
            String separator = sourceMapping.get("separator") ?: ""
            Integer subjectIndex = sourceMapping.get("subjectIndex") ? (sourceMapping.get("subjectIndex") as Integer) : 0

            String value = null

            if (source == "AnaSoggettoModelloApr4") {
                Integer actualIndex = startSubjectIndex + subjectIndex

                if (actualIndex < listaSoggetti.size()) {
                    AnaSoggettoModelloApr4 soggetto = listaSoggetti[actualIndex]
                    value = PdfManipulationUtils.extractValueFromEntity(soggetto, fieldName, separator)
                }
            } else if (source == "AnaTestataModelloApr4") {
                if (anaTestataModelloApr4) {
                    value = PdfManipulationUtils.extractValueFromEntity(anaTestataModelloApr4, fieldName, separator)
                }
            }

            if (value && transformType) {
                value = PdfManipulationUtils.applyTransformation(value, transformType)
            }

            if (value) {
                dataByEtiquette[etichetta] = value
            }
        }

        if (comuneEstero) {
            ETICHETTE_CANCELLAZIONE_UN.each { dataByEtiquette.remove(it) }
        }

        return dataByEtiquette
    }

    int getSubjectsNumber(Integer numeroDic, Integer anno) {
        List<AnaSoggettoModelloApr4> listaSoggettiModelloApr4 = anaSoggettoModelloApr4Repository.findAllByNumeroDicAndAnnoDic(numeroDic, anno)
        return listaSoggettiModelloApr4.size()
    }

    void fillPdfDueComponenti(def form, Map<String, String> dataByLabel, def stamper = null) {
        setAllTextFieldsBold(form)
        setFieldAlignment(form, 'form1[0].#subform[0].Campoditesto3[0]', 2)

        Map<String, String> ufficialeAnagrafeFields = [
                "Q2": "form1[0].#subform[0].TextField2[2]",
                "Q3": "form1[0].#subform[0].TextField2[3]"
        ]
        Map<String, Map<String, String>> mapping = PdfManipulationUtils.loadMappingFromJson(PdfManipulationUtils.APR4_MAPPING_PREFIX_DUE_COMPONENTI)
        PdfManipulationUtils.fillPdfForm(form, dataByLabel, mapping, stamper, ufficialeAnagrafeFields, false, [PdfManipulationUtils.ETICHETTA_B0, PdfManipulationUtils.ETICHETTA_A8], PdfManipulationUtils.TEMPLATE_DUE_COMPONENTI)
    }

    void fillPdfUnComponente(def form, Map<String, String> dataByLabel, def stamper = null) {
        setAllTextFieldsBold(form)
        patchFieldWithComb(form, 'form1[0].#subform[0].Campoditesto2[3]', 6f)
        patchFieldWithComb(form, 'form1[0].#subform[0].Caselladicontrollo1[14]', 6f)
        setFieldAlignment(form, 'form1[0].#subform[0].Campoditesto3[17]', 2)

        Map<String, String> ufficialeAnagrafeFields = [
                "G8": "form1[0].#subform[0].TextField2[2]",
                "I3": "form1[0].#subform[0].TextField2[3]"
        ]
        Map<String, Map<String, String>> mapping = PdfManipulationUtils.loadMappingFromJson(PdfManipulationUtils.APR4_MAPPING_PREFIX_UN_COMPONENTE)
        PdfManipulationUtils.fillPdfForm(form, dataByLabel, mapping, stamper, ufficialeAnagrafeFields, true, [PdfManipulationUtils.ETICHETTA_C4, 'C9'], PdfManipulationUtils.TEMPLATE_UN_COMPONENTE)
    }

    private static void patchFieldWithComb(AcroFields form, String fieldName, float fontSize) {
        def item = form.getFieldItem(fieldName)
        if (!item) return
        int combFlag = 0x01000000
        for (int i = 0; i < item.size(); i++) {
            PdfDictionary merged = item.getMerged(i)
            PdfDictionary widget = item.getWidget(i)
            int currentFf = (merged.getAsNumber(PdfName.FF)?.intValue() ?: 0) | combFlag
            merged.put(PdfName.FF, new PdfNumber(currentFf))
            widget.put(PdfName.FF, new PdfNumber(currentFf))
        }
        form.setFieldProperty(fieldName, "textsize", fontSize, null)
    }

    private static void setFieldAlignment(AcroFields form, String fieldName, int quadding) {
        def item = form.getFieldItem(fieldName)
        if (!item) return
        for (int i = 0; i < item.size(); i++) {
            PdfDictionary merged = item.getMerged(i)
            PdfDictionary widget = item.getWidget(i)
            merged.put(PdfName.Q, new PdfNumber(quadding))
            widget.put(PdfName.Q, new PdfNumber(quadding))
        }
    }

    private static void setAllTextFieldsBold(AcroFields form) {
        BaseFont bold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.WINANSI, BaseFont.NOT_EMBEDDED)
        new ArrayList<>(form.fields.keySet()).each { String fieldName ->
            try {
                if (form.getFieldType(fieldName) == AcroFields.FIELD_TYPE_TEXT) {
                    form.setFieldProperty(fieldName, "textfont", bold, null)
                }
            } catch (Exception ignored) {
            }
        }
    }

}
