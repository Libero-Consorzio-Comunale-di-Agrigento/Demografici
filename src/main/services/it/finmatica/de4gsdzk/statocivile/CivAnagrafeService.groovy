package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivAnagrafeRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivAnagrafeService {

	private final StatoCivileService statoCivileService

	private final CivAnagrafeRepository civAnagrafeRepository

	CivAnagrafeService(CivAnagrafeRepository civAnagrafeRepository, StatoCivileService statoCivileService) {

		this.civAnagrafeRepository = civAnagrafeRepository
		this.statoCivileService = statoCivileService
	}

	CivAnagrafe getByUkAtto(String identificativoAtto) {
		return civAnagrafeRepository.findByUkAtto(identificativoAtto)
	}

	CivAnagrafe getByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		return civAnagrafeRepository.findByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
	}

	private void validaDati(CivAnagrafe obj, ETipoAtto tipoAttoEnumSource){
		Boolean emptyMandatoryFields = TipoAttoUtils.isEstremiAttoEmpty(obj, tipoAttoEnumSource)
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_anagrafe)
		}
	}

	CivAnagrafe save (CivAnagrafe obj, ETipoAtto tipoAttoEnumSource){

		validaDati(obj, tipoAttoEnumSource)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVANA per id " + obj.id)
		return  civAnagrafeRepository.save(obj)
	}

	private void delete(CivAnagrafe obj){
		log.info("Tento cancellazione su CIVANA per id " + obj.id)
		civAnagrafeRepository.delete(obj)
	}

	// refs #56291: l'invocazione del metodo 'delete' genera prima una select su ANAANA con un'outer join che
	// rallenta tantissimo; soluzione: tiro su io il record dal db e lo passo alla 'delete'
	void selectAndDelete(CivAnagrafe obj){
		log.info("Tento cancellazione su CIVANA per id " + obj.id)
		if (obj.id != null){
			CivAnagrafe a = civAnagrafeRepository.findById(obj.id)
			delete(a)
		}
	}

}
