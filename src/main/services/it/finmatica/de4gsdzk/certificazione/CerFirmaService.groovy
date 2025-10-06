package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerFirmaRepository
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
class CerFirmaService {

	private final CerFirmaRepository cerFirmaRepository

    CerFirmaService(CerFirmaRepository cerFirmaRepository) {
		this.cerFirmaRepository = cerFirmaRepository
	}

	CerFirma get (Integer id){
		return cerFirmaRepository.findById(id)
	}

	Page<CerFirma> listAllByDescrizioneLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerFirmaRepository.findAll(p)
		} else {
			return cerFirmaRepository.findAllByDescrizioneLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerFirma obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerFirmaRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}
	}

	CerFirma save(ETipoOperazione tipoOperazione, CerFirma obj) {
		validaDati(tipoOperazione, obj)
		return cerFirmaRepository.save(obj)
	}

	void delete(CerFirma obj){
		if (obj.id != null) {
			cerFirmaRepository.delete(obj)
		}
	}

}
