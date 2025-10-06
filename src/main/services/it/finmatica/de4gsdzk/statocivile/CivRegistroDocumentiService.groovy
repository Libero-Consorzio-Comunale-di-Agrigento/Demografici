package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivNumerazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoDocumento
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivRegistroDocumentiService{

	private final CivRegistroDocumentiUscitaService civRegistroDocumentiUscitaService

	private final CivRegistroDocumentiEntrataService civRegistroDocumentiEntrataService

    CivRegistroDocumentiService(CivRegistroDocumentiUscitaService civRegistroDocumentiUscitaService, CivRegistroDocumentiEntrataService civRegistroDocumentiEntrataService) {
		this.civRegistroDocumentiUscitaService = civRegistroDocumentiUscitaService
		this.civRegistroDocumentiEntrataService = civRegistroDocumentiEntrataService
	}

	List<CivRegistroDocumentiBaseDomain> listAll(ETipoDocumento tipoDocumento) {
		switch (tipoDocumento) {
			case ETipoDocumento.Entrata:
				return civRegistroDocumentiEntrataService.listAll()
				break
			case ETipoDocumento.Uscita:
				return civRegistroDocumentiUscitaService.listAll()
				break
		}
		return []
	}

	Page<CivRegistroDocumentiBaseDomain> listAllByDescrizioneLike (ETipoDocumento tipoDocumento, String filtro, PageRequest p){
		switch (tipoDocumento) {
			case ETipoDocumento.Entrata:
				return civRegistroDocumentiEntrataService.listAllByDescrizioneLike(filtro, p)
				break
			case ETipoDocumento.Uscita:
				return civRegistroDocumentiUscitaService.listAllByDescrizioneLike(filtro, p)
				break
		}
		return null
	}

	Tuple2<CivRegistroDocumentiBaseDomain, Collection<CivNumerazioneDocumentiBaseDomain>> get (ETipoDocumento tipoDocumento, Integer id){
		switch (tipoDocumento) {
			case ETipoDocumento.Entrata:
				return civRegistroDocumentiEntrataService.get(id)
				break
			case ETipoDocumento.Uscita:
				return civRegistroDocumentiUscitaService.get(id)
				break
		}
		return null
	}

	CivRegistroDocumentiBaseDomain save(ETipoDocumento tipoDocumento, ETipoOperazione tipoOperazione, CivRegistroDocumentiBaseDomain obj, LinkedHashSet<CivNumerazioneDocumentiBaseDomain> listaNumeriDocumenti) {
		switch (tipoDocumento) {
			case ETipoDocumento.Entrata:
				return civRegistroDocumentiEntrataService.save(tipoOperazione, obj, listaNumeriDocumenti)
				break
			case ETipoDocumento.Uscita:
				return civRegistroDocumentiUscitaService.save(tipoOperazione, obj, listaNumeriDocumenti)
				break
		}
	}
}
