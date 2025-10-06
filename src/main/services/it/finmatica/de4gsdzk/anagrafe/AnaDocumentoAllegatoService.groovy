package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaDocumentoAllegatoService {
    private final AnaDocumentoAllegatoRepository anaDocumentoAllegatoRepository
    private final AnaDocumentoRepository anaDocumentoRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final StatoCivileService statoCivileService

    AnaDocumentoAllegatoService(AnaDocumentoAllegatoRepository anaDocumentoAllegatoRepository,
                                AnaDocumentoRepository anaDocumentoRepository,
                                GsdFirmaService gsdFirmaService,
                                IntegrazioneDocumentaleService integrazioneDocumentaleService,
                                StatoCivileService statoCivileService) {
        this.anaDocumentoAllegatoRepository = anaDocumentoAllegatoRepository
        this.anaDocumentoRepository = anaDocumentoRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.statoCivileService = statoCivileService
    }

    AnaDocumentoAllegato create(AnaDocumento documento, String nome) {
        if (documento.allegati != null && documento.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaDocumentoAllegato obj = new AnaDocumentoAllegato()
        obj.documento = documento
        obj.nome = nome

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
            obj.id = statoCivileService.getIdFromSequence(obj)
        }

        return anaDocumentoAllegatoRepository.save(obj)
    }

    void delete(AnaDocumentoAllegato obj) {
        anaDocumentoAllegatoRepository.delete(obj)
    }

    void saveAllegatoDocumentale(EModelloGdm modello, boolean escludiControlloCompetenza, AnaDocumentoAllegato obj, byte[] bytes) {
        List<Campo> metadati = MetadatiGdmUtils.listMetadatiDocumentoAnagrafico(obj.documento)

        integrazioneDocumentaleService.addFileToDocumentale(obj.documento,
                obj,
                new ByteArrayInputStream(bytes),
                metadati,
                escludiControlloCompetenza,
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

}
