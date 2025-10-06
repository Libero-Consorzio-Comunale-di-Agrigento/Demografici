package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerMotivoSospensioneRepository
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerMotivoSospensioneService {

	private final CerMotivoSospensioneRepository cerMotivoSospensioneRepository

    CerMotivoSospensioneService(CerMotivoSospensioneRepository cerMotivoSospensioneRepository) {
		this.cerMotivoSospensioneRepository = cerMotivoSospensioneRepository
	}

	CerMotivoSospensione get (Integer id){
		return cerMotivoSospensioneRepository.findById(id)
	}

	Page<CerMotivoSospensione> listAllByDescrizioneLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerMotivoSospensioneRepository.findAll(p)
		} else {
			return cerMotivoSospensioneRepository.findAllByDescrizioneLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerMotivoSospensione obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerMotivoSospensioneRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}
	}

	CerMotivoSospensione save(ETipoOperazione tipoOperazione, CerMotivoSospensione obj) {
		validaDati(tipoOperazione, obj)
		return cerMotivoSospensioneRepository.save(obj)
	}

	void delete(CerMotivoSospensione obj){
		if (obj.id != null) {
			cerMotivoSospensioneRepository.delete(obj)
		}
	}

}
