package it.finmatica.de4gsdzk.pagamento.nextstep

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
class NextStepUtenteService {
    private final NextStepUtenteRepository nextStepUtenteRepository

    NextStepUtenteService(NextStepUtenteRepository nextStepUtenteRepository) {
        this.nextStepUtenteRepository = nextStepUtenteRepository
    }

    NextStepUtente create() {
        return new NextStepUtente()
    }

    NextStepUtente get(String id) {
        return nextStepUtenteRepository.findById(id)
    }

    Page<NextStepUtente> listAllByUtenteLike(String parametroLike, PageRequest p) {
        return nextStepUtenteRepository.findAllByIdLikeIgnoreCaseOrIdentificativoProviderLikeIgnoreCase(TestoUtils.isVuoto(parametroLike) ? '%' : SqlUtils.beginsAndEndsLike(parametroLike), p)
    }

    private void validaDati(ETipoOperazione tipoOperazione, NextStepUtente obj) {
        if (TestoUtils.isVuoto(obj?.id) || TestoUtils.isVuoto(obj?.idEsterno)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = nextStepUtenteRepository.countById(obj.id)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    NextStepUtente save(ETipoOperazione tipoOperazione, NextStepUtente obj) {
        validaDati(tipoOperazione, obj)
        return nextStepUtenteRepository.save(obj)
    }

    void delete(NextStepUtente obj) {
        nextStepUtenteRepository.delete(obj)
    }
}
