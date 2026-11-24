package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivOcchielloService {

	private final GsdService gsdService

	private final CivOcchielloRepository civOcchielloRepository

    CivOcchielloService(CivOcchielloRepository civOcchielloRepository, GsdService gsdService) {

		this.civOcchielloRepository = civOcchielloRepository
		this.gsdService = gsdService
	}

	CivOcchiello getByUkAtto(String identificativoAtto) {
		return civOcchielloRepository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(CivOcchiello obj, ETipoAtto tipoAttoEnumSource){
		Boolean emptyMandatoryFields = Boolean.TRUE
		switch (tipoAttoEnumSource) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.MOR:
			case ETipoAtto.UCI:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null)  || (obj.atto == null) || (obj.parte == null) )
				break
			case ETipoAtto.CIT:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
		}
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_occhiello"))
		}
	}

	CivOcchiello save (CivOcchiello obj, ETipoAtto tipoAttoEnumSource){
		validaDati(obj, tipoAttoEnumSource)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj)
		}
		return  civOcchielloRepository.save(obj)
	}
}
