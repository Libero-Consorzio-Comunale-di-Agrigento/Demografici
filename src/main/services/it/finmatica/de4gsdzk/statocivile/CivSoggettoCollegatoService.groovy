package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivSoggettoCollegatoRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoSoggettoCollegato
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivSoggettoCollegatoService {

	private final StatoCivileService statoCivileService

	private final ArcParametroService arcParametroService

	private final CivSoggettoCollegatoRepository civSoggettoCollegatoRepository

	CivSoggettoCollegatoService(CivSoggettoCollegatoRepository civSoggettoCollegatoRepository,
								StatoCivileService statoCivileService, ArcParametroService arcParametroService) {

		this.civSoggettoCollegatoRepository = civSoggettoCollegatoRepository
		this.statoCivileService = statoCivileService
		this.arcParametroService = arcParametroService
	}

	List<CivSoggettoCollegato> listAllByUkAtto(String identificativoAtto){
		return civSoggettoCollegatoRepository.findAllByUkAtto(identificativoAtto)
	}

	CivSoggettoCollegato getByUkAttoAndTipoSoggettoCollegato(String identificativoAtto, ETipoSoggettoCollegato tipoSoggettoCollegato) {
		return civSoggettoCollegatoRepository.findByUkAttoAndTipoSoggettoCollegato(identificativoAtto, tipoSoggettoCollegato)
	}

	private void validaDati(CivSoggettoCollegato obj, ETipoAtto tipoAttoEnumSource, Boolean soggettoCollegatoMandatory){
		Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()

		Boolean emptyMandatoryFields = Boolean.TRUE

		switch (tipoAttoEnumSource) {
			case ETipoAtto.NAS:
			case ETipoAtto.MAT:
			case ETipoAtto.PUB:
			case ETipoAtto.MOR:
			case ETipoAtto.UCI:
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) || (obj.parte == null) )
				break
			case ETipoAtto.PVU:
			case ETipoAtto.CIT:
				//I processi verbali hanno lo stesso tipo_atto delle unioni civili ma non hanno nè parte, nè serie
				//Le cittadinanze non hanno nè parte nè serie
				emptyMandatoryFields = ( (obj.tipoAtto == null) || (obj.ufficio == null) || (obj.anno == null) || (obj.atto == null) )
				break
		}

		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_atto)
		}

		if (anscOn && soggettoCollegatoMandatory){
			String sezione = "'Soggetto Collegato'"
			switch (obj.tipoSoggettoCollegato) {
				case ETipoSoggettoCollegato.IT:
					sezione = "'Interprete'"
					break
				case ETipoSoggettoCollegato.AS:
					sezione = "'Generalità ascendente'"
					break
				case ETipoSoggettoCollegato.OS:
					sezione = "'Generalità sanitario'"
					break
				case ETipoSoggettoCollegato.PD:
					sezione = "'Generalità padre'"
					break
				case ETipoSoggettoCollegato.MD:
					sezione = "'Generalità madre'"
					break
				case ETipoSoggettoCollegato.PP:
					sezione = "'Generalità procuratore padre'"
					break
				case ETipoSoggettoCollegato.PM:
					sezione = "'Generalità procuratore madre'"
					break
				case ETipoSoggettoCollegato.CG:
					sezione = "'Intestatario (vecchie generalità)'"
					break
			}

			if (TestoUtils.isVuoto(obj.nome)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if (obj.sesso == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if (obj.dataNascita == null) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if ((obj.comuneNascita.codice == null) || (obj.comuneNascita.codiceProvincia == null)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if ((obj.comuneResidenza.codice == null) || (obj.comuneResidenza.codiceProvincia == null)) {
				if (obj.tipoSoggettoCollegato != ETipoSoggettoCollegato.CG && obj.tipoSoggettoCollegato != ETipoSoggettoCollegato.IT) {
					throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
				}
			}

			if (obj.nazionalita == null && (obj.tipoSoggettoCollegato != ETipoSoggettoCollegato.IT)) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if ( (obj.tipoSoggettoCollegato == ETipoSoggettoCollegato.AS) && (obj.gradoParentela == null) ) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}

			if ( (obj.tipoSoggettoCollegato == ETipoSoggettoCollegato.OS) && (obj.qualifica == null) ) {
				throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori_sezione, sezione)
			}
		}
	}

	CivSoggettoCollegato save (CivSoggettoCollegato obj, ETipoAtto tipoAttoEnumSource, Boolean soggettoCollegatoMandatory){
		validaDati(obj, tipoAttoEnumSource, soggettoCollegatoMandatory)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVSOG per id " + obj.id)
		return  civSoggettoCollegatoRepository.save(obj)
	}

	void delete(CivSoggettoCollegato obj){
		if (obj.id != null){
			log.info("Tento cancellazione su CIVSOG per id " + obj.id)
			civSoggettoCollegatoRepository.delete(obj)
		}
	}

}
