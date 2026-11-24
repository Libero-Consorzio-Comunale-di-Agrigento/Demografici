package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerIndividuoCertificatoService {

	private final GsdService gsdService

	private final CerIndividuoCertificatoRepository cerIndividuoCertificatoRepository

    CerIndividuoCertificatoService(CerIndividuoCertificatoRepository cerIndividuoCertificatoRepository,
                                   GsdService gsdService) {
		this.cerIndividuoCertificatoRepository = cerIndividuoCertificatoRepository
		this.gsdService = gsdService
	}

	CerIndividuoCertificato create(Integer annoEmissione, Integer progressivoEmissione) {
		return (new CerIndividuoCertificato(annoEmissione: annoEmissione, progressivoEmissione: progressivoEmissione))
	}

	CerIndividuoCertificato get (Long id){
		return cerIndividuoCertificatoRepository.findById(id)
	}

	CerIndividuoCertificato getByAnnoEmissioneAndProgressivoEmissione(Integer annoEmissione, Integer progressivoEmissione) {
		if (annoEmissione && progressivoEmissione) {
			return cerIndividuoCertificatoRepository.findByAnnoEmissioneAndProgressivoEmissione(annoEmissione, progressivoEmissione)
		}
		return null
	}

	private void validaDati(CerIndividuoCertificato obj) {
		if(obj.matricola == null && obj.atto == null){
			throw new IllegalStateException("Matricola o TipoAtto non devono essere vuoti")
		}
		if (obj.matricola != null && obj.atto != null) {
			throw new IllegalStateException("Matricola e TipoAtto non possono essere presenti contemporaneamente")
		}
		if ( (obj.annoEmissione == null) || (obj.progressivoEmissione == null)){
			throw new IllegalStateException("AnnoEmissione e ProgressivoEmissione non devono essere vuoti")
		}
	}

	CerIndividuoCertificato save(CerIndividuoCertificato obj) {
		validaDati(obj)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}

		return cerIndividuoCertificatoRepository.save(obj)
	}

}
