package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaCondizioneSqlService {

    private final AnaCondizioneSqlRepository anaCondizioneSqlRepository

    AnaCondizioneSqlService(AnaCondizioneSqlRepository anaCondizioneSqlRepository) {

        this.anaCondizioneSqlRepository = anaCondizioneSqlRepository

    }

    List<AnaCondizioneSql> findAllByTipoComunicazione(ETipoComunicazioneAnagrafe tipoComunicazione) {
        return anaCondizioneSqlRepository.findAllByTipoComunicazione(tipoComunicazione)
    }

    List<AnaCondizioneSql> findAllByTipoComunicazioneAndIdNotIn(ETipoComunicazioneAnagrafe tipoComunicazione, List<Integer> codiciPresenti) {
        return anaCondizioneSqlRepository.findAllByTipoComunicazioneAndIdNotIn(tipoComunicazione,codiciPresenti)
    }
}
