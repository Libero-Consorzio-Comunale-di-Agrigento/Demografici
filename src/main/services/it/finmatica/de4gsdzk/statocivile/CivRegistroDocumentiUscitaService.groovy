package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscitaRepository
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.ValidationUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivRegistroDocumentiUscitaService implements IRegistroDocumentiService<CivRegistroDocumentiUscita, CivNumerazioneDocumentiUscita> {

	private final CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService

	private final CivRegistroDocumentiUscitaRepository civRegistroDocumentiUscitaRepository

	CivRegistroDocumentiUscitaService(CivRegistroDocumentiUscitaRepository civRegistroDocumentiUscitaRepository, CivNumerazioneDocumentiUscitaService civNumerazioneDocumentiUscitaService) {
		this.civNumerazioneDocumentiUscitaService = civNumerazioneDocumentiUscitaService
		this.civRegistroDocumentiUscitaRepository = civRegistroDocumentiUscitaRepository
	}

	Tuple2<CivRegistroDocumentiUscita, Collection<CivNumerazioneDocumentiUscita>> get (Integer id){
		new Tuple2<CivRegistroDocumentiUscita, Collection<CivNumerazioneDocumentiUscita>>(
				civRegistroDocumentiUscitaRepository.findById(id),
				civNumerazioneDocumentiUscitaService.listAllByIdRegistro(id)
		)
	}

	List<CivRegistroDocumentiUscita> listAll() {
		return civRegistroDocumentiUscitaRepository.findAll()
	}

	Page<CivRegistroDocumentiUscita> listAllByDescrizioneLike (String filtro, PageRequest p){
        if ( (filtro?.trim()?:"") != "") {
            return civRegistroDocumentiUscitaRepository.findAllByDescrizioneLike(filtro, p)
        } else {
            return civRegistroDocumentiUscitaRepository.findAllOrderedById(p)
        }
	}

	private void validaDati(ETipoOperazione tipoOperazione, CivRegistroDocumentiUscita obj){
		ValidationUtils.validaDatiObbligatori(obj)

		if ( (obj.descrizione?:"") == ""){
			throw new CampoMandatoryRuntimeException("( Descrizione)")
		}

		if (tipoOperazione.isInsert()){
			long n = civRegistroDocumentiUscitaRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Registro_Duplicato)
			}
		}
	}

	CivRegistroDocumentiUscita save(ETipoOperazione tipoOperazione, CivRegistroDocumentiUscita obj, LinkedHashSet<CivNumerazioneDocumentiUscita> listaNumeriDocumenti) {
		validaDati(tipoOperazione, obj)

		for (CivNumerazioneDocumentiUscita d : listaNumeriDocumenti) {
			civNumerazioneDocumentiUscitaService.save(d)
		}

		log.info("Lancio salvataggio su CIVRDU per id " + obj.id)
		return civRegistroDocumentiUscitaRepository.save(obj)
	}

}
