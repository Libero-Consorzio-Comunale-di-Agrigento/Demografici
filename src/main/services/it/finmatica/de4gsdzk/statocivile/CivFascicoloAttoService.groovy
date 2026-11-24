package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.DomainUtils
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import it.finmatica.smartdoc.api.struct.Campo
import it.finmatica.smartdoc.api.struct.Documento
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFascicoloAttoService {

	private final IntegrazioneDocumentaleService integrazioneDocumentaleService

	private final GsdService gsdService

	private final CivFascicoloAttoRepository civFascicoloAttoRepository

    CivFascicoloAttoService(CivFascicoloAttoRepository civFascicoloAttoRepository,
                            GsdService gsdService, IntegrazioneDocumentaleService integrazioneDocumentaleService) {
		this.civFascicoloAttoRepository = civFascicoloAttoRepository
		this.gsdService = gsdService
		this.integrazioneDocumentaleService = integrazioneDocumentaleService
	}

	CivFascicoloAtto get (Long id){
		return civFascicoloAttoRepository.findById(id)
	}

	Boolean refersComunicazione(Long id){
		CivArchivioComunicazione arcCom = civFascicoloAttoRepository.findComunicazioneByIdFascicolo(id)
		return (arcCom != null)
	}

	CivFascicoloAtto create(CivAttoBaseDomain atto, CivTipoDocumentoFascicolo tdf){
		CivFascicoloAtto fa = new CivFascicoloAtto(tipoDocumentoFascicolo: tdf)
		DomainUtils.initFromAtto(fa, atto)
		return fa
	}

	CivFascicoloAtto createXComunicazione(CivArchivioComunicazione arcCom, CivTipoDocumentoFascicolo tdf){
		CivFascicoloAtto fa = new CivFascicoloAtto(archivioComunicazione: arcCom, tipoDocumentoFascicolo: tdf)
		DomainUtils.initFromRiferimentoAtto(fa, arcCom)
		return fa
	}

	CivFascicoloAtto createWhereNotExists(CivAttoBaseDomain atto, CivTipoDocumentoFascicolo tdf){
		CivFascicoloAtto fa = getByUkAttoAndTipoAttoAndTipoDocumentoFascicolo(atto.idAtto, atto.tipoAtto, tdf)
		if (fa == null){
			fa = create(atto, tdf)
		}
		return fa
	}

	Boolean existsFascicoloXTipoDocumento(CivTipoDocumentoFascicolo tdf){
		if ((tdf?.id) != null){
			return (civFascicoloAttoRepository.countByTipoDocumentoFascicolo(tdf) > 0)
		}
		return Boolean.FALSE
	}

	CivFascicoloAtto getByUkAttoAndTipoAttoAndArchivioComunicazione(String identificativoAtto, Integer tipoAtto, CivArchivioComunicazione arcCom){
		CivFascicoloAtto fa = civFascicoloAttoRepository.findByUkAttoAndTipoAttoAndArchivioComunicazione(identificativoAtto, tipoAtto, arcCom)
		return fa
	}

	CivFascicoloAtto getByUkAttoAndTipoAttoAndTipoDocumentoFascicolo(String identificativoAtto, Integer tipoAtto, CivTipoDocumentoFascicolo tdf){
		CivFascicoloAtto fa = civFascicoloAttoRepository.findByUkAttoAndTipoAttoAndTipoDocumentoFascicolo(identificativoAtto, tipoAtto, tdf)
		return fa
	}

	Page<CivFascicoloAtto> listAllByAtto(CivAttoBaseDomain atto, PageRequest p){
		List<String> idAttoAll = [atto.idAtto]
		Boolean divorzio = Boolean.FALSE
		if ( (atto instanceof IAttoMatUci) && ((IAttoMatUci)atto).divorzio ){
			divorzio = Boolean.TRUE
		}
		List<Integer> lt = TipoAttoUtils.listTipiAttoAltroComunePerAtto(atto.getTipoAttoEnum(), divorzio)
		for (Integer t: lt){
			String idAttoAnn = gsdService.getIdentificativoAtto(t, atto.ufficio, atto.anno, atto.parte, atto.serie, atto.atto)
			idAttoAll.add(idAttoAnn)
		}
		return civFascicoloAttoRepository.findAllByUkAttoInList(idAttoAll, p)
	}

	private void validaDati(CivFascicoloAtto obj){
		Boolean emptyMandatoryFields = (obj.tipoDocumentoFascicolo == null)
		if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_tipo_documento_fascicolo"))
		}
		if (obj.id){
			// #66960
			// Se per caso provo a cambiare il tipo documento e ho delle comunicazioni associate
			// al vecchio tipo documento e inviate con successo ad ANSC, devo bloccare
			if (civFascicoloAttoRepository.contieneAllegatoByOldTipoDocumentoInviatoANSC(obj.id, obj.tipoDocumentoFascicolo.id)){
				throw new ErroreDatiFascicoloRuntimeException(Etichette.getEtichetta("Errore_modifica_tipo_documento_fascicolo_atto"))
			}
		}
	}

	void allineaGdm(CivFascicoloAtto obj){
		if ( (obj.idDocumentoEsterno != null) || (obj.archivioComunicazione?.idDocumentoEsterno != null) ){
			IDocumentoEsterno doc = (obj.archivioComunicazione?.idDocumentoEsterno != null)?obj.archivioComunicazione:obj
			List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(obj, obj.idAtto)
			integrazioneDocumentaleService.allineaGdm(doc, metadati)
		}
	}

	CivFascicoloAtto save (CivFascicoloAtto obj, Boolean salvaSuDocumentale=Boolean.TRUE){
		validaDati(obj)

		if (salvaSuDocumentale) {
			if (obj.idDocumentoEsterno == null) {
				// Devo salvare su gdm
				// Poiché sono in inserimento, idAtto potrebbe non essere stato generato dal trigger
				// sicché mi tocca recuperarlo tramite chiamata ad apposita function di db
				String identificativo = (obj.idAtto?:gsdService.getIdentificativoAtto(obj.tipoAtto, obj.ufficio, obj.anno, obj.parte, obj.serie, obj.atto))
				List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(obj, identificativo)
				Documento smartDoc = integrazioneDocumentaleService.salva(obj, metadati, EModelloGdm.FascicoliStatoCivile)
				if (smartDoc.id != null) {
					obj.idDocumentoEsterno = Long.parseLong(smartDoc.id)
				} else {
					throw new DocumentaleRuntimeException("Errore in fase di salvataggio: impossibile registrare il documento su sistema documentale")
				}
			}
		}

		log.info("Lancio salvataggio su CIVFAS")
		CivFascicoloAtto savedFas = civFascicoloAttoRepository.save(obj)
		return savedFas
	}

	//ATTENZIONE: cancella solo il fascicolo: occorre prima essere sicuri di aver cancellato gli allegati collegati
	void deleteFascicolo(CivFascicoloAtto obj){
		// Cancello dal documentale
		if ( obj.idDocumentoEsterno != null ){
			integrazioneDocumentaleService.eliminaDocumento(obj, true)
		}
		// Cancello da civfas
		log.info("Tento cancellazione su CIVFAS per id " + obj.id)
		civFascicoloAttoRepository.delete(obj)
	}

}
