package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscEntitaRepository
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import it.finmatica.de4gsdzk.utils.RicercaAtto
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscEntitaService {

	private final AnscEntitaRepository anscEntitaRepository

	AnscEntitaService(AnscEntitaRepository anscEntitaRepository){
		this.anscEntitaRepository = anscEntitaRepository
	}

	AnscEntita get (String id){
		return anscEntitaRepository.findById(id)
	}

	Page<AnscEntita> listAllByRicercaLike (ETipoArchivioAnsc tipoArchivioAnsc, RicercaAtto r, PageRequest p){
		String idAttoAnscLike = SqlUtils.beginsAndEndsLike(r.idAttoAnsc?.trim())
		String cognomeLike = SqlUtils.beginsAndEndsLike(r.cognome?.trim()?.toUpperCase())
		String nomeLike = SqlUtils.beginsAndEndsLike(r.nome?.trim()?.toUpperCase())
		return anscEntitaRepository.findAll(idAttoAnscLike, r.numeroUnico, r.anno, cognomeLike, nomeLike, tipoArchivioAnsc, p)
	}

}
