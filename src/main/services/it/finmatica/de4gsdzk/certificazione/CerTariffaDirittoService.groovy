package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.error.CategoriaGiaAssociataADirittoRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerTariffaDirittoRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerTariffaDirittoService {

	private final CerTariffaDirittoRepository cerTariffaDirittoRepository
	private final StatoCivileService statoCivileService

	CerTariffaDirittoService(CerTariffaDirittoRepository cerTariffaDirittoRepository,
							 StatoCivileService statoCivileService) {
		this.cerTariffaDirittoRepository = cerTariffaDirittoRepository
		this.statoCivileService = statoCivileService
	}

	CerTariffaDiritto get (Long id){
		return cerTariffaDirittoRepository.findById(id)
	}

	List<CerTariffaDiritto> listAll() {
		Sort sort = new Sort(SortUtils.dirittoFasciaTariffariaAsc)
		return cerTariffaDirittoRepository.findAll(sort)
	}

	Page<CerTariffaDiritto> listAllByDescrizioneLikeAndCategoriaTipoCertificato(String filtro, CerCategoriaTipoCertificato categoriaTipoCertificato, PageRequest p) {
		return cerTariffaDirittoRepository.findAllByDescrizioneLikeIgnoreCaseAndCategoriaTipoCertificatoInList(TestoUtils.isVuoto(filtro) ? "%" : SqlUtils.beginsAndEndsLike(filtro), categoriaTipoCertificato, p)
	}

	CerTariffaDiritto findTariffaDirittoBolloByFasciaTariffaria(Integer fasciaTariffaria) {
		return cerTariffaDirittoRepository.findByDirittoAndFasciaTariffaria(EDiritto.BOLLO, fasciaTariffaria)
	}

	private void validaDati(CerTariffaDiritto obj) {
		if ( (obj.diritto == null) || (obj.fasciaTariffaria == null) ){
			throw new CampoMandatoryRuntimeException()
		}

		obj.categoriaTipiCertificatoList.each {
			if (cerTariffaDirittoRepository.existsByIdAndCategoriaTipoCertificatoAndDiritto(obj.id ?: null, it, obj.diritto)) {
				throw new CategoriaGiaAssociataADirittoRuntimeException(it, obj.diritto)
			}
		}
	}

	CerTariffaDiritto save(CerTariffaDiritto obj) {
		validaDati(obj)
		if (obj.id == null) {
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		return cerTariffaDirittoRepository.save(obj)
	}

	void delete(CerTariffaDiritto obj){
		if (obj.id != null) {
			cerTariffaDirittoRepository.delete(obj)
		}
	}

	List<CerTariffaDiritto> listAllByDiritto(EDiritto diritto) {
		return cerTariffaDirittoRepository.findAllByDirittoOrderByFasciaTariffaria(diritto)
	}

	List<CerCategoriaTipoCertificato> listAllByTariffaDiritto(Long id) {
		return cerTariffaDirittoRepository.findCategoriaTipoCertificatoListById(id)
	}

}
