package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.error.FirmatariListRuntimeException
import it.finmatica.de4gsdzk.certificazione.error.UtenteNonTerminalistaRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaRepository
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerTerminalistaService {

	private final CerTerminalistaRepository cerTerminalistaRepository
	private final ArcParametroService arcParametroService
	private final UtenteCustomService utenteCustomService

	CerTerminalistaService(CerTerminalistaRepository cerTerminalistaRepository, ArcParametroService arcParametroService, UtenteCustomService utenteCustomService) {
		this.cerTerminalistaRepository = cerTerminalistaRepository
		this.arcParametroService = arcParametroService
		this.utenteCustomService = utenteCustomService
	}

	CerTerminalista get (String id){
		return cerTerminalistaRepository.findById(id)
	}

	CerTerminalista getTerminalistaUtente() {
		String codiceUtente = utenteCustomService.loggedUserId
		CerTerminalista terminalistaUtente = cerTerminalistaRepository.findById(codiceUtente)
		if (terminalistaUtente == null) {
			throw new UtenteNonTerminalistaRuntimeException()
		}
		return terminalistaUtente
	}

	List<CerTerminalista> listAllFirmatariOrderByCognomeNome(){
		if (arcParametroService.isListaFirmatariAttiva()) {
			List<CerTerminalista> firmatariList = cerTerminalistaRepository.findAllByUtenteFirmaRemotaNotNullAndPwdFirmaRemotaNotNull(new Sort(SortUtils.cognomeNomeAsc))
			if (firmatariList.empty) {
				throw new FirmatariListRuntimeException(EtichetteMessaggi.Errore_Certificazioni_nessun_firmatario)
			}
			return firmatariList
		}

		String codiceUtente = utenteCustomService.loggedUserId
		CerTerminalista terminalistaUtente = cerTerminalistaRepository.findByIdAndUtenteFirmaRemotaNotNullAndPwdFirmaRemotaNotNull(codiceUtente)
		if (terminalistaUtente == null) {
			throw new FirmatariListRuntimeException(EtichetteMessaggi.Errore_Certificazioni_utente_non_firmatario)
		}
		return [terminalistaUtente]
	}

	Page<CerTerminalista> listAllByIdLikeOrCognomeLikeOrNomeLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerTerminalistaRepository.findAll(p)
		} else {
			String f = SqlUtils.beginsAndEndsLike(filtro)
			return cerTerminalistaRepository.findAllByIdLikeIgnoreCaseOrCognomeLikeIgnoreCaseOrNomeLikeIgnoreCase(f, f, f, p)
		}
	}

	Page<CerTerminalista> listAllByIdLikeOrCognomeNomeLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerTerminalistaRepository.findAll(p)
		} else {
			String f = SqlUtils.beginsAndEndsLike(filtro)
			return cerTerminalistaRepository.findAllByIdLikeIgnoreCaseOrCognomeNomeLikeIgnoreCase(f, f, p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerTerminalista obj) {
		if ( TestoUtils.isVuoto(obj?.id) || TestoUtils.isVuoto(obj?.cognome) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerTerminalistaRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}
	}

	CerTerminalista save(ETipoOperazione tipoOperazione, CerTerminalista obj) {
		validaDati(tipoOperazione, obj)
		return cerTerminalistaRepository.save(obj)
	}

	void delete(CerTerminalista obj){
		if (obj.id) {
			cerTerminalistaRepository.delete(obj)
		}
	}

}
