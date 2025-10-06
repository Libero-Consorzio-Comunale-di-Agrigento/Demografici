package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.GestioneTestiGsdModello
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

    static String getMimeType(String extension){
        for (ETipoFile tf : ETipoFile.values()) {
            if (tf.estensione.equalsIgnoreCase(extension)) {
                return tf.contentType
            }
        }
        return null
    }

    static Map<String, String> checkFile(byte[] allegatoDaControllare, String nomeAllegato, List<String> formatiAmmessi=null){
        String contentTypeDetected = new Tika().detect(allegatoDaControllare, nomeAllegato)
        List<String> acceptableMimeTypes = formatiAmmessi?:defaultAcceptableMimeTypes
        if (acceptableMimeTypes.contains(contentTypeDetected)) {
            if (Zip.isZip(allegatoDaControllare)) {
                try{
                    Zip.checkMaliciousZip(new ByteArrayInputStream(allegatoDaControllare))
                } catch(Exception ex){
                    return EtichetteMessaggi.Errore_file
                }
            }
        } else {
            return EtichetteMessaggi.Errore_file_formato
        }
        return null
    }

    static Map<String, String> checkNomeFile(String nomefile, char[] caratteriSpeciali=null){
        if (nomefile.contains("'")) {
            return EtichetteMessaggi.Errore_nome_file
        }
        if ( (nomefile != null) && (caratteriSpeciali != null) ) {
            for (char ch : caratteriSpeciali) {
                if (nomefile.contains(ch.toString())) {
                    return EtichetteMessaggi.Errore_nome_file
                }
            }
        }
        return null
    }

    static String getCodiceModelloComunicazioneStandard(Integer idComunicazione){
        return StringUtils.leftPad(idComunicazione.toString(), 3, "0")
    }

    static String getNomeModelloComunicazioneStandard(Integer idComunicazione){
        String codice = getCodiceModelloComunicazioneStandard(idComunicazione)
        String nomeModelloStandard = GestioneTestiGsdModello.PREFISSO_MODELLI_STANDARD + codice
        return nomeModelloStandard
    }

    static String getCodiceModelloComunicazioneAttoStandard(Integer tipoAtto, Integer idComunicazione){
        return (tipoAtto.toString() + StringUtils.leftPad(idComunicazione.toString(), 2, "0"))
    }

    static String getNomeModelloComunicazioneAttoStandard(Integer tipoAtto, Integer idComunicazione){
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

    static boolean isPdf(String nomeAllegato){
        return nomeAllegato.toLowerCase().endsWith("pdf")
    }

    static String getNomeFileSbustato(String nomeAllegato){
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

    static final List<Map> etichetteFileUtils = [EtichetteMessaggi.Errore_file, EtichetteMessaggi.Errore_file_formato, EtichetteMessaggi.Errore_nome_file]

}
