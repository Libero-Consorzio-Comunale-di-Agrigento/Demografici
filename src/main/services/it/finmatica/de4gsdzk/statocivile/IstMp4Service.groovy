package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.ErroreCaricamentoDatiRuntimeException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.persistence.criteria.JoinType

@Slf4j
@Transactional
@Service
class IstMp4Service {

	private final GsdService gsdService

	private final IstMp4Repository istMp4Repository

	private final CivValidazioneModelloIstatService civValidazioneModelloIstatService

	private final CivNascitaService civNascitaService

    IstMp4Service(IstMp4Repository istMp4Repository, GsdService gsdService,
                  CivValidazioneModelloIstatService civValidazioneModelloIstatService, CivNascitaService civNascitaService) {

		this.istMp4Repository = istMp4Repository
        this.civNascitaService = civNascitaService
		this.gsdService = gsdService
		this.civValidazioneModelloIstatService = civValidazioneModelloIstatService
	}

	IstMp4 get(Long id){
		return istMp4Repository.findById(id)
	}

	IstMp4 getByUkAtto(String identificativoAtto) {
		return istMp4Repository.findByUkAtto(identificativoAtto)
	}

	private void validaDati(IstMp4 obj, Long pkAtto, boolean force=false) {
		civValidazioneModelloIstatService.checkEstremiAtto(obj)

		civValidazioneModelloIstatService.checkChiusuraProvvisorio(obj)

		if (!(force) ) {
			CivNascita nas = civNascitaService.get(pkAtto, [fetch:[[campo:'nazionalitaPadre', tipo: JoinType.LEFT], [campo:'nazionalitaMadre', tipo: JoinType.LEFT]]] )
			String msg = ""
			if ((nas.dataNascitaMadre != null) && (obj.dataNascitaMadre != null) && (nas.dataNascitaMadre != obj.dataNascitaMadre)) {
				msg += "- Risulta un'incongruenza sulla data di nascita della madre\n"
			}
			if ((nas.nazionalitaMadre != null) && (obj.nazionalitaMadre != null) && (nas.nazionalitaMadre.codCi.compareTo(obj.nazionalitaMadre.codCi) != 0)) {
				msg += "- Risulta un'incongruenza sulla cittadinanza della madre\n"
			}
			if ((nas.dataNascitaPadre != null) && (obj.dataNascitaPadre != null) && (nas.dataNascitaPadre != obj.dataNascitaPadre)) {
				msg += "- Risulta un'incongruenza sulla data di nascita del padre\n"
			}
			if ((nas.nazionalitaPadre != null) && (obj.nazionalitaPadre != null) && (nas.nazionalitaPadre.codCi.compareTo(obj.nazionalitaPadre.codCi) != 0)) {
				msg += "- Risulta un'incongruenza sulla cittadinanza del padre\n"
			}
			if (msg) {
				msg += "Confrontare con i dati dell'atto"
				throw new ErroreCaricamentoDatiRuntimeException(msg)
			}
		}
	}

	IstMp4 save (IstMp4 obj, Long pkAtto, boolean force=false) {
		validaDati(obj, pkAtto, force)

		if (obj.id == null){
			obj.id = gsdService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su ISTMP4 per id " + obj.id)
		return  istMp4Repository.save(obj)
	}

}
