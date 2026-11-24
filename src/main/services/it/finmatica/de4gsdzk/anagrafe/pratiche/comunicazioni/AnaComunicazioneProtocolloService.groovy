package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IArchivioComunicazione
import it.finmatica.de4gsdzk.IComunicazioneProtocollo
import it.finmatica.de4gsdzk.IComunicazioneProtocolloService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaComunicazioneProtocolloService implements IComunicazioneProtocolloService {

	private final AnaArchivioComunicazioneService anaArchivioComunicazioneService

	private final GsdService gsdService

	private final AnaComunicazioneProtocolloRepository anaComunicazioneProtocolloRepository

    AnaComunicazioneProtocolloService(AnaComunicazioneProtocolloRepository anaComunicazioneProtocolloRepository, GsdService gsdService,
                                      AnaArchivioComunicazioneService anaArchivioComunicazioneService) {

		this.anaComunicazioneProtocolloRepository = anaComunicazioneProtocolloRepository
		this.gsdService = gsdService
		this.anaArchivioComunicazioneService = anaArchivioComunicazioneService
	}

	@Override
    IComunicazioneProtocollo get(Long id) {
		return anaComunicazioneProtocolloRepository.findById(id)
	}

	private void validaDati(AnaComunicazioneProtocollo obj, AnaArchivioComunicazione arcCom) {
		if ((obj.comunicazione?.id == null)) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_comunicazione"))
		}

		anaArchivioComunicazioneService.bloccaSeProtocollata(arcCom)
	}

	@Override
	IComunicazioneProtocollo save(IComunicazioneProtocollo _obj, IArchivioComunicazione _arcCom) {
		AnaComunicazioneProtocollo obj = _obj as AnaComunicazioneProtocollo
		AnaArchivioComunicazione arcCom = _arcCom as AnaArchivioComunicazione

		validaDati(obj, arcCom)

		if (obj.id == null){
			// solo in caso di inserimento
            obj.id = gsdService.getIntegerIdFromSequence(obj, "ANACOM")
		}
		log.info("Lancio salvataggio su ANACOM_PROT per id " + obj.id)
		return anaComunicazioneProtocolloRepository.save(obj)
	}

}
