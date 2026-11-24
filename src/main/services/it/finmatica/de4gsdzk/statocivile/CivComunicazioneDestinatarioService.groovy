package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IArchivioComunicazioneService
import it.finmatica.de4gsdzk.IComunicazioneAllegatoRepository
import it.finmatica.de4gsdzk.IComunicazioneDestinatario
import it.finmatica.de4gsdzk.IComunicazioneDestinatarioRepository
import it.finmatica.de4gsdzk.IComunicazioneDestinatarioService
import it.finmatica.de4gsdzk.TraitComunicazioneDestinatarioService
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneDestinatarioService implements IComunicazioneDestinatarioService, TraitComunicazioneDestinatarioService {

	private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final GsdService gsdService

	private final CivComunicazioneDestinatarioRepository civComunicazioneDestinatarioRepository

    CivComunicazioneDestinatarioService(CivComunicazioneDestinatarioRepository civComunicazioneDestinatarioRepository, GsdService gsdService,
                                        CivArchivioComunicazioneService civArchivioComunicazioneService) {

		this.civComunicazioneDestinatarioRepository = civComunicazioneDestinatarioRepository
		this.gsdService = gsdService
		this.civArchivioComunicazioneService = civArchivioComunicazioneService
	}

    @Override
    IComunicazioneDestinatarioRepository getComunicazioneDestinatarioRepository() {
        return civComunicazioneDestinatarioRepository
    }

    @Override
    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return civArchivioComunicazioneService
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }


	List<Map> listAllByTipoAttoAndStampaEseguita(ETipoAtto tipoAttoEnum, Boolean stampaEseguita){
		List<Object[]> lC = civComunicazioneDestinatarioRepository.findAllByTipoAttoAndStampaEseguita(new Integer(tipoAttoEnum.valore), stampaEseguita)
		List<Map> result = []
		for (Object[] o: lC){
			result.add([comuneDestinatario: o[0], provinciaDestinatario: o[1], ente:o[2]])
		}
		return result
	}

}
