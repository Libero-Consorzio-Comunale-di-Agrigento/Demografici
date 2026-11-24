package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerModalitaRilascioService {

	private final CerModalitaRilascioRepository cerModalitaRilascioRepository
	private final CerTariffaDirittoService cerTariffaDirittoService

    CerModalitaRilascioService(CerModalitaRilascioRepository cerModalitaRilascioRepository,
							   CerTariffaDirittoService cerTariffaDirittoService) {
		this.cerModalitaRilascioRepository = cerModalitaRilascioRepository
		this.cerTariffaDirittoService = cerTariffaDirittoService
	}

	CerModalitaRilascio get (Integer id){
		return cerModalitaRilascioRepository.findById(id)
	}

	Page<CerModalitaRilascio> listAllByDescrizioneLike(String filtro, PageRequest p) {
		return cerModalitaRilascioRepository.findAllByDescrizioneLikeIgnoreCase(TestoUtils.isVuoto(filtro) ? "%" : SqlUtils.beginsAndEndsLike(filtro), p)
	}

	Page<CerModalitaRilascio> listAllNonDismessiByCategoriaTipoCertificatoAndDescrizioneEstesaLike(CerCategoriaTipoCertificato categoriaTipoCertificato, String filtro, PageRequest p) {
		if (categoriaTipoCertificato == null) {
			return cerModalitaRilascioRepository.findAllByDescrizioneEstesaLikeIgnoreCaseAndFlagDismessoFalse(SqlUtils.beginsAndEndsLike(filtro), p)
		}

		List<CerCategoriaTipoCertificato> ll = [categoriaTipoCertificato]
		if (categoriaTipoCertificato != categoriaTipoCertificato.categoriaTipoCertificatoFiltroModalitaRilascio) {
			ll.add(categoriaTipoCertificato.categoriaTipoCertificatoFiltroModalitaRilascio)
		}
		return cerModalitaRilascioRepository.findAllByCategoriaTipoCertificatoInListAndDescrizioneEstesaLikeIgnoreCaseAndFlagDismessoFalse(ll, SqlUtils.beginsAndEndsLike(filtro), p)
	}

	Page<CerModalitaRilascio> listAllNonDismessiByDescrizioneStampaLike(String filtro, PageRequest p) {
		return cerModalitaRilascioRepository.findAllByDescrizioneStampaLikeIgnoreCaseAndFlagDismessoFalse(SqlUtils.beginsAndEndsLike(filtro), p)
	}

	List<CerTariffaDiritto> listAllTariffaDirittoByDirittoBollo(){
		return cerTariffaDirittoService.listAllByDiritto(EDiritto.BOLLO)
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerModalitaRilascio obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerModalitaRilascioRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
			}
		}
	}

	CerModalitaRilascio save(ETipoOperazione tipoOperazione, CerModalitaRilascio obj) {
		validaDati(tipoOperazione, obj)
		return cerModalitaRilascioRepository.save(obj)
	}

	void delete(CerModalitaRilascio obj){
		if (obj.id != null) {
			cerModalitaRilascioRepository.delete(obj)
		}
	}

}
