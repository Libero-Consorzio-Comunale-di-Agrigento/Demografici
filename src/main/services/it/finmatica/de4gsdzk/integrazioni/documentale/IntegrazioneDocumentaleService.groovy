package it.finmatica.de4gsdzk.integrazioni.documentale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import it.finmatica.smartdoc.api.DocumentaleService
import it.finmatica.smartdoc.api.struct.Campo
import it.finmatica.smartdoc.api.struct.Documento
import it.finmatica.smartdoc.api.struct.File
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import java.sql.SQLException

@Slf4j
@Transactional
@Service
class IntegrazioneDocumentaleService {

    static final String PARAMETRO_AREA_GDM      = "AREA"
    static final String PARAMETRO_MODELLO_GDM   = "MODELLO"

    private final DocumentaleService documentaleService
    private final DocumentaleService documentaleServiceStaticUser

    IntegrazioneDocumentaleService(
            @Qualifier("documentaleService") DocumentaleService documentaleService,
            @Qualifier("documentaleServiceStaticUser") DocumentaleService documentaleServiceStaticUser) {
        this.documentaleService = documentaleService
        this.documentaleServiceStaticUser = documentaleServiceStaticUser
    }

    InputStream getFile(IDocumentoEsterno documento,
                        IFileDocumentoEsterno fileDocumento,
                        boolean useStaticUser = false,
                        boolean escludiControlloCompetenze = false) {
        if (!(fileDocumento.idFileEsterno > 0)) {
            throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_recupero_file_documentale"))
        }

        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        Documento smartDoc
        if (!(documento.idDocumentoEsterno > 0)) {
            smartDoc = new Documento()
        } else {
            smartDoc = getDocumento(documento.idDocumentoEsterno.toString(), escludiControlloCompetenze, useStaticUser)
        }

        smartDoc.addChiaveExtra("ESCLUDI_CONTROLLO_COMPETENZE", "Y")

        File fileRet = new File()
        fileRet.setId(fileDocumento.idFileEsterno.toString())

        fileRet = service.getFile(smartDoc, fileRet)
        return fileRet.getInputStream()
    }

    void removeFile(IDocumentoEsterno documento,
                    IFileDocumentoEsterno fileDocumento,
                    boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        if (!(documento.idDocumentoEsterno > 0)) {
            log.warn("Non è possibile eliminare il file '${fileDocumento.nome}': il documento non è ancora stato salvato sul documentale.")
            throw new FileNonValidoRuntimeException(Etichette.getEtichetta("Errore_cancellazione_file_documentale"))
        }

        File fileToDelete = new File(fileDocumento.nome)
        Documento smartDoc = new Documento()
        smartDoc.setId(documento.idDocumentoEsterno?.toString())

        smartDoc.addChiaveExtra("ESCLUDI_CONTROLLO_COMPETENZE", "Y")
        smartDoc = service.getDocumento(smartDoc, new ArrayList<Documento.COMPONENTI>())

        smartDoc.removeFile(fileToDelete)
        service.salvaDocumento(smartDoc)
    }

    /**
     * 	Cambia il nome del file su GDM
     */
    void renameFileName(Long idFileEsterno, String fileName, boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        Documento smartDoc = new Documento()

        File fileOriginale = new File()
        fileOriginale.setId("" + idFileEsterno)
        fileOriginale = service.getFile(smartDoc, fileOriginale)
        fileOriginale.setNome(fileName)

        smartDoc.addFile(fileOriginale)
        service.salvaDocumento(smartDoc)
    }

    Documento allineaGdm(IDocumentoEsterno documento, List<Campo> mde, boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        Documento docuSaved = null
        if (documento.idDocumentoEsterno != null) {
            Documento smartDoc = getDocumento(Long.toString(documento.idDocumentoEsterno), false, useStaticUser)
            for (Campo c : mde) {
                smartDoc.addCampo(c)
            }
            docuSaved = service.salvaDocumento(smartDoc)
            if ((docuSaved?.id == null) || ((Long.parseLong(docuSaved.id)).compareTo(0L) <= 0)) {
                throw new DocumentaleRuntimeException("Errore in fase di salvataggio: impossibile aggiornare il documento su sistema documentale")
            }
        }
        return docuSaved
    }

    Documento salva(IDocumentoEsterno documento, List<Campo> metadati, EModelloGdm modelloGdm, boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        Documento smartDoc = new Documento()
        smartDoc.addChiaveExtra(PARAMETRO_AREA_GDM, GsdDocumentoEsternoBaseDomain.AREA_GDM)
        smartDoc.addChiaveExtra(PARAMETRO_MODELLO_GDM, modelloGdm.id)

        for (Campo c : metadati) {
            smartDoc.addCampo(c)
        }

        Documento docuSaved = service.salvaDocumento(smartDoc)
        if ((docuSaved?.id == null) || ((Long.parseLong(docuSaved.id)).compareTo(0L) <= 0)) {
            throw new DocumentaleRuntimeException("Errore in fase di salvataggio: impossibile registrare il documento su sistema documentale")
        }
        return docuSaved
    }

    void addFileToDocumentale(IDocumentoEsterno documento,
                              IFileDocumentoEsterno fileDocumento,
                              InputStream is,
                              List<Campo> metadati,
                              boolean escludiControlloCompetenze = false,
                              EModelloGdm modelloGdm,
                              boolean useStaticUser = false) {
        // per prima cosa salvo il documento sia sulla mia base dati che sul documentale se non è già salvato:
        if (!(documento.idDocumentoEsterno > 0)) {
            Documento smartDoc = salva(documento, metadati, modelloGdm, useStaticUser)
            documento.idDocumentoEsterno = Long.parseLong(smartDoc.getId())
        }

        // salvo il file sul documentale
        if (is != null) {
            salvaFile(documento, fileDocumento, is, escludiControlloCompetenze, useStaticUser)
        }
    }

    private IFileDocumentoEsterno salvaFile(IDocumentoEsterno documento,
                                            IFileDocumentoEsterno fileDocumento,
                                            InputStream inputStream,
                                            boolean escludiControlloCompetenze = false,
                                            boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        boolean creatoNuovoFile = true

        File fileToSave = new File()
        if (fileDocumento.idFileEsterno > 0) {
            fileToSave.setId(fileDocumento.idFileEsterno.toString())
            creatoNuovoFile = false
        }
        fileToSave.setNome(fileDocumento.nome)
        fileToSave.setInputStream(inputStream)

        Documento smartDoc = getDocumento(Long.toString(documento.idDocumentoEsterno), escludiControlloCompetenze, useStaticUser)

        smartDoc.addFile(fileToSave)
        service.salvaDocumento(smartDoc)

        if (creatoNuovoFile) {
            fileDocumento.idFileEsterno = Long.parseLong(fileToSave.getId())
        }

        fileDocumento.setDocumento(documento)
        return fileDocumento
    }

    Documento getDocumento(String idDocumentoEsterno,
                           boolean escludiControlloCompetenze = false,
                           boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        try {
            Documento smartDoc = new Documento()

            if (escludiControlloCompetenze) {
                smartDoc.addChiaveExtra("ESCLUDI_CONTROLLO_COMPETENZE", "Y")
            }
            smartDoc.setId(idDocumentoEsterno)
            return service.getDocumento(smartDoc, [Documento.COMPONENTI.VERSIONI])
        } catch (SQLException e) {
            throw new DocumentaleRuntimeException(e)
        }
    }

    void eliminaDocumento(IDocumentoEsterno documento,
                          boolean escludiControlloCompetenze = false,
                          boolean useStaticUser = false) {
        DocumentaleService service = useStaticUser ? documentaleServiceStaticUser : documentaleService

        try {
            Documento smartDoc = getDocumento(documento.idDocumentoEsterno.toString(), escludiControlloCompetenze, useStaticUser)
            smartDoc.addChiaveExtra('ESCLUDI_CONTROLLO_COMPETENZE', 'Y')
            service.eliminaDocumento(smartDoc)
        } catch (Exception e) {
            throw new DocumentaleRuntimeException("Errore in fase di salvataggio: non è stato possibile cancellare il documento dal sistema documentale", e)
        }
    }

}
