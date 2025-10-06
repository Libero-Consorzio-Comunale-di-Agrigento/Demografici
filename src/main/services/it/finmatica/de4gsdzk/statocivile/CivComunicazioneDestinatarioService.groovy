package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneDestinatarioRepository
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneDestinatarioService {

	private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final StatoCivileService statoCivileService

	private final CivComunicazioneDestinatarioRepository civComunicazioneDestinatarioRepository

    CivComunicazioneDestinatarioService(CivComunicazioneDestinatarioRepository civComunicazioneDestinatarioRepository, StatoCivileService statoCivileService,
										CivArchivioComunicazioneService civArchivioComunicazioneService) {

		this.civComunicazioneDestinatarioRepository = civComunicazioneDestinatarioRepository
		this.statoCivileService = statoCivileService
		this.civArchivioComunicazioneService = civArchivioComunicazioneService
	}

	CivComunicazioneDestinatario get (Long id){
		return civComunicazioneDestinatarioRepository.findById(id)
	}

	List<CivComunicazioneDestinatario> listAllByArchivioComunicazione(Long idArcCom){
		return civComunicazioneDestinatarioRepository.findAllByArchivioComunicazione(idArcCom)
	}

	List<Map> listAllByTipoAttoAndStampaEseguita(ETipoAtto tipoAttoEnum, Boolean stampaEseguita){
		List<Object[]> lC = civComunicazioneDestinatarioRepository.findAllByTipoAttoAndStampaEseguita(new Integer(tipoAttoEnum.valore), stampaEseguita)
		List<Map> result = []
		for (Object[] o: lC){
			result.add([comuneDestinatario: o[0], provinciaDestinatario: o[1], ente:o[2]])
		}
		return result
	}

	private void validaDati(CivComunicazioneDestinatario obj) {

		civArchivioComunicazioneService.bloccaSeProtocollata(obj.archivioComunicazione)

		civArchivioComunicazioneService.bloccaSeInviataAlbo(obj.archivioComunicazione)

	}

	CivComunicazioneDestinatario save (CivComunicazioneDestinatario obj){
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVCOM_DEST per id " + obj.id)
		return  civComunicazioneDestinatarioRepository.save(obj)
	}

	void delete(CivComunicazioneDestinatario obj){
		validaDati(obj)

		log.info("Tento cancellazione su CIVCOM_DEST per id " + obj.id)
		civComunicazioneDestinatarioRepository.delete(obj)
	}

	String inviaPec(CivComunicazioneDestinatario obj){
		EStatoProtocollazione sp = civArchivioComunicazioneService.getStatoProtocollazione(obj.archivioComunicazione.id)
		if ( (sp == null) || (sp != EStatoProtocollazione.P) ) {
			throw new ErroreDatiComunicazioneRuntimeException(EtichetteMessaggi.Errore_invio_pec_comunicazione_non_protocollata)
		}

		String retVal = statoCivileService.inviaPecComunicazione(obj.archivioComunicazione.id, obj.id)
		return retVal
	}

}
