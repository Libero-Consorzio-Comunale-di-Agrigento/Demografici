package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.anagrafe.errors.NomeAllegatoEsistenteRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaAnagrafeAllegatoService {
    private final AnaAnagrafeAllegatoRepository anaAnagrafeAllegatoRepository
    private final AnaAnagrafeRepository anaAnagrafeRepository
    private final GsdFirmaService gsdFirmaService
    private final IntegrazioneDocumentaleService integrazioneDocumentaleService
    private final StatoCivileService statoCivileService

    AnaAnagrafeAllegatoService(AnaAnagrafeAllegatoRepository anaAnagrafeAllegatoRepository,
                               AnaAnagrafeRepository anaAnagrafeRepository,
                               GsdFirmaService gsdFirmaService,
                               IntegrazioneDocumentaleService integrazioneDocumentaleService,
                               StatoCivileService statoCivileService) {
        this.anaAnagrafeAllegatoRepository = anaAnagrafeAllegatoRepository
        this.anaAnagrafeRepository = anaAnagrafeRepository
        this.gsdFirmaService = gsdFirmaService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
        this.statoCivileService = statoCivileService
    }

    AnaAnagrafeAllegato create(AnaAnagrafe anagrafe, String nome) {
        if (anagrafe.allegati != null && anagrafe.allegati.any { it.nome == nome }) {
            throw new NomeAllegatoEsistenteRuntimeException()
        }

        AnaAnagrafeAllegato obj = new AnaAnagrafeAllegato()
        obj.anagrafe = anagrafe
        obj.nome = nome

        if (anagrafe.allegati == null) {
            anagrafe.allegati = []
        }
        anagrafe.allegati << obj

        return obj
    }

    Page<AnaAnagrafeAllegato> listAllByAnagrafe(AnaAnagrafe anagrafe, PageRequest pr) {
        return anaAnagrafeAllegatoRepository.findByAnagrafe(anagrafe, pr)
    }

    AnaAnagrafeAllegato save(AnaAnagrafeAllegato obj) {
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = statoCivileService.getIdFromSequence(obj)
        }

        return anaAnagrafeAllegatoRepository.save(obj)
    }

    void delete(AnaAnagrafeAllegato obj) {
        anaAnagrafeAllegatoRepository.delete(obj)
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

}
