package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.Testimone
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTestimoniAttoService {

	private final GsdService gsdService

	private final ArcParametroService arcParametroService

	private final CivTestimoniAttoRepository civTestimoniAttoRepository

    CivTestimoniAttoService(CivTestimoniAttoRepository civTestimoniAttoRepository,
                            GsdService gsdService, ArcParametroService arcParametroService) {

		this.civTestimoniAttoRepository = civTestimoniAttoRepository
		this.gsdService = gsdService
		this.arcParametroService = arcParametroService
	}

	CivTestimoniAtto create(Integer numeroTestimoni){
		return new CivTestimoniAtto(numeroTestimoni: numeroTestimoni )
	}

	CivTestimoniAtto getByUkAttoAndTipoAtto(String identificativoAtto, Integer tipoAtto) {
		return civTestimoniAttoRepository.findByUkAttoAndTipoAtto(identificativoAtto, tipoAtto)
	}

	CivTestimoniAtto getOrCreateByUkAtto(CivAttoBaseDomain a, Integer tipoAtto) {
		CivTestimoniAtto m = getByUkAttoAndTipoAtto(a.idAtto, tipoAtto)
		if (!(m)){
			Integer numTestimoni = (a.isTestimoniMandatory()?new Integer(2):null)
			m = create(numTestimoni)
		}
		return m
	}

	private void checkDatiObbligatoriIncompletiTestimone(Testimone testimone, String sezione){
		if ((!(testimone.cognome?.trim())) && (!(testimone.nome?.trim()))) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
		}

		if (testimone.dataNascita == null) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
		}

		if (testimone.sesso == null) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
		}

		if ((testimone.comuneNascita.codice == null) || (testimone.comuneNascita.codiceProvincia == null)) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
		}

		if ((testimone.comuneResidenza.codice == null) || (testimone.comuneResidenza.codiceProvincia == null)) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
		}
	}

	private void validaDati(CivTestimoniAtto obj, Boolean numTestimoniMandatory=Boolean.FALSE) {
		Boolean emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null)  || (obj.atto == null) || (obj.parte == null) )

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_atto"))
		}

		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		if (anscOn && numTestimoniMandatory){
			String sezioneTestimoni = "'Testimoni'"

			if (obj.numeroTestimoni == null) {
				throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezioneTestimoni)
			}

			if (obj.numeroTestimoni.compareTo(new Integer(0)) > 0) {
				checkDatiObbligatoriIncompletiTestimone(obj.testimone1, sezioneTestimoni)
			}

			if (obj.numeroTestimoni.compareTo(new Integer(1)) > 0) {
				checkDatiObbligatoriIncompletiTestimone(obj.testimone2, sezioneTestimoni)
			}

			if (obj.numeroTestimoni.compareTo(new Integer(2)) > 0) {
				checkDatiObbligatoriIncompletiTestimone(obj.testimone3, sezioneTestimoni)
			}

			if (obj.numeroTestimoni.compareTo(new Integer(3)) > 0) {
				checkDatiObbligatoriIncompletiTestimone(obj.testimone4, sezioneTestimoni)
			}
		}
	}

	CivTestimoniAtto save (CivTestimoniAtto obj, Boolean numTestimoniMandatory=Boolean.FALSE){

		validaDati(obj, numTestimoniMandatory)

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVTTA per id " + obj.id)
		return  civTestimoniAttoRepository.save(obj)
	}

	void delete(CivTestimoniAtto obj){
		log.info("Tento cancellazione su CIVTTA per id " + obj.id)
		civTestimoniAttoRepository.delete(obj)
	}

}
