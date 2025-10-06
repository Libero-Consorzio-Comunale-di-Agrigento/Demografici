package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneProtocolloRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneProtocolloService {

	private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final StatoCivileService statoCivileService

	private final CivComunicazioneProtocolloRepository civComunicazioneProtocolloRepository

    CivComunicazioneProtocolloService(CivComunicazioneProtocolloRepository civComunicazioneProtocolloRepository, StatoCivileService statoCivileService,
									  CivArchivioComunicazioneService civArchivioComunicazioneService) {

		this.civComunicazioneProtocolloRepository = civComunicazioneProtocolloRepository
		this.statoCivileService = statoCivileService
		this.civArchivioComunicazioneService = civArchivioComunicazioneService
	}

	CivComunicazioneProtocollo get (Long id){
		return civComunicazioneProtocolloRepository.findById(id)
	}

	private void validaDati(CivComunicazioneProtocollo obj, CivArchivioComunicazione arcCom) {
		if ((obj.tipoAtto == null) || (obj.comunicazione?.id == null)) {
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_comunicazione)
		}

		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (arcCom.getTipoAttoRifEnum()) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.PUB:
			case ETipoAtto.MOR:
				//FIXME: check su obbligatorietà serie per atti "normali" e atti pregressi
				emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null))
				break
			case ETipoAtto.UCI:
				//FIXME: Bisognerebbe discriminare fra processi verbali e unioni civili
				emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
			case ETipoAtto.CIT:
				emptyMandatoryFields = ((obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
		}

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_comunicazione)
		}

		civArchivioComunicazioneService.bloccaSeProtocollata(arcCom)

		civArchivioComunicazioneService.bloccaSeInviataAlbo(arcCom)
	}

	CivComunicazioneProtocollo save (CivComunicazioneProtocollo obj, CivArchivioComunicazione arcCom){

		validaDati(obj, arcCom)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdComunicazioneProtocollo(obj)
		}
		log.info("Lancio salvataggio su CIVCOM_PROT per id " + obj.id)
		return  civComunicazioneProtocolloRepository.save(obj)
	}

}
