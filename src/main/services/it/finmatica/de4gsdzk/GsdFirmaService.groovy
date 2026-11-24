package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaDocumentoAllegato
import it.finmatica.de4gsdzk.anagrafe.AnaFamigliaAllegato
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IFileDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAllegato
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.jsign.api.SignedObjectReaderFactory
import it.finmatica.jsign.api.SignedObjectReaderI
import it.finmatica.smartdoc.api.struct.File
import org.apache.commons.io.FilenameUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.zkoss.zkmax.zul.Filedownload

@Slf4j
@Transactional
@Service
class GsdFirmaService {

    private final IntegrazioneDocumentaleService integrazioneDocumentaleService

    GsdFirmaService(IntegrazioneDocumentaleService integrazioneDocumentaleService) {
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
    }

    private InputStream getInputStreamAllegato(IDocumentoEsterno documento, IFileDocumentoEsterno fileDocumento){
        if (fileDocumento.idFileEsterno != null){
            return integrazioneDocumentaleService.getFile(documento, fileDocumento, false, true)
        }
        // TODO: add blobAllegato to IFileDocumentoEsterno
        if (fileDocumento instanceof CivComunicazioneAllegato) {
            return new ByteArrayInputStream(((CivComunicazioneAllegato)fileDocumento).blobAllegato)
        }
        // CivFascicoloAttoAllegato non ha il salvataggio di backup su blobAllegato
        //        if (fileDocumento instanceof CivFascicoloAttoAllegato) {
        //            return new ByteArrayInputStream(((CivFascicoloAttoAllegato) fileDocumento).blobAllegato)
        //        }
        if (fileDocumento instanceof CerCertificatoEmesso) {
            return new ByteArrayInputStream(((CerCertificatoEmesso) fileDocumento).blobAllegato)
        }
        if (fileDocumento instanceof AnaDocumentoAllegato) {
            return new ByteArrayInputStream(((AnaDocumentoAllegato) fileDocumento).blobAllegato)
        }
        if (fileDocumento instanceof AnaFamigliaAllegato) {
            return new ByteArrayInputStream(((AnaFamigliaAllegato) fileDocumento).blobAllegato)
        }
        return null
    }

    private File getSmartDocFile(IDocumentoEsterno documento, IFileDocumentoEsterno fileDocumento, boolean sbusta = false, boolean segnalaSbustamento = true) {
        InputStream inputStream = getInputStreamAllegato(documento, fileDocumento)

        if (inputStream == null) {
            throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_recupero_file_documentale"))
        }

        File fileRet = new File()
        fileRet.nome = fileDocumento.getNome()
        fileRet.contentType = FileUtils.getMimeType(FilenameUtils.getExtension(fileRet.nome))

        // se devo sbustare, sbusto e scarico il file
        if (sbusta) {
            //boolean v = FirmaUtils.verify(inputStream, false)
            if (FirmaUtils.isSigned(inputStream)) {
                if (segnalaSbustamento) {
                    throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Errore_sbustamento_file"))
                }
                try {
                    inputStream = getInputStreamAllegato(documento, fileDocumento)
                    SignedObjectReaderI reader = SignedObjectReaderFactory.getSignedObjectReader(inputStream)
                    fileRet.inputStream = reader.getOriginalContent()
                    fileRet.nome = FileUtils.getNomeFileSbustato(fileDocumento.getNome())
                    fileRet.contentType = FileUtils.getMimeType(FilenameUtils.getExtension(fileRet.nome))
                } catch (Exception e) {
                    log.error("Si è verificato un errore nello sbustare o convertire il file allegato con id ${fileDocumento.getNome()}. Scarico il file originale.", e)
                    // rileggo il file originale siccome lo stream potrebbe essere stato "consumato" anche solo parzialmente.
                    fileRet.inputStream = getInputStreamAllegato(documento, fileDocumento)
                }
            } else {
                fileRet.inputStream = getInputStreamAllegato(documento, fileDocumento)
            }
            fileRet.nome = FileUtils.getNomeFileSbustato(fileDocumento.getNome())
            fileRet.contentType = FileUtils.getMimeType(FilenameUtils.getExtension(fileRet.nome))
        } else {
            fileRet.inputStream = getInputStreamAllegato(documento, fileDocumento)
        }

        return fileRet
    }

    void scaricaAllegato(IDocumentoEsterno documento, IFileDocumentoEsterno fileDocumento, boolean sbusta = false, boolean segnalaSbustamento = true) {
        File smartDocFile = getSmartDocFile(documento, fileDocumento, sbusta, segnalaSbustamento)
        Filedownload.save(smartDocFile.inputStream, smartDocFile.contentType, smartDocFile.nome)
    }

    void scaricaAllegati(String nome, IDocumentoEsterno documento, List<IFileDocumentoEsterno> fileDocumenti, boolean sbusta = false, boolean segnalaSbustamento = true) {

        if (fileDocumenti.size() == 1) {
            scaricaAllegato(documento, fileDocumenti.first(), sbusta, segnalaSbustamento)
            return
        }

        List<ZipUtils.VirtualFile> virtualFiles = fileDocumenti.collect {
            File smartDocFile = getSmartDocFile(documento, it, sbusta, segnalaSbustamento)

            return new ZipUtils.VirtualFile(smartDocFile.nome, smartDocFile.inputStream)
        }

        String filename = "${nome}.${ETipoFile.ZIP.estensione}"
        byte[] zipContent = ZipUtils.zipFiles(virtualFiles)
        String contentType = FileUtils.getMimeType(FilenameUtils.getExtension(filename))

        Filedownload.save(zipContent, contentType, nome)
    }

    // Crea uno ZIP con i principali allegati di comunicazioni diverse (un documento per allegato).
    void scaricaAllegatiZip(String nomeZip, List<IComunicazioneAllegato> allegati) {
        if (allegati.isEmpty()) {
            return
        }
        if (allegati.size() == 1) {
            IComunicazioneAllegato alle = allegati.first()
            scaricaAllegato(alle.archivioComunicazione as IDocumentoEsterno, alle as IFileDocumentoEsterno, true)
            return
        }
        List<ZipUtils.VirtualFile> virtualFiles = allegati.collect { IComunicazioneAllegato alle ->
            File smartDocFile = getSmartDocFile(alle.archivioComunicazione as IDocumentoEsterno, alle as IFileDocumentoEsterno, true, true)
            return new ZipUtils.VirtualFile(smartDocFile.nome, smartDocFile.inputStream)
        }
        String filename = "${nomeZip}.${ETipoFile.ZIP.estensione}"
        byte[] zipContent = ZipUtils.zipFiles(virtualFiles)
        String contentType = FileUtils.getMimeType(FilenameUtils.getExtension(filename))
        Filedownload.save(zipContent, contentType, filename)
    }

}
