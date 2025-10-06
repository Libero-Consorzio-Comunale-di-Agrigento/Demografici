package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerValiditaCertificatoRepository
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
class CerValiditaCertificatoService {

	private final CerValiditaCertificatoRepository cerValiditaCertificatoRepository

    CerValiditaCertificatoService(CerValiditaCertificatoRepository cerValiditaCertificatoRepository) {
		this.cerValiditaCertificatoRepository = cerValiditaCertificatoRepository
	}

	CerValiditaCertificato get (Integer id){
		return cerValiditaCertificatoRepository.findById(id)
	}

	Page<CerValiditaCertificato> listAllByDescrizioneLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerValiditaCertificatoRepository.findAll(p)
		} else {
			return cerValiditaCertificatoRepository.findAllByDescrizioneLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerValiditaCertificato obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			Integer n = cerValiditaCertificatoRepository.checkValiditaCertificato(obj.id)
			if (n.intValue() > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}
	}

	CerValiditaCertificato save(ETipoOperazione tipoOperazione, CerValiditaCertificato obj) {
		validaDati(tipoOperazione, obj)
		return cerValiditaCertificatoRepository.save(obj)
	}

	void delete(CerValiditaCertificato obj){
		if (obj.id != null) {
			cerValiditaCertificatoRepository.delete(obj)
		}
	}

}
