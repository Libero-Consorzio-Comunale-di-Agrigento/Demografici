package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneRepository
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.io.FilenameUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneService {

	private final CivComunicazioneRepository civComunicazioneRepository

	private final GestioneTestiGsdModelloService gestioneTestiGsdModelloService
	private final GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    CivComunicazioneService(CivComunicazioneRepository civComunicazioneRepository,
							GestioneTestiGsdModelloService gestioneTestiGsdModelloService,
							GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService) {

		this.civComunicazioneRepository = civComunicazioneRepository
		this.gestioneTestiGsdModelloService = gestioneTestiGsdModelloService
		this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
	}

	CivComunicazione get (Integer id){
		return civComunicazioneRepository.findById(id)
	}

	Page<CivComunicazione> list (Map params) {
		return civComunicazioneRepository.listByParams(params)
	}

	/**
	 * Query lista utilizzata per popolare la popup di scelta delle comunicazioni
	 *
	 * @param tipoAtto se 0 restituisce la lista delle comunicazione dalle formule, altrimenti in base al tipo atto
	 * @param filtro filtro aggiuntivo sulla descrizione
	 * @param pageable page request
	 * @return la lista di {@link CivComunicazione}
	 */
	Page<CivComunicazione> listAllByTipoAttoOrInFormule(Integer tipoAtto, String filtro, Pageable pageable) {
		if (tipoAtto == 0) {
			return civComunicazioneRepository.findAllInFormule(SqlUtils.getFiltroLike(filtro), pageable)
		} else {
			return civComunicazioneRepository.findAllByTipoAtto(tipoAtto, SqlUtils.getFiltroLike(filtro), pageable)
		}
	}

	List<CivComunicazione> listAllByTipoAttoComunicazioneAndStampaEseguita(Integer tipoAttoComunicazione, Boolean stampaEseguita){
		return civComunicazioneRepository.findAllByTipoAttoComunicazioneAndStampaEseguita(tipoAttoComunicazione, stampaEseguita)
	}

	/**
	 * Query lista usata per la popup filtrata in base al tipo di comunicazione.
	 *
	 * @param tipoComunicazione A o N
	 * @param escludiId (opzionale) da escludere
	 * @param escludiTipoAtto (opzionale) se escludere le comunicazioni già usate
	 * 		nel tipo di atto specificato
	 * @param escludiFormula (opzionale) se escludere le comunicazioni già usate
	 * 		per la formula specificata
	 * @param filtro filtro aggiuntivo sulla descrizione
	 * @param pageable page request
	 * @return la lista (paginabile)
	 */
	Page<CivComunicazione> listAllByTipoComunicazione(ETipoComunicazione tipoComunicazione,
													  Integer escludiId=null,
													  Integer escludiTipoAtto=null,
													  CivFormulaAnnotazione escludiFormula=null,
													  String filtro=null,
													  Pageable pageable=new PageRequest(0, Integer.MAX_VALUE)) {
		return civComunicazioneRepository.findAllByTipoComunicazione(
				tipoComunicazione, escludiId, escludiTipoAtto, escludiFormula,
				SqlUtils.getFiltroLike(filtro), pageable)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivComunicazione obj) {
		if ( (obj.tipoComunicazione == null) || (obj.id==null) || ( (obj?.descrizione?.trim()?:"") == "") ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = civComunicazioneRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Comunicazione_Duplicata)
			}
		}
	}

	CivComunicazione save (ETipoOperazione tipoOperazione, CivComunicazione obj, GestioneTestiModelloRelazione modelloRelazione, boolean force=false) {
		validaDati(tipoOperazione, obj)

		log.info("Lancio salvataggio su CIVDCO per id " + obj.id)
		CivComunicazione c = civComunicazioneRepository.save(obj)

		// modello
		if (c.tipoComunicazione.isAnnotazione() && modelloRelazione.modello.fileTemplate!=null) {
			String nomeModelloCaricato = FilenameUtils.removeExtension(modelloRelazione.modello.nome)
			String nomeModelloStandard = FileUtils.getNomeModelloComunicazioneStandard(c.id)
			if ( (nomeModelloCaricato != nomeModelloStandard) && (!(force) ) ){
				throw new FileNonValidoRuntimeException(EtichetteMessaggi.Warn_file_modello_comunicazione, "(Nome file atteso: ${nomeModelloStandard})")
			}
			modelloRelazione.modello.codice = FileUtils.getCodiceModelloComunicazioneStandard(c.id)
			modelloRelazione.modello = gestioneTestiGsdModelloService.save(modelloRelazione.modello)
			modelloRelazione.comunicazione = c
			// relazione
			gestioneTestiModelloRelazioneService.save(modelloRelazione)
		}

		return c
	}

}
