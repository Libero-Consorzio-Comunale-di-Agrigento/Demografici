package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.GsdValidazioneTestoService
import it.finmatica.de4gsdzk.ISoggettoAtto1
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.ErroreDatiAnnotazioneRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFormulaAnnotazioneService {

	private final GsdService gsdService

	private final CivNotaFormulaService civNotaFormulaService

	private final CivTestoFormulaService civTestoFormulaService

	private final ArcParametroService arcParametroService

	private final GsdValidazioneTestoService gsdValidazioneTestoService

	private final CivFormulaAnnotazioneRepository civFormulaAnnotazioneRepository

	CivFormulaAnnotazioneService(CivFormulaAnnotazioneRepository civFormulaAnnotazioneRepository, GsdService gsdService,
                                 CivNotaFormulaService civNotaFormulaService, CivTestoFormulaService civTestoFormulaService,
                                 ArcParametroService arcParametroService, GsdValidazioneTestoService gsdValidazioneTestoService){

		this.civFormulaAnnotazioneRepository = civFormulaAnnotazioneRepository
		this.gsdService = gsdService
		this.civNotaFormulaService = civNotaFormulaService
		this.civTestoFormulaService = civTestoFormulaService
		this.arcParametroService = arcParametroService
		this.gsdValidazioneTestoService = gsdValidazioneTestoService
	}

	CivFormulaAnnotazione get (String id){
		return civFormulaAnnotazioneRepository.findById(id)
	}

	CivFormulaAnnotazione getWithTesto (String id){
		return civFormulaAnnotazioneRepository.findWithTestoById(id)
	}

	String getTestoAnnotazioneDaDecodificare(String testoFormula, List<CivNotaFormula> lnf){
		List<CivNotaFormula> orderedList = lnf?.sort{it.variabile}?.reverse()
		String testo = testoFormula
		for (CivNotaFormula nf : orderedList) {
			if (nf.testoVariabile){
				testo = testo.replaceAll("#${nf.variabile.toString()}", nf.testoVariabile)
				continue
			}
			if (nf.testoMaschile || nf.testoFemminile){
				String suggerimentoDecodificato = (nf.testoMaschile?"${nf.testoMaschile}/":"") + (nf.testoFemminile?:"")
				testo = testo.replaceAll("#${nf.variabile.toString()}", suggerimentoDecodificato)
				continue
			}
			if (nf.note){
				String notaDecodificata = "[...${nf.note}...]"
				testo = testo.replaceAll("#${nf.variabile.toString()}", notaDecodificata)
				continue
			}
			testo = testo.replaceAll("#${nf.variabile.toString()}", "[...]")
		}
		return testo
	}

	String getTestoAnnotazioneDecodificato(String idFormula, CivAttoBaseDomain atto, Boolean soloNoteDecode=Boolean.FALSE){
		String testoEstesoFormula = civTestoFormulaService.get(idFormula)?.testoA4
		List<CivNotaFormula> orderedList = civNotaFormulaService.listAllByFormula(idFormula, new Sort(SortUtils.variabileDesc))
		String testo = testoEstesoFormula
		for (CivNotaFormula nf : orderedList) {
			if (nf.testoVariabile){
				testo = testo.replaceAll("#${nf.variabile.toString()}", nf.testoVariabile)
				continue
			}
			if (nf.testoMaschile || nf.testoFemminile){
				if ( (atto.getTipoAttoEnum() == ETipoAtto.NAS) || (atto.getTipoAttoEnum() == ETipoAtto.MOR) || (atto.getTipoAttoEnum() == ETipoAtto.CIT) ){
					String suggerimentoDecodificato = (nf.testoMaschile?"${nf.testoMaschile}/":"") + (nf.testoFemminile?:"")
					switch ( ((ISoggettoAtto1)atto).getSesso1()) {
						case ESesso.M:
							suggerimentoDecodificato = nf.testoMaschile
							break
						case ESesso.F:
							suggerimentoDecodificato = nf.testoFemminile
							break
					}
					testo = testo.replaceAll("#${nf.variabile.toString()}", suggerimentoDecodificato)
					continue
				}
			}
			if (nf.note){
				String notaDecodificata = "[...${nf.note}...]"
				testo = testo.replaceAll("#${nf.variabile.toString()}", notaDecodificata)
				continue
			}
			testo = testo.replaceAll("#${nf.variabile.toString()}", "[....]")
		}
		if (soloNoteDecode) {
			return testo
		} else {
			return gsdService.decodificaTestoFormula(atto, testo, idFormula, null, null, null, null)
		}
	}

	/*
	String getTestoFormulaDecodificato(String id, CivAttoBaseDomain atto){
		String testoEstesoFormula = civTestoFormulaService.get(id)?.testoA4
		List<CivNotaFormula> orderedList = civNotaFormulaService.listAllByFormulaReverseOrdered(id)
		String testoDecodificato = testoEstesoFormula
		for (CivNotaFormula nf : orderedList) {
			if (nf.testoVariabile){
				String var = nf.testoVariabile
				var = var.replaceAll("<", "").replaceAll(">", "")
				String varDecodificata = (gsdService.decodificaVariabileFormula(atto, var)?:"[....]")
				testoDecodificato = testoDecodificato.replaceAll("#${nf.variabile.toString()}", varDecodificata)
				continue
			}
			if (nf.testoMaschile || nf.testoFemminile){
				switch (atto.tipoAttoEnum) {
					case ETipoAtto.NAS:
						String suggerimentoDecodificato = (nf.testoMaschile?"${nf.testoMaschile}/":"") + (nf.testoFemminile?:"")
						switch (((CivNascita)atto).sesso) {
							case ESesso.M:
								suggerimentoDecodificato = nf.testoMaschile
								break
							case ESesso.F:
								suggerimentoDecodificato = nf.testoFemminile
								break
						}
						testoDecodificato = testoDecodificato.replaceAll("#${nf.variabile.toString()}", suggerimentoDecodificato)
						continue
						break
				}
			}
			if (nf.note){
				String notaDecodificata = "[...${nf.note}...]"
				testoDecodificato = testoDecodificato.replaceAll("#${nf.variabile.toString()}", notaDecodificata)
				continue
			}
			testoDecodificato = testoDecodificato.replaceAll("#${nf.variabile.toString()}", "[....]")
		}
		return testoDecodificato
	}
	*/

	Page<CivFormulaAnnotazione> list (Map params) {
		return civFormulaAnnotazioneRepository.listByParams(params)
	}

	List<CivFormulaAnnotazione> listAllByTipoAttoAndTipoAnnotazioneIn(Integer tipoAtto, List<ETipoAnnotazione> l){
		return civFormulaAnnotazioneRepository.findAllByTipoAttoAndTipoAnnotazioneIn(tipoAtto, l)
	}

	List<CivFormulaAnnotazione> listAllByIdIn(List<String> ids){
		return civFormulaAnnotazioneRepository.findAllByIdIn(ids)
	}

	Boolean isAnnotazioneBloccata(String idFormula){
		if (idFormula) {
			String bloccoAnnotazioni = arcParametroService.getAnnotazioniBloccate()
			if (bloccoAnnotazioni) {
				String[] arr = bloccoAnnotazioni.split(",")
				for (String s : arr) {
					if (s?.trim()?.toUpperCase() == idFormula) {
						return Boolean.TRUE
					}
				}
			}
		}
		return Boolean.FALSE
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivFormulaAnnotazione obj) {
		if (isAnnotazioneBloccata(obj.id)){
			throw new ErroreDatiAnnotazioneRuntimeException(Etichette.getEtichetta("Errore_Operazione_non_consentita"))
		}

		ValidationUtils.validaDatiObbligatori(obj)

		if (tipoOperazione.isInsert()){
			long n = civFormulaAnnotazioneRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Formula_Duplicata"))
			}
		}

		gsdValidazioneTestoService.checkWrongVar(obj.testo?.testoA4, gsdService.listVariabili(CivTestoFormula.class, obj.tipoAtto))
	}

	CivFormulaAnnotazione save(ETipoOperazione tipoOperazione, CivFormulaAnnotazione obj, List<CivNotaFormula> lnf=[]) {
		validaDati(tipoOperazione, obj)

		obj.testo.id = obj.getId()

		CivFormulaAnnotazione fa = civFormulaAnnotazioneRepository.save(obj)

		for (CivNotaFormula nf:lnf){
			civNotaFormulaService.save(nf)
		}

		if (fa.tipoAnnotazione in [ETipoAnnotazione.M, ETipoAnnotazione.C]) {
			List<Integer> varToDelete = []
			for (int i = 1; i <= CivNotaFormula.MAX_NOTA_FORMULA_ELEMENTS; i++) {
				Boolean found = Boolean.FALSE
				for (CivNotaFormula nf : lnf) {
					if (nf.variabile.intValue() == i) {
						found = Boolean.TRUE
						break
					}
				}
				if (!found) {
					varToDelete.add(new Integer(i))
				}
			}
			if (varToDelete.size() > 0) {
				List<CivNotaFormula> l = civNotaFormulaService.listAllByFormulaAndVariabileIn(fa.id, varToDelete)
				for (CivNotaFormula nf : l) {
					civNotaFormulaService.delete(nf)
				}
			}
		}

		return fa
	}

}
