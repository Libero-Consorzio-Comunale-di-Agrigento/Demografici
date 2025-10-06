package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdFirmaService
import it.finmatica.de4gsdzk.certificazione.error.CertificatoAnnullatoException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.integrazioni.documentale.IntegrazioneDocumentaleService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmessoRepository
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.DomainUtils
import it.finmatica.de4gsdzk.utils.MetadatiGdmUtils
import it.finmatica.gestionetesti.GestioneTestiService
import it.finmatica.smartdoc.api.struct.Campo
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerCertificatoEmessoService {

	private final CerCertificatoEmessoRepository cerCertificatoEmessoRepository

	private final UtenteCustomService utenteCustomService

	private final StatoCivileService statoCivileService

	private final CerIndividuoCertificatoService cerIndividuoCertificatoService

	private final CerTerminalistaService cerTerminalistaService

	private final CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService

	private final IntegrazioneDocumentaleService integrazioneDocumentaleService

	private final GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

	private final GestioneTestiService gestioneTestiService

	private final GsdFirmaService gsdFirmaService

	CerCertificatoEmessoService(CerCertificatoEmessoRepository cerCertificatoEmessoRepository,
								UtenteCustomService utenteCustomService,
								StatoCivileService statoCivileService,
								CerIndividuoCertificatoService cerIndividuoCertificatoService,
								CerTerminalistaService cerTerminalistaService,
								CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService,
								IntegrazioneDocumentaleService integrazioneDocumentaleService,
								GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService,
								GestioneTestiService gestioneTestiService,
								GsdFirmaService gsdFirmaService) {
		this.cerCertificatoEmessoRepository = cerCertificatoEmessoRepository
		this.utenteCustomService = utenteCustomService
		this.statoCivileService = statoCivileService
		this.cerTerminalistaService = cerTerminalistaService
		this.cerIndividuoCertificatoService = cerIndividuoCertificatoService
		this.cerFondoCassaTerminalistaService = cerFondoCassaTerminalistaService
		this.integrazioneDocumentaleService = integrazioneDocumentaleService
		this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
		this.gestioneTestiService = gestioneTestiService
		this.gsdFirmaService = gsdFirmaService
	}

	CerCertificatoEmesso get (Long id){
		return cerCertificatoEmessoRepository.findById(id)
	}

	Page<CerCertificatoEmesso> listAllByRicercaCertificato (RicercaCertificato r, PageRequest p) {
		return cerCertificatoEmessoRepository.findAllByRicercaCertificato(r, p)
	}

	CerCertificatoEmesso create() {
		CerCertificatoEmesso obj = new CerCertificatoEmesso()
		obj.annoEmissione = DataUtils.getAnnoCorrente()
		obj.dataEmissione = DataUtils.getDataCorrente()
		return obj
	}

	CerCertificatoEmesso saveNew(CerCertificatoEmesso obj, Integer matricola, CivAttoBaseDomain atto) {
		// Creo sempre un nuovo certificato emesso
		obj.id = statoCivileService.getIdFromSequence(obj)
		obj.progressivoEmissione = statoCivileService.getProgressivoCertificato(obj.annoEmissione)

		save(obj)

		// Ottengo l'elemento perché i trigger potrebbero aver modificato l'elemento
		obj = get(obj.id)

		// Creo l'individuo
		CerIndividuoCertificato indCer = cerIndividuoCertificatoService.create(obj.annoEmissione, obj.progressivoEmissione)
		if (obj.tipoCertificato.isAnagrafe()) {
			indCer.matricola = matricola
		} else if (obj.tipoCertificato.isStatoCivile()) {
			DomainUtils.initFromAtto(indCer, atto)
		}
		cerIndividuoCertificatoService.save(indCer)

		return obj
	}

	private void validaDati(CerCertificatoEmesso obj) {
		if (obj.id == null) {
			throw new IllegalStateException("id non valorizzato")
		}
		if (obj.progressivoEmissione == null) {
			throw new IllegalStateException("progressivoEmissione non valorizzato")
		}
		if ((obj.annoEmissione == null) || (obj.tipoCertificato == null) || (obj.modalitaRilascio == null) || (obj.beneficiario == null)) {
			throw new CampoMandatoryRuntimeException()
		}
	}

	CerCertificatoEmesso save(CerCertificatoEmesso obj) {
		validaDati(obj)

		if (obj.isAnnullato()) {
			throw new CertificatoAnnullatoException()
		}

		return cerCertificatoEmessoRepository.save(obj)
	}

	void saveAllegatoDocumentale(CerCertificatoEmesso obj, byte[] bytes) {
		List<Campo> metadati = MetadatiGdmUtils.listMetadatiCertificazione(obj, obj.idEmissione)
		integrazioneDocumentaleService.addFileToDocumentale(obj, obj, new ByteArrayInputStream(bytes), metadati, EModelloGdm.CertificatiEmessi)

		cerCertificatoEmessoRepository.save(obj)
	}

	void saveAllegatoLocale(CerCertificatoEmesso obj, byte[] bytes) {
		obj.blobAllegato = bytes

		cerCertificatoEmessoRepository.save(obj)
	}

	void downloadAllegato(CerCertificatoEmesso obj) {
		gsdFirmaService.scaricaAllegato(obj, obj)
	}

	void annullaCertificato(CerCertificatoEmesso obj, String noteAnnullamento) {
		cerCertificatoEmessoRepository.annullaCertificato(obj.id,
				cerTerminalistaService.getTerminalistaUtente(),
				DataUtils.getDataCorrente(),
				noteAnnullamento)
	}

	void ripristinaCertificato(CerCertificatoEmesso obj) {
		cerCertificatoEmessoRepository.ripristinaCertificato(obj.id,
				utenteCustomService.loggedUserId,
				DataUtils.getDataCorrente())
	}
}
