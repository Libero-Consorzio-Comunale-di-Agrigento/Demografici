package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.FileNameNonAttesoRuntimeException
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificatoRepository
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazione
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.io.FilenameUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerTipoCertificatoService {

	private final CerTipoCertificatoRepository cerTipoCertificatoRepository
	private final GestioneTestiGsdModelloService gestioneTestiGsdModelloService
	private final GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

	CerTipoCertificatoService(CerTipoCertificatoRepository cerTipoCertificatoRepository,
							  GestioneTestiGsdModelloService gestioneTestiGsdModelloService,
							  GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService) {
		this.cerTipoCertificatoRepository = cerTipoCertificatoRepository
		this.gestioneTestiGsdModelloService = gestioneTestiGsdModelloService
		this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
	}

	CerTipoCertificato get (String id){
		return cerTipoCertificatoRepository.findById(id)
	}

	Page<CerTipoCertificato> listAllByDescrizioneEstesaLike(String filtro, PageRequest p) {
		return cerTipoCertificatoRepository.findAllByDescrizioneEstesaLikeIgnoreCase(TestoUtils.isVuoto(filtro) ? "%" : SqlUtils.beginsAndEndsLike(filtro), p)
	}

	Page<CerTipoCertificato> listAllByDescrizioneLike(String filtro, PageRequest p) {
		return cerTipoCertificatoRepository.findAllByDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(filtro) ? "%" : SqlUtils.beginsAndEndsLike(filtro), p)
	}

	Page<CerTipoCertificato> listAllByCategoriaAndDescrizioneLike(CerCategoriaTipoCertificato categoriaTipoCertificato, String filtro, PageRequest p) {
		return cerTipoCertificatoRepository.findAllByCategoriaAndDescrizioneLikeIgnoreCase(categoriaTipoCertificato, TestoUtils.isVuoto(filtro) ? "%" : SqlUtils.beginsAndEndsLike(filtro), p)
	}

	Boolean existsByCategoriaNone() {
		Long count = cerTipoCertificatoRepository.countByCategoriaTipoCertificatoIsNull()
		return count > 0
	}

	Page<CerTipoCertificato> listByParams(Map params) {
		return cerTipoCertificatoRepository.listByParams(params)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerTipoCertificato obj, GestioneTestiModelloRelazione modelloRelazione, boolean force = false) {
		if(obj.categoriaTipoCertificato == null){
			throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_tipo_certificato_categoria)
		}

		if (TestoUtils.isVuoto(obj?.id) ||
				TestoUtils.isVuoto(obj?.descrizione) ||
				obj.firma == null) {
			throw new CampoMandatoryRuntimeException()
		}

		if (obj.isStatoCivile()) {
			if (obj.tipoAttoEnum == null) {
				throw new CampoMandatoryRuntimeException()
			}
			if (obj.filtro == null) {
				throw new CampoMandatoryRuntimeException()
			}
		}

		if (tipoOperazione.isInsert()){
			long n = cerTipoCertificatoRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}

		if (modelloRelazione.modello.fileTemplate != null) {
			if (modelloRelazione.modello.fileTemplate?.size() == 0) {
				throw new FileNonValidoRuntimeException(EtichetteMessaggi.Errore_file_vuoto)
			}

			String nomeModelloCaricato = FilenameUtils.removeExtension(modelloRelazione.modello.nome)
			if (TestoUtils.isVuoto(nomeModelloCaricato)) {
				throw new FileNonValidoRuntimeException(EtichetteMessaggi.Errore_file_nome_vuoto)
			}

			String nomeModelloStandard = FileUtils.getNomeModelloTipoCertificatoStandard(obj.id)
			if ((nomeModelloCaricato != nomeModelloStandard) && (!(force))) {
				throw new FileNameNonAttesoRuntimeException("(Nome file atteso: ${nomeModelloStandard})")
			}
		}
	}

	CerTipoCertificato save(ETipoOperazione tipoOperazione, CerTipoCertificato obj, GestioneTestiModelloRelazione modelloRelazione, boolean force = false) {
		validaDati(tipoOperazione, obj, modelloRelazione, force)

		CerTipoCertificato c = cerTipoCertificatoRepository.save(obj)

		// modello
		if (modelloRelazione.modello.fileTemplate != null) {
			modelloRelazione.modello.codice = FileUtils.getCodiceModelloTipoCertificatoStandard(c.id)
			modelloRelazione.modello = gestioneTestiGsdModelloService.save(modelloRelazione.modello)
			modelloRelazione.tipoCertificato = c
			// relazione
			gestioneTestiModelloRelazioneService.save(modelloRelazione)
		}

		return c
	}

	void delete(CerTipoCertificato obj) {
		if (obj.id != null) {
			cerTipoCertificatoRepository.delete(obj)
		}
	}

}
