package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerTipoPagamentoRepository
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerTipoPagamentoService {

	private final CerTipoPagamentoRepository cerTipoPagamentoRepository

    CerTipoPagamentoService(CerTipoPagamentoRepository cerTipoPagamentoRepository) {
		this.cerTipoPagamentoRepository = cerTipoPagamentoRepository
	}

	CerTipoPagamento get (Integer id){
		return cerTipoPagamentoRepository.findById(id)
	}

	List<CerTipoPagamento> listAll() {
		return cerTipoPagamentoRepository.findAll(new Sort(SortUtils.idAsc))
	}

	private void validaDati(ETipoOperazione tipoOperazione, CerTipoPagamento obj) {
		if ( (obj.id == null) || TestoUtils.isVuoto(obj?.descrizione) ){
			throw new CampoMandatoryRuntimeException()
		}

		if (tipoOperazione.isInsert()){
			long n = cerTipoPagamentoRepository.countById(obj.id)
			if (n > 0) {
				throw new RecordDuplicatoRuntimeException(EtichetteMessaggi.Errore_Inserimento_Record_duplicato)
			}
		}
	}

	CerTipoPagamento save(ETipoOperazione tipoOperazione, CerTipoPagamento obj) {
		validaDati(tipoOperazione, obj)
		return cerTipoPagamentoRepository.save(obj)
	}

}
