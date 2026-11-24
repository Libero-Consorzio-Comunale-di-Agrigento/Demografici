package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.allegati.IAllegatoService
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoBaseDomain
import it.finmatica.de4gsdzk.ansc.AnscComunicazioneAllegatoService
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreAllegatoDocumentaleRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiFascicoloRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivFascicoloAttoAllegatoService implements IAllegatoService {

	private final IntegrazioneDocumentaleService integrazioneDocumentaleService

	private final GsdService gsdService

	private final CivFascicoloAttoService civFascicoloAttoService

	private final GsdFirmaService gsdFirmaService

	private final AnscComunicazioneAllegatoService anscComunicazioneAllegatoService

	private final CivFascicoloAttoAllegatoRepository civFascicoloAttoAllegatoRepository

    CivFascicoloAttoAllegatoService(CivFascicoloAttoAllegatoRepository civFascicoloAttoAllegatoRepository,
									GsdService gsdService, GsdFirmaService gsdFirmaService,
									AnscComunicazioneAllegatoService anscComunicazioneAllegatoService,
									CivFascicoloAttoService civFascicoloAttoService, IntegrazioneDocumentaleService integrazioneDocumentaleService) {
		this.civFascicoloAttoAllegatoRepository = civFascicoloAttoAllegatoRepository
		this.gsdFirmaService = gsdFirmaService
		this.anscComunicazioneAllegatoService = anscComunicazioneAllegatoService
		this.gsdService = gsdService
		this.civFascicoloAttoService = civFascicoloAttoService
		this.integrazioneDocumentaleService = integrazioneDocumentaleService
	}

	CivFascicoloAttoAllegato get (Long id){
		return civFascicoloAttoAllegatoRepository.findById(id)
	}

	Boolean refersAllegatoComunicazione(Long id){
		CivComunicazioneAllegato alle = civFascicoloAttoAllegatoRepository.findComunicazioneAllegatoByIdFascicoloAllegato(id)
		return (alle != null)
	}

	CivFascicoloAttoAllegato create(CivFascicoloAtto fa, String nomeFile){
		new CivFascicoloAttoAllegato(fascicoloAtto: fa, nome: nomeFile)
	}

	CivFascicoloAttoAllegato create(CivFascicoloAtto fa, String nomeFile, Boolean flagAttestazione){
		new CivFascicoloAttoAllegato(fascicoloAtto: fa, nome: nomeFile, flagDaAttestareAnsc: flagAttestazione)
	}

	CivFascicoloAttoAllegato createXAllegatoComunicazione(CivFascicoloAtto fa, CivComunicazioneAllegato civcomAlle){
		CivFascicoloAttoAllegato fal = new CivFascicoloAttoAllegato(fascicoloAtto: fa, allegatoComunicazione: civcomAlle)
		return fal
	}

	CivFascicoloAttoAllegato getByFascicoloAndComunicazioneAllegato(Long idFascicoloAtto, Long idComAlle){
		CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoRepository.findByIdFascicoloAttoAndIdComunicazioneAllegato(idFascicoloAtto, idComAlle)
		return fal
	}

	List<CivFascicoloAttoAllegato> listAllByIdFascicoloAttoOrderByDataModifica(Long idFascicoloAtto){
		if (idFascicoloAtto != null){
			return civFascicoloAttoAllegatoRepository.findAllByIdFascicoloAttoOrderByDataModifica(idFascicoloAtto)
		}
		return null
	}

	List<CivFascicoloAttoAllegato> listAllByUkAttoAndServizioAndCasoUsoAndCheckHashOrdered(String identificativoAtto, AnscEndPointServizio servizio, AnscCasoUsoBaseDomain casoUso, Integer tipoAtto, boolean checkHash){
		if (identificativoAtto && servizio && casoUso && tipoAtto) {
			return civFascicoloAttoAllegatoRepository.findAllByUkAttoAndServizioAndCasoUsoAndCheckHashOrdered(identificativoAtto, servizio, casoUso.id, tipoAtto, checkHash)
		}
		return []
	}

	List<CivFascicoloAttoAllegato> listAllByUkAttoAndTipoDocumentoFascicoloAndCheckHashOrdered(String identificativoAtto, CivTipoDocumentoFascicolo tipoDocumentoFascicolo, boolean checkHash){
		if (identificativoAtto && tipoDocumentoFascicolo) {
			return civFascicoloAttoAllegatoRepository.findAllByUkAttoAndTipoDocumentoFascicoloCheckHashOrdered(identificativoAtto, tipoDocumentoFascicolo, checkHash)
		}
		return []
	}

	Integer getNumAllegatiFascicoloByNome(Long idFascicoloAtto, Long idFascicolaAttoAllegato, String nome){
		if (idFascicoloAtto != null){
			return civFascicoloAttoAllegatoRepository.getNumAllegatiFascicoloByNome(idFascicoloAtto, idFascicolaAttoAllegato, nome)
		}
		return null
	}

	Integer getNumAllegatiFascicoloByNomeLike(Long idFascicoloAtto, Long idFascicolaAttoAllegato, String nome){
		if (idFascicoloAtto != null){
			return civFascicoloAttoAllegatoRepository.getNumAllegatiFascicoloByNomeLike(idFascicoloAtto, idFascicolaAttoAllegato, nome)
		}
		return null
	}

	void updateNote(Long id, String note){
		civFascicoloAttoAllegatoRepository.updateNote(id, note)
	}

	void scaricaAllegato(CivFascicoloAttoAllegato fal, boolean sbusta = false, boolean segnalaSbustamento = true){
		CivFascicoloAtto fa = civFascicoloAttoService.get(fal.fascicoloAtto.id)
		if (fal.allegatoComunicazione != null){
			gsdFirmaService.scaricaAllegato(fa.archivioComunicazione, fal.allegatoComunicazione, sbusta, segnalaSbustamento)
		} else {
			gsdFirmaService.scaricaAllegato(fal.fascicoloAtto, fal, sbusta, segnalaSbustamento)
		}
	}

	private void bloccaSeProtocollataOInviataAlbo(CivFascicoloAttoAllegato obj){
		CivFascicoloAtto fa = civFascicoloAttoService.get(obj.getFascicoloAtto().id)
		if (fa.archivioComunicazione?.isProtocollato()){
			throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazioni_protocollate"))
		}
		if (fa.archivioComunicazione?.isInviatoAlbo()){
			throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_modifica_comunicazioni_inviate_albo"))
		}
	}

	private void bloccaSeInviataAnsc(CivFascicoloAttoAllegato obj){
		if (anscComunicazioneAllegatoService.existsComunicazioneByIdAllegatoAndInviatoANSC(obj.id)){
			throw new ErroreDatiFascicoloRuntimeException(Etichette.getEtichetta("Errore_cancellazione_allegato_fascicolo_atto"))
		}
	}

	private void validaDatiPre(CivFascicoloAttoAllegato obj){
		bloccaSeProtocollataOInviataAlbo(obj)

		bloccaSeInviataAnsc(obj)
	}

	private void validaDati(CivFascicoloAttoAllegato obj){
        Boolean emptyMandatoryFields = (obj.fascicoloAtto == null)
        if (emptyMandatoryFields){
			throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_allegato_fascicolo"))
        }

		// Check nome allegato
		Integer nAlle = getNumAllegatiFascicoloByNome(obj.fascicoloAtto.id, obj.id, obj.nome)
		if (nAlle == null){
			nAlle = new Integer(0)
		}
		if ( nAlle.intValue() > 0) {
			throw new ErroreAllegatoDocumentaleRuntimeException(Etichette.getEtichetta("Errore_inserimento_nome_allegato_fascicolo_atto"))
		}
	}

	CivFascicoloAttoAllegato save (CivFascicoloAttoAllegato obj, Boolean salvaSuDocumentale, InputStream is){
		validaDati(obj)

		if (salvaSuDocumentale) {
			CivFascicoloAtto savedFas = civFascicoloAttoService.save(obj.getFascicoloAtto(), salvaSuDocumentale)
			String identificativo = (savedFas.idAtto?:gsdService.getIdentificativoAtto(savedFas.tipoAtto, savedFas.ufficio, savedFas.anno, savedFas.parte, savedFas.serie, savedFas.atto))
			List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(savedFas, identificativo)
			integrazioneDocumentaleService.addFileToDocumentale(savedFas, obj, is, metadati, true, EModelloGdm.FascicoliStatoCivile)
		}

		log.info("Lancio salvataggio su CIVFAS_ALLE per id " + (obj.id?:"") )
		return civFascicoloAttoAllegatoRepository.save(obj)
	}

	void deleteAllegato(CivFascicoloAttoAllegato obj){
		validaDatiPre(obj)
		// Cancello dal documentale
		if ( (obj.idFileEsterno != null) && (obj.fascicoloAtto.idDocumentoEsterno != null) ){
			integrazioneDocumentaleService.removeFile(obj.fascicoloAtto, obj)
		}
		// Cancello da civfas_alle
		log.info("Tento cancellazione su CIVFAS_ALLE per id " + obj.id)
		civFascicoloAttoAllegatoRepository.delete(obj)
	}

	void deleteFascicoloEAllegati(CivFascicoloAtto fascicoloAtto){
		if ((fascicoloAtto?.id) != null) {
			long n = civFascicoloAttoAllegatoRepository.countByFascicoloAtto(fascicoloAtto)
			if (n > 0) {
				throw new ErroreDatiFascicoloRuntimeException(Etichette.getEtichetta("Errore_cancellazione_fascicolo_atto"))
			}
			/*
			List<CivFascicoloAttoAllegato> l = listAllByIdFascicoloAttoOrderByDataModifica(fascicoloAtto.id)
			for (CivFascicoloAttoAllegato fal: l){
				deleteAllegato(fal)
			}
			*/
			civFascicoloAttoService.deleteFascicolo(fascicoloAtto)
		}
	}

	void deleteFascicoloEAllegatiXAtto(CivAttoBaseDomain atto){
		if (atto.idAtto){
			List<CivFascicoloAtto> lf = civFascicoloAttoService.listAllByAtto(atto, new PageRequest(0, Integer.MAX_VALUE)).toList()
			for (CivFascicoloAtto f:lf){
				deleteFascicoloEAllegati(f)
			}
		}
	}

}
