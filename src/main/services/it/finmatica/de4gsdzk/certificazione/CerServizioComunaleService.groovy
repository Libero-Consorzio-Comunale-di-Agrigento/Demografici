package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerServizioComunaleService {

	private final CerServizioComunaleRepository cerServizioComunaleRepository

    CerServizioComunaleService(CerServizioComunaleRepository cerServizioComunaleRepository) {
		this.cerServizioComunaleRepository = cerServizioComunaleRepository
	}

	CerServizioComunale get (String id){
		return cerServizioComunaleRepository.findById(id)
	}

	Page<CerServizioComunale> listAllByDescrizioneLike(String filtro, PageRequest p){
		if (TestoUtils.isVuoto(filtro)) {
			return cerServizioComunaleRepository.findAll(p)
		} else {
			return cerServizioComunaleRepository.findAllByDescrizioneLikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro), p)
		}
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerServizioComunale obj) {
		if ( TestoUtils.isVuoto(obj?.id) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerServizioComunaleRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
			}
		}
	}

	CerServizioComunale save(ETipoOperazione tipoOperazione, CerServizioComunale obj) {
		validaDati(tipoOperazione, obj)
		return cerServizioComunaleRepository.save(obj)
	}

}
