package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.allegati.IAllegatoService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaDocumentoAllegatoService implements IAllegatoService {
    private final AnaDocumentoAllegatoRepository anaDocumentoAllegatoRepository
    private final AnaDocumentoRepository anaDocumentoRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final UtenteCustomService utenteCustomService
    private final GsdService gsdService

    AnaDocumentoAllegatoService(AnaDocumentoAllegatoRepository anaDocumentoAllegatoRepository,
                                AnaDocumentoRepository anaDocumentoRepository,
                                GsdFirmaService gsdFirmaService,
                                IntegrazioneDocumentaleService integrazioneDocumentaleService,
                                GsdService gsdService,
                                UtenteCustomService utenteCustomService) {
        this.anaDocumentoAllegatoRepository = anaDocumentoAllegatoRepository
        this.anaDocumentoRepository = anaDocumentoRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.utenteCustomService = utenteCustomService
        this.gsdService = gsdService
    }

    AnaDocumentoAllegato create(AnaDocumento documento, String nome) {
        if (documento.allegati != null && documento.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaDocumentoAllegato obj = new AnaDocumentoAllegato()
        obj.documento = documento
        obj.nome = nome
        obj.dataRegistrazione = DataUtils.getDataCorrente()
        obj.terminalista = utenteCustomService.getLoggedUser()

        if (documento.allegati == null) {
            documento.allegati = []
        }
        documento.allegati << obj

        return obj
    }

    List<AnaDocumentoAllegato> listAllByDocumento(AnaDocumento documento) {
        return anaDocumentoAllegatoRepository.findAllByDocumento(documento)
    }

    AnaDocumentoAllegato save(AnaDocumentoAllegato obj) {
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return anaDocumentoAllegatoRepository.save(obj)
    }

    void delete(AnaDocumentoAllegato obj) {
        if ( (obj.idFileEsterno != null) && (obj.documento.idDocumentoEsterno != null) ){
            integrazioneDocumentaleService.removeFile(obj.documento, obj)
        }
        // Cancello da ANADOC_ALLE
        log.info("Tento cancellazione su ANADOC_ALLE per id " + obj.id)
        anaDocumentoAllegatoRepository.delete(obj)
    }

    void deleteDocumento(AnaDocumentoAllegato obj) {
        //Al momento non esiste una cancellazione fisica del documento perciò elimino solo il collegamento al documentale
        //integrazioneDocumentaleService.eliminaDocumento(obj.documento, true)
        obj.documento.idDocumentoEsterno = null
        anaDocumentoRepository.save(obj.documento)
    }

    void saveAllegatoDocumentale(EModelloGdm modello, AnaDocumentoAllegato obj, byte[] bytes) {
        List<Campo> metadati = MetadatiGdmUtils.listMetadatiDocumentoAnagrafico(obj.documento)

        integrazioneDocumentaleService.addFileToDocumentale(obj.documento,
                obj,
                new ByteArrayInputStream(bytes),
                metadati,
                true,
                modello,
                true)

        // Aggiorno ID_DOCUMENTO_GDM
        anaDocumentoRepository.save(obj.documento)

        // Aggiorno ID_OGGETTO_FILE_GDM
        anaDocumentoAllegatoRepository.save(obj)
    }

    void saveAllegatoLocale(AnaDocumentoAllegato obj, byte[] bytes) {
        obj.blobAllegato = bytes

        anaDocumentoAllegatoRepository.save(obj)
    }

    void downloadAllegato(AnaDocumentoAllegato obj) {
        gsdFirmaService.scaricaAllegato(obj.documento, obj)
    }

    void updateNote(Long id, String note){
        anaDocumentoAllegatoRepository.updateNote(id, note)
    }

}
