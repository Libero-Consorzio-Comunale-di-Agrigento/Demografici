package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.errors.ErroreAllegatoDocumentaleRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneAllegatoService implements IComunicazioneAllegatoService, TraitComunicazioneAllegatoService {

    private final CivArchivioComunicazioneService civArchivioComunicazioneService

    private final CivFascicoloAttoService civFascicoloAttoService

    private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    private final IntegrazioneDocumentaleService integrazioneDocumentaleService

    private final GsdService gsdService

    private final CivComunicazioneAllegatoRepository civComunicazioneAllegatoRepository

    CivComunicazioneAllegatoService(CivComunicazioneAllegatoRepository civComunicazioneAllegatoRepository, GsdService gsdService,
                                    CivArchivioComunicazioneService civArchivioComunicazioneService, IntegrazioneDocumentaleService integrazioneDocumentaleService,
                                    CivFascicoloAttoService civFascicoloAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

        this.civComunicazioneAllegatoRepository = civComunicazioneAllegatoRepository
        this.gsdService = gsdService
        this.civArchivioComunicazioneService = civArchivioComunicazioneService
        this.civFascicoloAttoService = civFascicoloAttoService
        this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
        this.integrazioneDocumentaleService = integrazioneDocumentaleService
    }

    @Override
    IComunicazioneAllegatoRepository getComunicazioneAllegatoRepository() {
        return civComunicazioneAllegatoRepository
    }

    @Override
    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return civArchivioComunicazioneService
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }

    CivComunicazioneAllegato save(CivComunicazioneAllegato obj, Boolean salvaSuDocumentale, InputStream is, Boolean ignoreStato = Boolean.FALSE, Boolean ignoreStampaEseguita = Boolean.FALSE, Boolean aggiornaStampaEseguita = Boolean.FALSE) {
        validaDati(obj, ignoreStato, ignoreStampaEseguita)

        CivArchivioComunicazione arcCom = civArchivioComunicazioneService.get(obj.archivioComunicazione.id) as CivArchivioComunicazione
        if (salvaSuDocumentale) {
            if (arcCom.idDocumentoEsterno == null) {
                // Devo salvare su gdm
                civArchivioComunicazioneService.save(arcCom, Boolean.TRUE, Boolean.TRUE, Boolean.TRUE)
            }
            //Posso leggere id_atto da arcCom perchè arcCom è già su db
            String identificativo = (arcCom.idAtto ?: gsdService.getIdentificativoAtto(arcCom.tipoAtto, arcCom.ufficio, arcCom.anno, arcCom.parte, arcCom.serie, arcCom.atto))
            List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(arcCom, identificativo)
            integrazioneDocumentaleService.addFileToDocumentale(arcCom, obj, is, metadati, true, EModelloGdm.FascicoliStatoCivile)
        }

        if (aggiornaStampaEseguita) {
            if (arcCom.isDaProtocollare() || arcCom.isDaInviareAlbo()) {
                log.info(arcCom.id + ": non aggiorno il flag stampa_eseguita in quanto comunicazione da protocollare o inviare all'albo")
            } else {
                arcCom.stampaEseguita = Boolean.TRUE
                civArchivioComunicazioneService.save(arcCom, Boolean.TRUE)
            }
        }

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su CIVCOM_ALLE per id " + obj.id)
        CivComunicazioneAllegato savedComAlle = civComunicazioneAllegatoRepository.save(obj)
        return savedComAlle
    }

    private Boolean fascicolaAllegato(CivComunicazioneAllegato obj, CivFascicoloAtto fascicoloAtto, IDaFascicolare df, Boolean salvaPregressoSuDocumentale = Boolean.FALSE) {
        Boolean allegatoAggiuntoAlFascicolato = Boolean.FALSE
        CivFascicoloAtto fa = fascicoloAtto
        if (fa == null) {
            fa = civArchivioComunicazioneService.fascicolaComunicazione(obj.archivioComunicazione, df, salvaPregressoSuDocumentale)
        }

        if (salvaPregressoSuDocumentale && obj.blobAllegato) {
            save(obj, Boolean.TRUE, new ByteArrayInputStream(obj.blobAllegato), Boolean.TRUE, Boolean.TRUE)
        }

        CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.getByFascicoloAndComunicazioneAllegato(fa.id, obj.id)
        if (fal == null) {
            fal = civFascicoloAttoAllegatoService.createXAllegatoComunicazione(fa, obj)
            allegatoAggiuntoAlFascicolato = Boolean.TRUE
        }
        // Mantengo sempre allineato il nome del file
        fal.nome = obj.getNome()
        civFascicoloAttoAllegatoService.save(fal, Boolean.FALSE, null)

        return allegatoAggiuntoAlFascicolato
    }

    int fascicolaComunicazioneEAllegati(CivArchivioComunicazione arcCom, IDaFascicolare df, Boolean salvaPregressoSuDocumentale = Boolean.FALSE) {
        int retVal = -1 //Comunicazione già fascicolata (Valori possibili: -1, 0, 1)
        // Controllo nome file univoco
        List<CivComunicazioneAllegato> listaAllegatiComunicazione = []
        for (CivComunicazioneAllegato a : listAllMetadatiByArchivioComunicazione(arcCom.id) as List<CivComunicazioneAllegato>) {
            CivComunicazioneAllegato alleCom = get(a.id) as CivComunicazioneAllegato
            listaAllegatiComunicazione.add(alleCom)
            validaDati(alleCom, Boolean.TRUE, Boolean.TRUE)
        }
        if (listaAllegatiComunicazione.size() == 0) {
            retVal = 0 // Nessun allegato da fascicolare
        }

        CivFascicoloAtto fa = civArchivioComunicazioneService.fascicolaComunicazione(arcCom, df, salvaPregressoSuDocumentale)

        for (CivComunicazioneAllegato alleCom : listaAllegatiComunicazione) {
            if (fascicolaAllegato(alleCom, fa, df, salvaPregressoSuDocumentale)) {
                retVal = 1 // Almeno un allegato fascicolato
            }
        }
        return retVal
    }

    @Override
    void deleteAllegato(IComunicazioneAllegato _obj) {
        CivComunicazioneAllegato obj = _obj as CivComunicazioneAllegato
        validaDatiPre(obj)
        // Cancello dal documentale
        if ((obj.idFileEsterno != null) && (obj.archivioComunicazione.idDocumentoEsterno != null)) {
            integrazioneDocumentaleService.removeFile(obj.archivioComunicazione, obj)
        }
        // Cancello dal fascicolo
        CivFascicoloAtto fa = civFascicoloAttoService.getByUkAttoAndTipoAttoAndArchivioComunicazione(obj.archivioComunicazione.idAtto, obj.archivioComunicazione.tipoAtto, obj.archivioComunicazione)
        if (fa != null) {
            CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.getByFascicoloAndComunicazioneAllegato(fa.id, obj.id)
            civFascicoloAttoAllegatoService.deleteAllegato(fal)
        }
        //Cancello da civcom_alle
        log.info("Tento cancellazione su CIVCOM_ALLE per id " + obj.id)
        civComunicazioneAllegatoRepository.delete(obj)
    }

}
