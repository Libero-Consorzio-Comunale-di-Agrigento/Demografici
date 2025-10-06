package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivFirmatarioAttoRepository
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFirmatarioAttoService {

	private final CivAttoService civAttoService

	private final CivFirmatarioAttoRepository civFirmatarioAttoRepository

    CivFirmatarioAttoService(CivAttoService civAttoService, CivFirmatarioAttoRepository civFirmatarioAttoRepository) {
		this.civAttoService = civAttoService
		this.civFirmatarioAttoRepository = civFirmatarioAttoRepository
	}

	CivFirmatarioAtto get (Long id){
		return civFirmatarioAttoRepository.findById(id)
	}

	List<CivFirmatarioAtto> listAllByIdAtto(String identificativoAtto, Sort s) {
		if (identificativoAtto) {
			return civFirmatarioAttoRepository.findAllByIdAtto(identificativoAtto, s)
		}
		return []
	}

	List<CivFirmatarioAtto> listAllByIdAttoAndTipoFirma(String identificativoAtto, ETipoFirmaAnsc tipoFirma, Sort s) {
		if (identificativoAtto) {
			return civFirmatarioAttoRepository.findAllByIdAttoAndTipoFirma(identificativoAtto, tipoFirma, s)
		}
		return []
	}

	Boolean existsFirmatarioNonValido(String identificativoAtto){
		return (civFirmatarioAttoRepository.existsFirmatarioNonValido(identificativoAtto) > 0)
	}

	Boolean existsFirmatarioELNonGestito(String identificativoAtto){
		return (civFirmatarioAttoRepository.existsFirmatarioELNonGestito(identificativoAtto) > 0)
	}

	Boolean isFirmatarioELNonValido(Long id){
		return (civFirmatarioAttoRepository.isFirmatarioELNonValido(id) > 0)
	}

	Boolean isFirmatarioELNonGestito(Long id){
		return (civFirmatarioAttoRepository.isFirmatarioELNonGestito(id) > 0)
	}

	Boolean isFirmatarioELInGestione(Long id){
		return (civFirmatarioAttoRepository.isFirmatarioELInGestione(id) > 0)
	}

	Boolean isFirmatarioELDaVisionare(Long id){
		return checkStatoFirmatarioEL(id, EStatoLinkFirmaAnsc.DVI)
	}

	Boolean isFirmatarioELStatoVisionato(Long id){
		return checkStatoFirmatarioEL(id, EStatoLinkFirmaAnsc.VIS)
	}

	Boolean isFirmatarioELStatoAnnullato(Long id){
		return checkStatoFirmatarioEL(id, EStatoLinkFirmaAnsc.ANN)
	}

	Boolean checkStatoFirmatarioEL(Long id, EStatoLinkFirmaAnsc tipoStato){
		Integer res = civFirmatarioAttoRepository.getFirmatarioELStatoPresaVisione(id)
		if (res == null){
			return Boolean.FALSE
		}
		switch (tipoStato) {
			case EStatoLinkFirmaAnsc.DVI:
				return (res?.intValue() == 0)
			case EStatoLinkFirmaAnsc.VIS:
				return (res?.intValue() == 1)
			case EStatoLinkFirmaAnsc.ANN:
				return (res?.intValue() == 2)
		}
		return Boolean.FALSE
	}

	void bloccaSeAttoFirmatoUSC(ETipoAtto tipoAttoEnumSource, Long pkAtto){
		Boolean firmato = civAttoService.isFirmatoUscAnsc(tipoAttoEnumSource, pkAtto)
		if (firmato){
			throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_invio_atto_firmato)
		}
	}

	private void validaDati(CivFirmatarioAtto obj, ETipoAtto tipoAttoEnumSource, Long pkAtto) {

		if (obj.tipoFirma == null){
			throw new CampoMandatoryRuntimeException("- selezionare il tipo di firma per ${obj.nominativo}")
		}
		if ( (obj.tipoFirma == ETipoFirmaAnsc.EL) && TestoUtils.isVuoto(obj.indirizzoMail) ){
			throw new CampoMandatoryRuntimeException("- compilare indirizzo e-mail di ${obj.nominativo}")
		}
		if ( (obj.tipoFirma == ETipoFirmaAnsc.EL) && (!(ValidationUtils.isEmailAddressValid(obj.indirizzoMail))) ){
			throw new CampoMandatoryRuntimeException("- indirizzo e-mail di ${obj.nominativo} non valido")
		}

		bloccaSeAttoFirmatoUSC(tipoAttoEnumSource, pkAtto)

		if (obj.tipoFirma == ETipoFirmaAnsc.CA){
			if (isFirmatarioELStatoVisionato(obj.id)){
				throw new AnscRuntimeException("Modifica non consentita: il firmatario ${obj.nominativo} ha già effettuato la presa visione del documento")
			}
			if ( isFirmatarioELInGestione(obj.id) || isFirmatarioELDaVisionare(obj.id) ) {
				throw new AnscRuntimeException("Modifica non consentita: il link per la presa visione del documento è stato inviato al firmatario ${obj.nominativo}.\nOccorre procedere con la presa visione o con l'annullamento del link")
			}
		}
	}

	CivFirmatarioAtto save (CivFirmatarioAtto obj, ETipoAtto tipoAttoEnumSource, Long pkAtto) {

		validaDati(obj, tipoAttoEnumSource, pkAtto)

		log.info("Lancio salvataggio su CIVFIR per id " + obj.id)
		return civFirmatarioAttoRepository.save(obj)
	}

	void saveAll(List<CivFirmatarioAtto> lFirmatari, ETipoAtto tipoAttoEnumSource, Long pkAtto) {
		int totFirmatariEl = 0
		for (CivFirmatarioAtto fa:lFirmatari) {
			if (fa.tipoFirma == ETipoFirmaAnsc.EL){
				totFirmatariEl++
			}
		}
		// se tutti firmatari con SPID ma è stata già fatta firma cartacea sollevo eccezione
		if (totFirmatariEl == lFirmatari.size()){
			if (civAttoService.isFirmatoCartaceoAnsc(tipoAttoEnumSource, pkAtto)){
				throw new AnscRuntimeException("Salvataggio non consentito: è già stata effettuata la firma cartacea del documento")
			}
		}
		for (CivFirmatarioAtto fa:lFirmatari) {
			save(fa, tipoAttoEnumSource, pkAtto)
		}
	}

}
