package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.allegati.IAllegatoService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaAnagrafeAllegatoService implements  IAllegatoService {
    private final AnaAnagrafeAllegatoRepository anaAnagrafeAllegatoRepository
    private final AnaAnagrafeRepository anaAnagrafeRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final UtenteCustomService utenteCustomService
    private final GsdService gsdService

    AnaAnagrafeAllegatoService(AnaAnagrafeAllegatoRepository anaAnagrafeAllegatoRepository,
                               AnaAnagrafeRepository anaAnagrafeRepository,
                               GsdFirmaService gsdFirmaService,
                               IntegrazioneDocumentaleService integrazioneDocumentaleService,
                               GsdService gsdService,
                               UtenteCustomService utenteCustomService) {
        this.anaAnagrafeAllegatoRepository = anaAnagrafeAllegatoRepository
        this.anaAnagrafeRepository = anaAnagrafeRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    AnaAnagrafeAllegato create(AnaAnagrafe anagrafe, String nome) {
        if (anagrafe.allegati != null && anagrafe.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaAnagrafeAllegato obj = new AnaAnagrafeAllegato()
        obj.anagrafe = anagrafe
        obj.nome = nome
        obj.dataRegistrazione = DataUtils.getDataCorrente()
        obj.terminalista = utenteCustomService.getLoggedUser()

        if (anagrafe.allegati == null) {
            anagrafe.allegati = []
        }
        anagrafe.allegati.add(obj)

        return obj
    }

    Page<AnaAnagrafeAllegato> listAllByAnagrafe(AnaAnagrafe anagrafe, PageRequest pr) {
        return anaAnagrafeAllegatoRepository.findByAnagrafe(anagrafe, pr)
    }

    AnaAnagrafeAllegato save(AnaAnagrafeAllegato obj) {
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return anaAnagrafeAllegatoRepository.save(obj)
    }

    void delete(AnaAnagrafeAllegato obj) {
        if ( (obj.idFileEsterno != null) && (obj.anagrafe.idDocumentoEsterno != null) ){
            integrazioneDocumentaleService.removeFile(obj.anagrafe, obj)
        }
        // Cancello da ANAANA_ALLE
        log.info("Tento cancellazione su ANAANA_ALLE per id " + obj.id)
        anaAnagrafeAllegatoRepository.delete(obj)
    }

    void deleteDocumento(AnaAnagrafeAllegato obj) {
        //Al momento non esiste una cancellazione fisica del documento perciò elimino solo il collegamento al documentale
        //integrazioneDocumentaleService.eliminaDocumento(obj.anagrafe, true)
        obj.anagrafe.idDocumentoEsterno = null
        anaAnagrafeRepository.save(obj.anagrafe)
    }

    void saveAllegatoDocumentale(AnaAnagrafeAllegato obj, byte[] bytes) {
        EModelloGdm modello = EModelloGdm.Individuo
        List<Campo> metadati = MetadatiGdmUtils.listMetadatiIndividuo(obj.anagrafe)

        integrazioneDocumentaleService.addFileToDocumentale(obj.anagrafe,
                obj,
                new ByteArrayInputStream(bytes),
                metadati,
                true,
                modello,
                true)

        // Aggiorno ID_DOCUMENTO_GDM
        anaAnagrafeRepository.save(obj.anagrafe)

        // Aggiorno ID_OGGETTO_FILE_GDM
        anaAnagrafeAllegatoRepository.save(obj)
    }

    void saveAllegatoLocale(AnaAnagrafeAllegato obj, byte[] bytes) {
        obj.blobAllegato = bytes

        anaAnagrafeAllegatoRepository.save(obj)
    }

    void downloadAllegato(AnaAnagrafeAllegato obj) {
        gsdFirmaService.scaricaAllegato(obj.anagrafe, obj)
    }

    void downloadAllegati(AnaAnagrafe obj) {
        String name = "${obj.cognome}${obj.nome ? "_${obj.nome}" : "allegatiIndividuo"}"
        List<AnaAnagrafeAllegato> allegati = obj.allegati.findAll { it.canDownload() }
        gsdFirmaService.scaricaAllegati(name, obj, allegati)
    }

    void updateNote(Long id, String note){
        anaAnagrafeAllegatoRepository.updateNote(id, note)
    }

}
