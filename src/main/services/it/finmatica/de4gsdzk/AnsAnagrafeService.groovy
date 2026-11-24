package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.RicercaIndividuo
import it.finmatica.de4gsdzk.errors.ErroreRicercaArchivioSoggettoRuntimeException
import it.finmatica.de4gsdzk.utils.EArchivioSorgenteSoggetto
import it.finmatica.de4gsdzk.utils.RicercaSoggetto
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnsAnagrafeService {

	private final AnsAnagrafeRepository ansAnagrafeRepository

    AnsAnagrafeService(AnsAnagrafeRepository ansAnagrafeRepository){
		this.ansAnagrafeRepository = ansAnagrafeRepository
	}

	AnsAnagrafe get (String id){
		return ansAnagrafeRepository.findById(id)
	}

	Page<AnsAnagrafe> listAll(RicercaSoggetto r, Pageable pageable) {
		if (r?.archivio != null &&
				r.archivio != EArchivioSorgenteSoggetto.ANA &&
				r.archivio != EArchivioSorgenteSoggetto.CIV) {
			throw new ErroreRicercaArchivioSoggettoRuntimeException()
		}
		ansAnagrafeRepository.findAll(
				SqlUtils.endsLike(r?.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r?.nome)?.toUpperCase(),
				SqlUtils.endsLike(r?.codiceFiscale)?.toUpperCase(),
				r?.sesso,
				r?.dataNascita,
				r?.dataNascita,
				r?.archivio,
				pageable)
	}

	Page<AnsAnagrafe> listAllByRicercaIndividuo(RicercaIndividuo r, Pageable pageable) {

		ansAnagrafeRepository.findAll(
				SqlUtils.endsLike(r?.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r?.nome)?.toUpperCase(),
				SqlUtils.endsLike(r?.codiceFiscale)?.toUpperCase(),
				r?.sesso,
				r?.dataNascitaDal,
				r?.dataNascitaAl,
				null,
				pageable)
	}

}
