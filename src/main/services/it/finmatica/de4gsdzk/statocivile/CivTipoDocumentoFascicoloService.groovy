package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreLunghezzaCampiRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicoloRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivTipoDocumentoFascicoloService {

	private final StatoCivileService statoCivileService

	private final CivFascicoloAttoService civFascicoloAttoService

	private final CivTipoDocumentoFascicoloRepository civTipoDocumentoFascicoloRepository

	CivTipoDocumentoFascicoloService(CivTipoDocumentoFascicoloRepository civTipoDocumentoFascicoloRepository,
									 CivFascicoloAttoService civFascicoloAttoService, StatoCivileService statoCivileService){

		this.civTipoDocumentoFascicoloRepository = civTipoDocumentoFascicoloRepository
		this.civFascicoloAttoService = civFascicoloAttoService
		this.statoCivileService = statoCivileService
	}

	CivTipoDocumentoFascicolo get (Long id){
		return civTipoDocumentoFascicoloRepository.findById(id)
	}

	Page<CivTipoDocumentoFascicolo> listAllByTipoAttoOrderByDescrizione(ETipoAtto tipoAttoEnum, Boolean ricorrente=Boolean.FALSE, String filtro=null, PageRequest p=null){
		return listAllByTipoAttoOrderByDescrizione(new Integer(tipoAttoEnum.valore), (tipoAttoEnum == ETipoAtto.PVU), ricorrente, filtro, p)
	}

	Page<CivTipoDocumentoFascicolo> listAllByTipoAttoOrderByDescrizione(Integer tipoAtto, Boolean isPV=Boolean.FALSE, Boolean ricorrente=Boolean.FALSE, String filtro=null, PageRequest p=null) {
		if (tipoAtto == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_tipo_atto)
		}
		PageRequest pr = p
		if (pr == null){
			pr = new PageRequest(0, Integer.MAX_VALUE)
		}
		String f = SqlUtils.beginsAndEndsLike(filtro?:"%")
		return civTipoDocumentoFascicoloRepository.findAllByTipoAttoAndIsProcessoVerbaleAndRicorrenteAndDescrizioneLikeOrderByDescrizione(tipoAtto, isPV, ricorrente, f, pr)
	}

	private void validaDati(CivTipoDocumentoFascicolo obj){
		if (obj.tipoAtto == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_tipo_atto)
		}

		if (obj.codice == null){
			throw new CampoMandatoryRuntimeException()
		}

		if (obj.codice.length() > 2){
			throw new ErroreLunghezzaCampiRuntimeException("Codice")
		}

		// Controlla l'unicità del codice
		CivTipoDocumentoFascicolo esistente = civTipoDocumentoFascicoloRepository.findByTipoAttoAndCodiceIgnoreCase(obj.tipoAtto, obj.codice)
		if (esistente && (esistente.id != obj.id) ) {
			throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
		}
		// Non posso cambiare la descrizione se ho associato dei fascicoli
		if (esistente && (!(esistente.descrizione.equalsIgnoreCase(obj.descrizione))) ){
			if (civFascicoloAttoService.existsFascicoloXTipoDocumento(obj)) {
				throw new ErroreDatiFascicoloRuntimeException(EtichetteMessaggi.Errore_modifica_tipo_documento_x_fascicolazione)
			}
		}
	}

	CivTipoDocumentoFascicolo save (CivTipoDocumentoFascicolo obj){

		validaDati(obj)

		if (obj.id == null){
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVDDO per id " + obj.id)
		return  civTipoDocumentoFascicoloRepository.save(obj)
	}

	void delete(CivTipoDocumentoFascicolo obj){
		if (obj.id != null){
			log.info("Tento cancellazione su CIVDDO per id " + obj.id)
			civTipoDocumentoFascicoloRepository.delete(obj)
		}
	}
}
