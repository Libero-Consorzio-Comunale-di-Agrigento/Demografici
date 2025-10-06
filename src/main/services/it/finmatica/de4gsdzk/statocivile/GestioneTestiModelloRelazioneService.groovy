package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class GestioneTestiModelloRelazioneService {

	private final GestioneTestiModelloRelazioneRepository gestioneTestiModelloRelazioneRepository

    GestioneTestiModelloRelazioneService(GestioneTestiModelloRelazioneRepository gestioneTestiModelloRelazioneRepository) {
		this.gestioneTestiModelloRelazioneRepository = gestioneTestiModelloRelazioneRepository
	}

    GestioneTestiModelloRelazione getByIdComunicazioneAtto(String idComunicazioneAtto) {
        return gestioneTestiModelloRelazioneRepository.findByIdComunicazioneAtto(idComunicazioneAtto)
    }

    GestioneTestiModelloRelazione getByIdComunicazione(Integer idComunicazione) {
        return gestioneTestiModelloRelazioneRepository.findByIdComunicazione(idComunicazione)
    }

    GestioneTestiModelloRelazione getByIdTipoCertificato(String idTipoCertificato) {
        return gestioneTestiModelloRelazioneRepository.findByTipoCertificato(idTipoCertificato)
    }

    GestioneTestiModelloRelazione save(GestioneTestiModelloRelazione obj) {
        return gestioneTestiModelloRelazioneRepository.save(obj)
    }

    void delete(GestioneTestiModelloRelazione obj) {
        gestioneTestiModelloRelazioneRepository.delete(obj)
    }
}
