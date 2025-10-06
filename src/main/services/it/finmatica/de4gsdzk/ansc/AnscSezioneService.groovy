package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscSezioneRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscSezioneService {

    private final AnscSezioneRepository anscSezioneRepository

    AnscSezioneService(AnscSezioneRepository anscSezioneRepository) {
        this.anscSezioneRepository = anscSezioneRepository
    }

    List<AnscSezione> listAllByServizioAndTipoAttoAndUseCaseAndLivelloAndSezionePadre(String servizio, Integer tipoAtto, Long idCdu, Integer livello, AnscSezione sezione) {
        return anscSezioneRepository.findAllByServizioAndTipoAttoAndUseCaseAndLivelloAndSezionePadreOrderBySequenza(servizio, tipoAtto, idCdu, livello, sezione)
    }

    List<AnscSezione> listAllByServizioAnyAndTipoAttoAnyAndUseCaseAnyAndLivelloOrderBySequenzaAsc(String servizio, Integer tipoAtto, Long idCdu, Integer livello) {
        // le notifiche non hanno un tipo di atto univoco nella tabella delle sezioni;
        // la testata non ha né servizio né tipo atto;
        // non posso usare query con nvl perché tirerei su, a parità di servizio, sia le sezioni con tipo atto valorizzato
        // che le sezioni con tipo atto nullo
        List<AnscSezione> l = anscSezioneRepository.findAllByServizioIsNullAndTipoAttoIsNullAndUseCaseIsNullAndLivelloOrderBySequenza(livello)
        List lta = anscSezioneRepository.findAllByServizioAndTipoAttoAndUseCaseAndLivelloOrderBySequenza(servizio, tipoAtto, idCdu, livello)
        if (lta?.size() > 0){
            l.addAll(lta)
        }
        return l?.sort{it.sequenza}
    }

}
