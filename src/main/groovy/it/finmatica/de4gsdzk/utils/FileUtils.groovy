package it.finmatica.de4gsdzk.utils


import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.reporter2.mailmerge.services.FinmaticaMailMerge
import it.finmatica.reporter2.util.Zip
import org.apache.commons.lang.StringUtils
import org.apache.tika.Tika

class FileUtils {

    static List<String> defaultAcceptableMimeTypes = [ETipoFile.TXT.contentType,
                                                      ETipoFile.P7M.contentType,
                                                      ETipoFile.P7S.contentType,
                                                      ETipoFile.DOC.contentType,
                                                      ETipoFile.PDF.contentType,
                                                      ETipoFile.ODT.contentType,
                                                      ETipoFile.DOCX.contentType]

    // refs #62971
    static List<String> defaultAcceptableMimeTypesXComEFas = [ETipoFile.TXT.contentType,
                                                              ETipoFile.P7M.contentType,
                                                              ETipoFile.P7S.contentType,
                                                              ETipoFile.DOC.contentType,
                                                              ETipoFile.PDF.contentType,
                                                              ETipoFile.ODT.contentType,
                                                              ETipoFile.DOCX.contentType,
                                                              "application/x-dbf",
                                                              ETipoFile.XLS.contentType,
                                                              ETipoFile.CSV.contentType,
                                                              ETipoFile.XML.contentType,
                                                              ETipoImage.JPG.contentType,
                                                              ETipoImage.JPEG.contentType,
                                                              ETipoImage.BMP.contentType,
                                                              ETipoImage.MSBMP.contentType,
                                                              ETipoImage.PNG.contentType,
                                                              ETipoImage.TIF.contentType,
                                                              ETipoImage.TIFF.contentType]

    /*static List<String> defaultAcceptableFilesXAnsc = [ETipoFile.DOC.estensione,
                                                       ETipoFile.PDF.estensione,
                                                       ETipoFile.DOCX.estensione,
                                                       ETipoImage.TIF.estensione,
                                                       ETipoImage.TIFF.estensione]*/

    static List<String> defaultAcceptableMimeTypesXAnaDoc = [ETipoFile.PDF.contentType,
                                                             ETipoImage.JPG.contentType,
                                                             ETipoImage.JPEG.contentType]

    static List<String> defaultAcceptableMimeTypesXImg = [ETipoImage.JPG.contentType, ETipoImage.JPEG.contentType,
                                                          ETipoImage.BMP.contentType, ETipoImage.MSBMP.contentType,
                                                          ETipoImage.PNG.contentType]

    static List<String> defaultAcceptableMimeTypesXP12 = [ETipoFile.P12.contentType]

    static List<String> defaultAcceptableMimeTypesXModelli = [ETipoFile.ODT.contentType, ETipoFile.DOC.contentType, ETipoFile.DOCX.contentType]

    static String getMimeType(String extension) {
        for (ETipoFile tf : ETipoFile.values()) {
            if (tf.estensione.equalsIgnoreCase(extension)) {
                return tf.contentType
            }
        }
        return null
    }

    static Map<String, String> checkFile(byte[] allegatoDaControllare, List<String> formatiAmmessi = null) {
        // Rilevazione MIME type basata esclusivamente sull'intestazione (magic bytes) del file,
        // senza considerare il nome del file, in conformità ai requisiti ISO 27001.
        String contentTypeDetected = new Tika().detect(allegatoDaControllare)
        List<String> acceptableMimeTypes = formatiAmmessi ?: defaultAcceptableMimeTypes
        if (acceptableMimeTypes.contains(contentTypeDetected)) {
            if (Zip.isZip(allegatoDaControllare)) {
                try {
                    Zip.checkMaliciousZip(new ByteArrayInputStream(allegatoDaControllare))
                } catch (Exception ex) {
                    return Etichette.getEtichetta("Errore_file")
                }
            }
        } else {
            return Etichette.getEtichetta("Errore_file_formato")
        }
        return null
    }

    static Map<String, String> checkNomeFile(String nomefile, char[] caratteriSpeciali = null) {
        if (nomefile.contains("'")) {
            return Etichette.getEtichetta("Errore_nome_file")
        }
        if ((nomefile != null) && (caratteriSpeciali != null)) {
            for (char ch : caratteriSpeciali) {
                if (nomefile.contains(ch.toString())) {
                    return Etichette.getEtichetta("Errore_nome_file")
                }
            }
        }
        return null
    }

    static String getCodiceModelloComunicazioneStandard(Integer idComunicazione) {
        return StringUtils.leftPad(idComunicazione.toString(), 3, "0")
    }

    static String getNomeModelloComunicazioneStandard(Integer idComunicazione) {
        String codice = getCodiceModelloComunicazioneStandard(idComunicazione)
        String nomeModelloStandard = GestioneTestiGsdModello.PREFISSO_MODELLI_STANDARD + codice
        return nomeModelloStandard
    }

    static String getCodiceModelloComunicazioneAttoStandard(Integer tipoAtto, Integer idComunicazione) {
        return (tipoAtto.toString() + StringUtils.leftPad(idComunicazione.toString(), 2, "0"))
    }

    static String getNomeModelloComunicazioneAttoStandard(Integer tipoAtto, Integer idComunicazione) {
        String codice = getCodiceModelloComunicazioneAttoStandard(tipoAtto, idComunicazione)
        String nomeModelloStandard = GestioneTestiGsdModello.PREFISSO_MODELLI_STANDARD + codice
        return nomeModelloStandard
    }

    static String getCodiceModelloTipoCertificatoStandard(String idTipoCertificato) {
        return (GestioneTestiGsdModello.PREFISSO_MODELLI_TIPO_CERTIFICATO + idTipoCertificato)
    }

    static String getNomeModelloTipoCertificatoStandard(String idTipoCertificato) {
        String nomeModelloStandard = getCodiceModelloTipoCertificatoStandard(idTipoCertificato) + GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT
        return nomeModelloStandard
    }

    static String getIdTipoCertificatoFromNomeModello(String nomeModello) {
        return nomeModello.replace(GestioneTestiGsdModello.PREFISSO_MODELLI_TIPO_CERTIFICATO, '').replace(GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT, '')
    }

    static String getNomeFileSbustato(String nomeAllegato) {
        return nomeAllegato.replaceAll(/(\.[pP]7[mM])$/, "")
    }

    static String sanitizeFilename(String input) {
        if (!input) {
            return ''
        }

        // Replace invalid characters with underscores
        def sanitized = input
        // Replace characters that are illegal in most filesystems
                .replaceAll(/[\\/:*?"<>|]/, '')
        // Replace multiple spaces/dots with single ones
                .replaceAll(/\s+/, '')
                .replaceAll(/\.+/, '')
        // Remove leading/trailing spaces and dots
                .trim()
                .replaceAll(/^\.+|\.+$/, '')
        // Replace any remaining non-printable characters
                .replaceAll(/[^\x20-\x7E]/, '')
        // Limit length to 255 characters (common filesystem limit)
                .take(255)

        // If filename would be empty after sanitization, provide a default
        return sanitized ?: 'unknown'
    }

    static String getNomeModelloComunicazioneAnagrafeStandard(ETipoModello tipoModello, String codiceModello) {
        if (tipoModello == ETipoModello.P) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_ADEMPIMENTI_ANA + codiceModello + GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT
        } else if (tipoModello == ETipoModello.C) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_COMUNICAZIONI_ANA + codiceModello + GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT
        } else if (tipoModello == ETipoModello.F) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_CDF_ANA + codiceModello + GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT
        } else if (tipoModello == ETipoModello.E) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_ETICHETTE_ANA + codiceModello + GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT
        }
    }

    static String getCodiceModelloComunicazioneAnagrafeStandard(ETipoModello tipoModello, String codiceModello) {
        if (tipoModello == ETipoModello.P) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_ADEMPIMENTI_ANA + codiceModello
        } else if (tipoModello == ETipoModello.C) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_COMUNICAZIONI_ANA + codiceModello
        } else if (tipoModello == ETipoModello.F) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_CDF_ANA + codiceModello
        } else if (tipoModello == ETipoModello.E) {
            return GestioneTestiGsdModello.PREFISSO_MODELLI_ETICHETTE_ANA + codiceModello
        }
    }

    static String getIdModelloAnagrafeFromNomeModello(String nomeModello) {
        if (nomeModello.startsWith(GestioneTestiGsdModello.PREFISSO_MODELLI_ADEMPIMENTI_ANA)) {
            return ETipoModello.P.id + nomeModello.replace(GestioneTestiGsdModello.PREFISSO_MODELLI_ADEMPIMENTI_ANA, '').replace(GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT, '')
        } else if (nomeModello.startsWith(GestioneTestiGsdModello.PREFISSO_MODELLI_COMUNICAZIONI_ANA)) {
            return ETipoModello.C.id + nomeModello.replace(GestioneTestiGsdModello.PREFISSO_MODELLI_COMUNICAZIONI_ANA, '').replace(GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT, '')
        } else if (nomeModello.startsWith(GestioneTestiGsdModello.PREFISSO_MODELLI_CDF_ANA)) {
            return ETipoModello.F.id + nomeModello.replace(GestioneTestiGsdModello.PREFISSO_MODELLI_CDF_ANA, '').replace(GestioneTestiGsdModello.SUFFISSO_MODELLI_DEFAULT, '')
        }
        return ""

    }

    static byte[] convertPdfToPdfA(InputStream inputStream) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream()
        FinmaticaMailMerge.conversionAsposePdfA(inputStream, outputStream)
        return outputStream.toByteArray()
    }

    static final List<Map> etichetteFileUtils = [Etichette.getEtichetta("Errore_file"), Etichette.getEtichetta("Errore_file_formato"), Etichette.getEtichetta("Errore_nome_file")]

}
