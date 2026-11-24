package it.finmatica.de4gsdzk.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaDettaglioProvvedimento
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaDettaglioProvvedimentoService {

    private final AnaDettaglioProvvedimentoRepository anaDettaglioProvvedimentoRepository

    AnaDettaglioProvvedimentoService(AnaDettaglioProvvedimentoRepository anaDettaglioProvvedimentoRepository) {
        this.anaDettaglioProvvedimentoRepository = anaDettaglioProvvedimentoRepository
    }

    AnaDettaglioProvvedimento findByPraticaAndSoggetto(AnaPratica pratica, AnaAnagrafe soggetto) {
        return anaDettaglioProvvedimentoRepository.findByPraticaAndSoggetto(pratica, soggetto)
    }

    AnaDettaglioProvvedimento findBySoggettoANPR(AnaAnagrafe soggetto) {
        return anaDettaglioProvvedimentoRepository.findBySoggettoANPR(soggetto)
    }

    void saveOrUpdate(AnaDettaglioProvvedimento provvedimento) {
       anaDettaglioProvvedimentoRepository.save(provvedimento)
    }
}
