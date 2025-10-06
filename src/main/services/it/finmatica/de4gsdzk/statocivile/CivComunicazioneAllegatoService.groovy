package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IDaFascicolare
import it.finmatica.de4gsdzk.errors.ErroreAllegatoDocumentaleRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneAllegatoRepository
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivComunicazioneAllegatoService {

	private final CivArchivioComunicazioneService civArchivioComunicazioneService

	private final CivFascicoloAttoService civFascicoloAttoService

	private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

	private final IntegrazioneDocumentaleService integrazioneDocumentaleService

	private final StatoCivileService statoCivileService

	private final CivComunicazioneAllegatoRepository civComunicazioneAllegatoRepository

	CivComunicazioneAllegatoService(CivComunicazioneAllegatoRepository civComunicazioneAllegatoRepository, StatoCivileService statoCivileService,
									CivArchivioComunicazioneService civArchivioComunicazioneService, IntegrazioneDocumentaleService integrazioneDocumentaleService,
									CivFascicoloAttoService civFascicoloAttoService, CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService) {

		this.civComunicazioneAllegatoRepository = civComunicazioneAllegatoRepository
		this.statoCivileService = statoCivileService
		this.civArchivioComunicazioneService = civArchivioComunicazioneService
		this.civFascicoloAttoService = civFascicoloAttoService
		this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
		this.integrazioneDocumentaleService = integrazioneDocumentaleService
	}

	CivComunicazioneAllegato get (Long id){
		return civComunicazioneAllegatoRepository.findById(id)
	}

	CivComunicazioneAllegato getPrincipale (Long idArcCom){
		return civComunicazioneAllegatoRepository.findPrincipale(idArcCom)
	}

	List<Map> listAllMetadatiByArchivioComunicazione(Long idArcCom){
		List<Object[]> l = civComunicazioneAllegatoRepository.findAllMetadatiByArchivioComunicazione(idArcCom)
		List<Map> result = []
		for (Object[] o: l){
			result.add([id: o[0], nomeAllegato: o[1], daFirmare:(o[2] == ETipoSN.S) , firmato:(o[3] == ETipoSN.S), noteWSFirma: o[4], principale:o[5], idArchivioComunicazione: o[6]])
		}
		return result
	}

	Integer getNumAllegatiComunicazioneByNome(Long idArcCom, Long idComAlle, String nome){
		if (idArcCom != null){
			return civComunicazioneAllegatoRepository.getNumAllegatiComunicazioneByNome(idArcCom, idComAlle, nome)
		}
		return null
	}

	Boolean checkAllegatiDaFirmare(List<Long> idsArcCom){
		Integer n = civComunicazioneAllegatoRepository.checkAllegatiDaFirmare(idsArcCom)
		return (n.intValue() > 0)
	}

	void validaDatiPre(CivComunicazioneAllegato obj, Boolean ignoreStato=Boolean.FALSE, Boolean ignoreStampaEseguita=Boolean.FALSE){
		if (!(ignoreStato)) {
			civArchivioComunicazioneService.bloccaSeProtocollata(obj.archivioComunicazione)
			civArchivioComunicazioneService.bloccaSeInviataAlbo(obj.archivioComunicazione)
		}

		if (!(ignoreStampaEseguita)) {
			civArchivioComunicazioneService.bloccaSeStampaEseguita(obj.archivioComunicazione)
		}
	}

	private void validaDati(CivComunicazioneAllegato obj, Boolean ignoreStato=Boolean.FALSE, Boolean ignoreStampaEseguita=Boolean.FALSE){

		validaDatiPre(obj, ignoreStato, ignoreStampaEseguita)

		if (!ignoreStampaEseguita){
			Boolean hasPrincipale = civArchivioComunicazioneService.checkAllegatoPrincipale(obj.archivioComunicazione.id)
			if (obj.principale && hasPrincipale){
				throw new ErroreDatiComunicazioneRuntimeException(EtichetteMessaggi.Errore_salvataggio_testo_comunicazione)
			}
		}

		// Check nome allegato
		Integer nAlle = getNumAllegatiComunicazioneByNome(obj.archivioComunicazione.id, obj.id, obj.nomeAllegato)
		if (nAlle == null){
			nAlle = new Integer(0)
		}
		if ( nAlle.intValue() > 0) {
			throw new ErroreAllegatoDocumentaleRuntimeException(EtichetteMessaggi.Errore_inserimento_nome_allegato_comunicazione)
		}
	}

	CivComunicazioneAllegato save (CivComunicazioneAllegato obj, Boolean salvaSuDocumentale, InputStream is, Boolean ignoreStato=Boolean.FALSE, Boolean ignoreStampaEseguita=Boolean.FALSE, Boolean aggiornaStampaEseguita=Boolean.FALSE){
		validaDati(obj, ignoreStato, ignoreStampaEseguita)

		CivArchivioComunicazione arcCom = civArchivioComunicazioneService.get(obj.archivioComunicazione.id)
		if (salvaSuDocumentale) {
			if (arcCom.idDocumentoEsterno == null) {
				// Devo salvare su gdm
				civArchivioComunicazioneService.save(arcCom, Boolean.TRUE, Boolean.TRUE, Boolean.TRUE)
			}
			//Posso leggere id_atto da arcCom perchè arcCom è già su db
			String identificativo = (arcCom.idAtto?:statoCivileService.getIdentificativoAtto(arcCom.tipoAtto, arcCom.ufficio, arcCom.anno, arcCom.parte, arcCom.serie, arcCom.atto))
			List<Campo> metadati = MetadatiGdmUtils.listMetadatiAtto(arcCom, identificativo)
			integrazioneDocumentaleService.addFileToDocumentale(arcCom, obj, is, metadati, true, EModelloGdm.FascicoliStatoCivile)
		}

		if (aggiornaStampaEseguita) {
			if (arcCom.isDaProtocollare() || arcCom.isDaInviareAlbo()) {
				log.info(arcCom.id + ": non aggiorno il flag stampa_eseguita in quanto comunicazione da protocollare o inviare all'albo")
			} else {
				arcCom.stampaEseguita = Boolean.TRUE
				civArchivioComunicazioneService.save(arcCom, Boolean.TRUE)
			}
		}

		if (obj.id == null){
			// solo in caso di inserimento
			obj.id = statoCivileService.getIdFromSequence(obj)
		}
		log.info("Lancio salvataggio su CIVCOM_ALLE per id " + obj.id)
		CivComunicazioneAllegato savedComAlle = civComunicazioneAllegatoRepository.save(obj)
		return savedComAlle
	}

	private Boolean fascicolaAllegato(CivComunicazioneAllegato obj, CivFascicoloAtto fascicoloAtto, IDaFascicolare df, Boolean salvaPregressoSuDocumentale=Boolean.FALSE){
		Boolean allegatoAggiuntoAlFascicolato = Boolean.FALSE
		CivFascicoloAtto fa = fascicoloAtto
		if (fa == null){
			fa = civArchivioComunicazioneService.fascicolaComunicazione(obj.archivioComunicazione, df, salvaPregressoSuDocumentale)
		}

		if (salvaPregressoSuDocumentale && obj.blobAllegato){
			save(obj, Boolean.TRUE, new ByteArrayInputStream(obj.blobAllegato), Boolean.TRUE, Boolean.TRUE)
		}

		CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.getByFascicoloAndComunicazioneAllegato(fa.id, obj.id)
		if (fal == null){
			fal = civFascicoloAttoAllegatoService.createXAllegatoComunicazione(fa, obj)
			allegatoAggiuntoAlFascicolato = Boolean.TRUE
		}
		// Mantengo sempre allineato il nome del file
		fal.nome = obj.getNome()
		civFascicoloAttoAllegatoService.save(fal, Boolean.FALSE, null)

		return allegatoAggiuntoAlFascicolato
	}

	int fascicolaComunicazioneEAllegati(CivArchivioComunicazione arcCom, IDaFascicolare df, Boolean salvaPregressoSuDocumentale=Boolean.FALSE){
		int retVal = -1 //Comunicazione già fascicolata (Valori possibili: -1, 0, 1)
		// Controllo nome file univoco
		List<CivComunicazioneAllegato> listaAllegatiComunicazione = []
		for (Map m: listAllMetadatiByArchivioComunicazione(arcCom.id)){
			CivComunicazioneAllegato alleCom = get(m.id)
			listaAllegatiComunicazione.add(alleCom)
			validaDati(alleCom, Boolean.TRUE, Boolean.TRUE)
		}
		if (listaAllegatiComunicazione.size() == 0){
			retVal = 0 // Nessun allegato da fascicolare
		}

		CivFascicoloAtto fa = civArchivioComunicazioneService.fascicolaComunicazione(arcCom, df, salvaPregressoSuDocumentale)

		for (CivComunicazioneAllegato alleCom: listaAllegatiComunicazione){
			if (fascicolaAllegato(alleCom, fa, df, salvaPregressoSuDocumentale)){
				retVal = 1 // Almeno un allegato fascicolato
			}
		}
		return retVal
	}

	void deleteAllegato(CivComunicazioneAllegato obj){
		validaDatiPre(obj)
		// Cancello dal documentale
		if ( (obj.idFileEsterno != null) && (obj.archivioComunicazione.idDocumentoEsterno != null) ){
			integrazioneDocumentaleService.removeFile(obj.archivioComunicazione, obj)
		}
		// Cancello dal fascicolo
		CivFascicoloAtto fa = civFascicoloAttoService.getByUkAttoAndTipoAttoAndArchivioComunicazione(obj.archivioComunicazione.idAtto, obj.archivioComunicazione.tipoAtto, obj.archivioComunicazione)
		if (fa != null){
			CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.getByFascicoloAndComunicazioneAllegato(fa.id, obj.id)
			civFascicoloAttoAllegatoService.deleteAllegato(fal)
		}
		//Cancello da civcom_alle
		log.info("Tento cancellazione su CIVCOM_ALLE per id " + obj.id)
		civComunicazioneAllegatoRepository.delete(obj)
	}

	void deleteComunicazioneEAllegati(CivArchivioComunicazione arcCom){
		List<Map> l = listAllMetadatiByArchivioComunicazione(arcCom.id)
		for (Map m: l){
			deleteAllegato(get(m.id))
		}

		civArchivioComunicazioneService.deleteComunicazione(arcCom)
	}

}
