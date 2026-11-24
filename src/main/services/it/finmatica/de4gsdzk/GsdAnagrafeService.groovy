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
class GsdAnagrafeService {

	private final GsdAnagrafeRepository gsdAnagrafeRepository

    GsdAnagrafeService(GsdAnagrafeRepository gsdAnagrafeRepository){
		this.gsdAnagrafeRepository = gsdAnagrafeRepository
	}

	GsdAnagrafe get (String id){
		return gsdAnagrafeRepository.findById(id)
	}

	Page<GsdAnagrafe> listAll(RicercaSoggetto r, Pageable pageable) {
		if (r?.archivio != null &&
				r.archivio != EArchivioSorgenteSoggetto.ANA &&
				r.archivio != EArchivioSorgenteSoggetto.CIV) {
			throw new ErroreRicercaArchivioSoggettoRuntimeException()
		}
		gsdAnagrafeRepository.findAll(
				SqlUtils.endsLike(r?.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r?.nome)?.toUpperCase(),
				SqlUtils.endsLike(r?.codiceFiscale)?.toUpperCase(),
				r?.sesso,
				r?.dataNascita,
				r?.dataNascita,
                null,
				r?.archivio,
				pageable)
	}

	Page<GsdAnagrafe> listAllByRicercaIndividuo(RicercaIndividuo r, Pageable pageable) {

		gsdAnagrafeRepository.findAll(
				SqlUtils.endsLike(r?.cognome)?.toUpperCase(),
				SqlUtils.endsLike(r?.nome)?.toUpperCase(),
				SqlUtils.endsLike(r?.codiceFiscale)?.toUpperCase(),
				r?.sesso,
				r?.dataNascitaDal,
				r?.dataNascitaAl,
                r?.matricola,
				null,
				pageable)
	}

}
