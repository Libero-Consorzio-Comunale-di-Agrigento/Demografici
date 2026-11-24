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
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaFamigliaAllegatoService implements  IAllegatoService {
    private final AnaFamigliaAllegatoRepository anaFamigliaAllegatoRepository
    private final AnaFamigliaRepository anaFamigliaRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final GsdService gsdService
    private final UtenteCustomService utenteCustomService

    AnaFamigliaAllegatoService(AnaFamigliaAllegatoRepository anaFamigliaAllegatoRepository,
                               AnaFamigliaRepository anaFamigliaRepository,
                               GsdFirmaService gsdFirmaService,
                               IntegrazioneDocumentaleService integrazioneDocumentaleService,
                               GsdService gsdService,
                               UtenteCustomService utenteCustomService) {
        this.anaFamigliaAllegatoRepository = anaFamigliaAllegatoRepository
        this.anaFamigliaRepository = anaFamigliaRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    AnaFamigliaAllegato create(AnaFamiglia famiglia, String nome) {
        if (famiglia.allegati != null && famiglia.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaFamigliaAllegato obj = new AnaFamigliaAllegato()
        obj.famiglia = famiglia
        obj.nome = nome
        obj.dataRegistrazione = DataUtils.getDataCorrente()
        obj.terminalista = utenteCustomService.getLoggedUser()

        if (famiglia.allegati == null) {
            famiglia.allegati = []
        }
        famiglia.allegati.add(obj)

        return obj
    }

    Page<AnaFamigliaAllegato> listAllByFamiglia(AnaFamiglia famiglia, PageRequest pr) {
        return anaFamigliaAllegatoRepository.findByFamiglia(famiglia, pr)
    }

    AnaFamigliaAllegato save(AnaFamigliaAllegato obj) {
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return anaFamigliaAllegatoRepository.save(obj)
    }

    void delete(AnaFamigliaAllegato obj) {
        if ( (obj.idFileEsterno != null) && (obj.famiglia.idDocumentoEsterno != null) ){
            integrazioneDocumentaleService.removeFile(obj.famiglia, obj)
        }
        // Cancello da ANAFAM_ALLE
        log.info("Tento cancellazione su ANAFAM_ALLE per id " + obj.id)
        anaFamigliaAllegatoRepository.delete(obj)

    }

    void deleteDocumento(AnaFamigliaAllegato obj) {
        //Al momento non esiste una cancellazione fisica del documento perciò elimino solo il collegamento al documentale
        //integrazioneDocumentaleService.eliminaDocumento(obj.anagrafe, true)
        obj.famiglia.idDocumentoEsterno = null
        anaFamigliaRepository.save(obj.famiglia)
    }

    void saveAllegatoDocumentale(AnaFamigliaAllegato obj, byte[] bytes) {
        EModelloGdm modello = EModelloGdm.Famiglia
        List<Campo> metadati = MetadatiGdmUtils.listMetadatiFamiglia(obj.famiglia)

        integrazioneDocumentaleService.addFileToDocumentale(obj.famiglia,
                obj,
                new ByteArrayInputStream(bytes),
                metadati,
                true,
                modello,
                true)

        // Aggiorno ID_DOCUMENTO_GDM
        anaFamigliaRepository.save(obj.famiglia)

        // Aggiorno ID_OGGETTO_FILE_GDM
        anaFamigliaAllegatoRepository.save(obj)
    }

    void saveAllegatoLocale(AnaFamigliaAllegato obj, byte[] bytes) {
        obj.blobAllegato = bytes

        anaFamigliaAllegatoRepository.save(obj)
    }

    void downloadAllegato(AnaFamigliaAllegato obj) {
        gsdFirmaService.scaricaAllegato(obj.famiglia, obj)
    }

    void downloadAllegati(AnaFamiglia obj) {
        String name = "allegatiFamiglia_${obj.id}"
        List<AnaFamigliaAllegato> allegati = obj.allegati.findAll { it.canDownload() }
        gsdFirmaService.scaricaAllegati(name, obj, allegati)
    }

    void updateNote(Long id, String note){
        anaFamigliaAllegatoRepository.updateNote(id, note)
    }

}
