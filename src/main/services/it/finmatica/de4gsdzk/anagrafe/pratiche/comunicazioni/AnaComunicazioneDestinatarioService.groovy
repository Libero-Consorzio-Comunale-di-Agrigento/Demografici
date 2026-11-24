package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IArchivioComunicazioneService
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
class AnaComunicazioneDestinatarioService implements IComunicazioneDestinatarioService, TraitComunicazioneDestinatarioService {

	private final AnaArchivioComunicazioneService anaArchivioComunicazioneService

	private final GsdService gsdService

	private final AnaComunicazioneDestinatarioRepository anaComunicazioneDestinatarioRepository

    AnaComunicazioneDestinatarioService(AnaComunicazioneDestinatarioRepository anaComunicazioneDestinatarioRepository, GsdService gsdService,
                                        AnaArchivioComunicazioneService anaArchivioComunicazioneService) {

		this.anaComunicazioneDestinatarioRepository = anaComunicazioneDestinatarioRepository
		this.gsdService = gsdService
		this.anaArchivioComunicazioneService = anaArchivioComunicazioneService
	}

    @Override
    IComunicazioneDestinatarioRepository getComunicazioneDestinatarioRepository() {
        return anaComunicazioneDestinatarioRepository
    }

    @Override
    IArchivioComunicazioneService getArchivioComunicazioneService() {
        return anaArchivioComunicazioneService
    }

    @Override
    GsdService getGsdService() {
        return gsdService
    }


	/*List<Map> listAllByTipoAttoAndStampaEseguita(ETipoAtto tipoAttoEnum, Boolean stampaEseguita){
		List<Object[]> lC = anaComunicazioneDestinatarioRepository.findAllByTipoAttoAndStampaEseguita(new Integer(tipoAttoEnum.valore), stampaEseguita)
		List<Map> result = []
		for (Object[] o: lC){
			result.add([comuneDestinatario: o[0], provinciaDestinatario: o[1], ente:o[2]])
		}
		return result
	}*/

}
