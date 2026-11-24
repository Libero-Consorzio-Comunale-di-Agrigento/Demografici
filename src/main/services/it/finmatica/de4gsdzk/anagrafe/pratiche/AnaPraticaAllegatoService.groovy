package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.allegati.IAllegatoService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaComunicazioneAllegato
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
class AnaPraticaAllegatoService implements IAllegatoService {
    private final AnaPraticaAllegatoRepository anaPraticaAllegatoRepository
    private final AnaPraticaRepository anaPraticaRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final UtenteCustomService utenteCustomService
    private final GsdService gsdService

    AnaPraticaAllegatoService(AnaPraticaAllegatoRepository anaPraticaAllegatoRepository,
                              AnaPraticaRepository anaPraticaRepository,
                              GsdFirmaService gsdFirmaService,
                              IntegrazioneDocumentaleService integrazioneDocumentaleService,
                              GsdService gsdService,
                              UtenteCustomService utenteCustomService) {
        this.anaPraticaAllegatoRepository = anaPraticaAllegatoRepository
        this.anaPraticaRepository = anaPraticaRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    AnaPraticaAllegato create(AnaPratica pratica, String nome) {
        if (pratica.allegati != null && pratica.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaPraticaAllegato obj = new AnaPraticaAllegato()
        obj.pratica = pratica
        obj.nome = nome
        obj.dataRegistrazione = DataUtils.getDataCorrente()
        obj.terminalista = utenteCustomService.getLoggedUser()

        if (pratica.allegati == null) {
            pratica.allegati = []
        }
        pratica.allegati.add(obj)

        return obj
    }

    AnaPraticaAllegato createXAllegatoComunicazione(AnaPratica pratica, AnaComunicazioneAllegato civcomAlle) {
        AnaPraticaAllegato fal = new AnaPraticaAllegato(pratica: pratica, allegatoComunicazione: civcomAlle)
        return fal
    }

    AnaPraticaAllegato getByPraticaAndAllegatoComunicazione(Long idPratica, Long idComAlle) {
        AnaPraticaAllegato fal = anaPraticaAllegatoRepository.findByIdPraticaAndIdAllegatoComunicazione(idPratica, idComAlle)
        return fal
    }

    Page<AnaPraticaAllegato> listAllByPratica(AnaPratica pratica, PageRequest pr) {
        return anaPraticaAllegatoRepository.findByPratica(pratica, pr)
    }

    AnaPraticaAllegato save(AnaPraticaAllegato obj) {
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return anaPraticaAllegatoRepository.save(obj)
    }

    void delete(AnaPraticaAllegato obj) {
        if ((obj.idFileEsterno != null) && (obj.pratica.idDocumentoEsterno != null)) {
            integrazioneDocumentaleService.removeFile(obj.pratica, obj)
        }
        // Cancello da ANATPR_ALLE
        log.info("Tento cancellazione su ANATPR_ALLE per id " + obj.id)
        anaPraticaAllegatoRepository.delete(obj)
    }

    void deleteDocumento(AnaPraticaAllegato obj) {
        //Al momento non esiste una cancellazione fisica del documento perciò elimino solo il collegamento al documentale
        //integrazioneDocumentaleService.eliminaDocumento(obj.pratica, true)
        obj.pratica.idDocumentoEsterno = null
        anaPraticaRepository.save(obj.pratica)
    }

    void saveAllegatoDocumentale(AnaPraticaAllegato obj, byte[] bytes) {
        EModelloGdm modello = EModelloGdm.Pratica
        List<Campo> metadati = MetadatiGdmUtils.listMetadatiPratica(obj.pratica)

        integrazioneDocumentaleService.addFileToDocumentale(obj.pratica,
                obj,
                new ByteArrayInputStream(bytes),
                metadati,
                true,
                modello,
                true)

        // Aggiorno ID_DOCUMENTO_GDM
        anaPraticaRepository.save(obj.pratica)

        // Aggiorno ID_OGGETTO_FILE_GDM
        anaPraticaAllegatoRepository.save(obj)
    }

    void saveAllegatoLocale(AnaPraticaAllegato obj, byte[] bytes) {
        obj.blobAllegato = bytes

        anaPraticaAllegatoRepository.save(obj)
    }

    void downloadAllegato(AnaPraticaAllegato obj) {
        gsdFirmaService.scaricaAllegato(obj.pratica, obj)
    }

    void downloadAllegati(AnaPratica obj) {
        String name = "${obj.tipoPratica.etichettaDesc.codice}_${obj.archivioAnagrafe.etichettaDesc.codice}-${obj.numero}-${obj.anno}"
        List<AnaPraticaAllegato> allegati = obj.allegati.findAll { it.canDownload() }
        gsdFirmaService.scaricaAllegati(name, obj, allegati)
    }

    void updateNote(Long id, String note) {
        anaPraticaAllegatoRepository.updateNote(id, note)
    }

}
