package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivRichiamoFormulaService {

	private final GsdService gsdService

	private final GsdValidazioneTestoService gsdValidazioneTestoService

	private final CivRichiamoFormulaRepository civRichiamoFormulaRepository

	private final CivTestoFormulaService civTestoFormulaService
	class FormulaUsataException extends De4gsdzkRuntimeException {
		FormulaUsataException(String msg) { super(msg) }
	}

    CivRichiamoFormulaService(CivRichiamoFormulaRepository civRichiamoFormulaRepository, GsdValidazioneTestoService gsdValidazioneTestoService,
							  CivTestoFormulaService civTestoFormulaService, GsdService gsdService){

		this.civRichiamoFormulaRepository = civRichiamoFormulaRepository
		this.gsdValidazioneTestoService = gsdValidazioneTestoService
		this.civTestoFormulaService = civTestoFormulaService
		this.gsdService = gsdService
	}

	CivRichiamoFormula get (Long id){
		return civRichiamoFormulaRepository.findById(id)
	}

	List<CivRichiamoFormula> listAllByTipoAttoAndFormula(Integer tipoAtto, CivFormulaAnnotazione formula) {
		return civRichiamoFormulaRepository.findAllByTipoAttoAndFormula(tipoAtto, formula)
	}

	List<CivRichiamoFormula> listAllByTipoAttoAndRichiamoAndProgressivoAndFiltroLike(Integer tipoAtto, Integer richiamo, Integer progressivo, String filtro){
		return civRichiamoFormulaRepository.findAllByTipoAttoAndRichiamoAndProgressivoAndFiltroLike(tipoAtto, richiamo, progressivo, filtro)
	}

	List<String> listAllFormuleByTipoAttoAndRichiamoAndProgressivo(CivRichiamoBaseDomain richiamo){
		return civRichiamoFormulaRepository.findAllFormuleByTipoAttoAndRichiamoAndProgressivo(richiamo.tipoAtto, richiamo.richiamo, richiamo.progressivo)
	}

	/**
 	 * Controlla che la formula sia valida per il richiamo
	 *
	 * @param obj il richiamo contenente la formula
	 * @param force se saltare il controllo che la formula è già usata altrove
	 * @throws RecordDuplicatoRuntimeException, FormulaUsataException
	 */
	void validaFormula(CivRichiamoFormula obj, boolean force=false) {

		List<CivRichiamoFormula> cs = listAllByTipoAttoAndFormula(obj.tipoAtto, obj.formula)

		boolean found = false

		//scorre tutti i richiami che contengono la formula e controlla se già usata
		for (Iterator<CivRichiamoFormula> it=cs.iterator(); it.hasNext(); ) {
			CivRichiamoFormula c = it.next()
			if (c.richiamo==obj.richiamo && c.progressivo==obj.progressivo) {
				found = true
				it.remove()//rimuove il richiamo corrente
			}
		}

		// segnala che la formula è duplicata (solo in inserimento)
		if (found && obj.id==null) {
			throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Formula_Duplicata"))
		}

		//segnala che la formula è già usata
		if (cs && !force) {
			String msg = "La formula ${obj.formula.id} è già stata associata:"
			for (CivRichiamoFormula c : cs) {
				msg += "\n- al richiamo ${c.richiamo} dettaglio ${c.progressivo}"
			}
			msg += "\n\nSi vuole procedere comunque alla registrazione?"
			throw new FormulaUsataException(msg)
		}

	}

	private void validaDati(CivRichiamoFormula obj, boolean force) {
		if ( (obj.tipoAtto == null) || (obj.richiamo == null) || (obj.progressivo == null) || obj.formula == null) {
			throw new CampoMandatoryRuntimeException()
		}

		validaFormula(obj, force)

		gsdValidazioneTestoService.checkWrongVar(obj.formula.testo?.testoA4, gsdService.listVariabili(CivTestoFormula.class, obj.tipoAtto))
	}

	CivRichiamoFormula save(CivRichiamoFormula obj, boolean force=false) {
		validaDati(obj, force)

		if (obj.id == null) {
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

		//salva il testo
		civTestoFormulaService.save(obj.formula.testo)

		return civRichiamoFormulaRepository.save(obj)
	}

	void delete(CivRichiamoFormula obj) {
		log.info("Tento cancellazione su CIVDRF per id " + obj.id)
		civRichiamoFormulaRepository.delete(obj)
	}

}
