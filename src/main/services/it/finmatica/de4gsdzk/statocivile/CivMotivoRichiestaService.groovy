package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivMotivoRichiestaService {

	private final CivMotivoRichiestaRepository civMotivoRichiestaRepository

	CivMotivoRichiestaService(CivMotivoRichiestaRepository civMotivoRichiestaRepository) {
		this.civMotivoRichiestaRepository = civMotivoRichiestaRepository
	}

	CivMotivoRichiesta get (Long id){
		return civMotivoRichiestaRepository.findById(id)
	}

	Page<CivMotivoRichiesta> listAllByDescrizioneLike(String filtro, PageRequest p, Map params) {
		if (params.tipoAttoEnum == null) {
			return new PageImpl<CivMotivoRichiesta>([])
		}
		Integer tipoAtto = (params.tipoAttoEnum as ETipoAtto)?.valore
		civMotivoRichiestaRepository.findAllByDescrizioneLikeIgnoreCaseAndTipoAtto(filtro, tipoAtto, p)
	}

	List<CivMotivoRichiesta> listAllByCategoriaAndTipoRichiesta(CivCategoriaTipoAtto categoria, ETipoRichiesta tipoRichiesta, String filtro, Map params) {
		if (categoria){
			if (params?.ricorrenti){
				return civMotivoRichiestaRepository.findAllByCategoriaDomainAndTipoRichiestaAndDescrizioneLikeIgnoreCaseAndRicorrenteOrderByDescrizione(categoria.tipoAtto, categoria, tipoRichiesta, filtro, Boolean.TRUE)
			}
			if (params?.nonRicorrenti){
				return civMotivoRichiestaRepository.findAllByCategoriaDomainAndTipoRichiestaAndDescrizioneLikeIgnoreCaseAndRicorrenteOrderByDescrizione(categoria.tipoAtto, categoria, tipoRichiesta, filtro, Boolean.FALSE)
			}
			// Tutti senza distinzione fra ricorrenti e non ricorrenti
			return civMotivoRichiestaRepository.findAllByTipoAttoAndCategoriaDomainAndTipoRichiestaAndDescrizioneLikeIgnoreCaseOrderByDescrizione(categoria.tipoAtto, categoria, tipoRichiesta, filtro)
		}
		return []
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivMotivoRichiesta obj){
		if ( (obj.id == null) || (obj.tipoRichiesta == null) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (TestoUtils.isVuoto(obj.descrizione)) {
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
		}

		if (tipoOperazione.isInsert()){
			long n = civMotivoRichiestaRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
			}
		}
	}

	CivMotivoRichiesta save (ETipoOperazione tipoOperazione, CivMotivoRichiesta obj){

		validaDati(tipoOperazione, obj)

		log.info("Lancio salvataggio su CIVDMC per id " + obj.id)
		return  civMotivoRichiestaRepository.save(obj)
	}

}
