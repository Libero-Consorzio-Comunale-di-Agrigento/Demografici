package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPraticaAllegato
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPraticaAllegatoService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAllegato
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAtto
import it.finmatica.de4gsdzk.statocivile.CivFascicoloAttoAllegato
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaComunicazioneAllegatoService implements IComunicazioneAllegatoService, TraitComunicazioneAllegatoService {

	private final AnaArchivioComunicazioneService anaArchivioComunicazioneService

	private final AnaPraticaAllegatoService anaPraticaAllegatoService

	private final IntegrazioneDocumentaleService integrazioneDocumentaleService

	private final GsdService gsdService

	private final AnaComunicazioneAllegatoRepository anaComunicazioneAllegatoRepository

    AnaComunicazioneAllegatoService(AnaComunicazioneAllegatoRepository anaComunicazioneAllegatoRepository, AnaPraticaAllegatoService anaPraticaAllegatoService,
                                    GsdService gsdService, AnaArchivioComunicazioneService anaArchivioComunicazioneService,
                                    IntegrazioneDocumentaleService integrazioneDocumentaleService) {

		this.anaComunicazioneAllegatoRepository = anaComunicazioneAllegatoRepository
		this.gsdService = gsdService
		this.anaArchivioComunicazioneService = anaArchivioComunicazioneService
		this.integrazioneDocumentaleService = integrazioneDocumentaleService
		this.anaPraticaAllegatoService = anaPraticaAllegatoService
	}

    @Override
    IComunicazioneAllegatoRepository getComunicazioneAllegatoRepository() {
        return anaComunicazioneAllegatoRepository
    }

    @Override
    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return anaArchivioComunicazioneService
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }

	AnaComunicazioneAllegato save (AnaComunicazioneAllegato obj, AnaPratica pratica, Boolean salvaSuDocumentale, InputStream is, Boolean ignoreStato=Boolean.FALSE, Boolean ignoreStampaEseguita=Boolean.FALSE, Boolean aggiornaStampaEseguita=Boolean.FALSE){
		validaDati(obj, ignoreStato, ignoreStampaEseguita)

        AnaArchivioComunicazione arcCom = anaArchivioComunicazioneService.get(obj.archivioComunicazione.id) as AnaArchivioComunicazione
		if (salvaSuDocumentale) {
			if (arcCom.idDocumentoEsterno == null) {
				// Devo salvare su gdm
				anaArchivioComunicazioneService.save(arcCom, pratica, Boolean.TRUE, Boolean.TRUE, Boolean.TRUE)
			}

			List<Campo> metadati = MetadatiGdmUtils.listMetadatiPratica(pratica)
			integrazioneDocumentaleService.addFileToDocumentale(arcCom, obj, is, metadati, true, EModelloGdm.Pratica)
		}

		if (aggiornaStampaEseguita) {
			if (arcCom.isDaProtocollare() || arcCom.isDaInviareAlbo()) {
				log.info(arcCom.id + ": non aggiorno il flag stampa_eseguita in quanto comunicazione da protocollare o inviare all'albo")
			} else {
				arcCom.stampaEseguita = Boolean.TRUE
				anaArchivioComunicazioneService.save(arcCom, pratica, Boolean.TRUE)
			}
		}

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su ANACOM_ALLE per id " + obj.id)
		AnaComunicazioneAllegato savedComAlle = anaComunicazioneAllegatoRepository.save(obj)
		return savedComAlle
	}


    int fascicolaAllegati(AnaArchivioComunicazione arcCom, AnaPratica pratica) {
        int retVal = -1

        // Controllo nome file univoco
        List<AnaComunicazioneAllegato> listaAllegatiComunicazione = []
        for (AnaComunicazioneAllegato a : listAllMetadatiByArchivioComunicazione(arcCom.id) as List<AnaComunicazioneAllegato>) {
            AnaComunicazioneAllegato alleCom = get(a.id) as AnaComunicazioneAllegato
            listaAllegatiComunicazione.add(alleCom)
            validaDati(alleCom, Boolean.TRUE, Boolean.TRUE)
        }
        if (listaAllegatiComunicazione.size() == 0) {
            retVal = 0 // Nessun allegato da fascicolare
        }

        for (AnaComunicazioneAllegato alleCom : listaAllegatiComunicazione) {
            if (fascicolaAllegato(alleCom, pratica, arcCom.descrizione)) {
                retVal = 1 // Almeno un allegato fascicolato
            }
        }

        return retVal
    }

    private Boolean fascicolaAllegato(AnaComunicazioneAllegato obj, AnaPratica pratica, String comunicazione) {
        Boolean allegatoAggiuntoAlFascicolato = Boolean.FALSE

        AnaPraticaAllegato all = anaPraticaAllegatoService.getByPraticaAndAllegatoComunicazione(pratica.id, obj.id)
        if (all == null) {
            all = anaPraticaAllegatoService.createXAllegatoComunicazione(pratica, obj)
            allegatoAggiuntoAlFascicolato = Boolean.TRUE
        }
        // Mantengo sempre allineato il nome del file
        all.nome = obj.getNome()
        all.note = comunicazione
        all.idFileEsterno = obj.idFileEsterno
        anaPraticaAllegatoService.save(all)

        return allegatoAggiuntoAlFascicolato
    }

    @Override
    void deleteAllegato(IComunicazioneAllegato _obj){
        AnaComunicazioneAllegato obj = _obj as AnaComunicazioneAllegato
        validaDatiPre(obj)
        // Cancello dal documentale
        if ( (obj.idFileEsterno != null) && (obj.archivioComunicazione.idDocumentoEsterno != null) ){
            integrazioneDocumentaleService.removeFile(obj.archivioComunicazione, obj)
        }

        //Cancello da Anacom_alle
        log.info("Tento cancellazione su ANACOM_ALLE per id " + obj.id)
        anaComunicazioneAllegatoRepository.delete(obj)
    }

}
