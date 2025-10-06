package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivTestoLiberoRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.TestoUtils
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.zkoss.zul.Messagebox

@Slf4j
@Transactional
@Service
class CivTestoLiberoService {

	private final CivFormulaTestoLiberoService civFormulaTestoLiberoService

	private final CivOcchielloService civOcchielloService

	private final StatoCivileService statoCivileService

	private final CivTestoLiberoRepository civTestoLiberoRepository

	CivTestoLiberoService(CivTestoLiberoRepository civTestoLiberoRepository, StatoCivileService statoCivileService,
						  CivFormulaTestoLiberoService civFormulaTestoLiberoService, CivOcchielloService civOcchielloService){

		this.civTestoLiberoRepository = civTestoLiberoRepository
		this.statoCivileService = statoCivileService
		this.civFormulaTestoLiberoService = civFormulaTestoLiberoService
		this.civOcchielloService = civOcchielloService
	}

	CivTestoLibero getByUkAtto(String identificativoAtto) {
		return civTestoLiberoRepository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(CivTestoLibero obj, ETipoAtto tipoAttoEnumSource){
		Boolean emptyMandatoryFields = TipoAttoUtils.isEstremiAttoEmpty(obj, tipoAttoEnumSource)
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_atto)
		}
	}

	CivTestoLibero save (CivTestoLibero obj, ETipoAtto tipoAttoEnumSource, CivOcchiello occhiello, List<CivFormulaTestoLibero> formuleMargine){

		validaDati(obj, tipoAttoEnumSource)

		if (formuleMargine){
			for (CivFormulaTestoLibero f : formuleMargine){
				civFormulaTestoLiberoService.save(f, tipoAttoEnumSource)
			}
		}

		if (occhiello){
			civOcchielloService.save(occhiello, tipoAttoEnumSource)
		}

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}

		log.info("Lancio salvataggio su CIVTLI per id " + obj.id)
		CivTestoLibero saved = civTestoLiberoRepository.save(obj)
		return saved
	}

	Map validaTesto(String testo, int numRighe, int numColonne, Boolean blocca){
		StringBuilder errorMesg = new StringBuilder("Operazione non consentita")
		errorMesg.append(TestoUtils.aCapo)

		Map m = TestoUtils.calcolaRighe(testo, numColonne, Boolean.TRUE)
		int totRighe = m["totRighe"]

		if ((totRighe == -1) || (totRighe == -2)) {
			errorMesg.append("Testo non correttamente formattato (riga di lunghezza non ammessa o non completata con tratteggio)")
			errorMesg.append(" :\n")
			errorMesg.append(m["riga"])
			return [messaggio:errorMesg.toString(), tipo:Messagebox.ERROR]
		}

		if (totRighe != numRighe){
			if (totRighe > numRighe){
				errorMesg.append("Il testo dell'atto contiene un numero di righe superiore al massimo consentito")
			}
			if (totRighe < numRighe){
				errorMesg.append("Il testo dell'atto contiene un numero di righe inferiore al massimo consentito")
			}
			errorMesg.append(" (${totRighe}/${numRighe})")

			if (blocca){
				return [messaggio:errorMesg.toString(), tipo: Messagebox.ERROR]
			} else {
				return [messaggio:errorMesg.toString(), tipo: Messagebox.INFORMATION]
			}
		}
		return null
	}

	Map validaMargine(List<CivFormulaTestoLibero> formuleMargine){
		for (CivFormulaTestoLibero f:formuleMargine){
			Map mm = TestoUtils.calcolaRighe(f.testo, f.numeroColonne, Boolean.FALSE)
			int totRigheMargine = mm["totRighe"]

			if (f.numeroRighe.compareTo(new Integer(totRigheMargine)) != 0){
				StringBuilder errorMesg = new StringBuilder("Operazione non consentita")
				errorMesg.append(TestoUtils.aCapo)
				errorMesg.append("Il testo del margine contiene un numero di righe non ammissibile")
				errorMesg.append(" (${totRigheMargine}/${f.numeroRighe})")

				return [messaggio:errorMesg, tipo: Messagebox.ERROR]
			}
		}
		return null
	}

	void delete(CivTestoLibero obj){
		log.info("Tento cancellazione su CIVTLI per id " + obj.id)
		civTestoLiberoRepository.delete(obj)
	}

}
