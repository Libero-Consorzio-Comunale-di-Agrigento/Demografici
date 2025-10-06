package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.emissione.BeneficiarioViewState
import it.finmatica.de4gsdzk.certificazione.CerFiltroRepository
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerFiltroService {

    private final CerFiltroRepository cerFiltroRepository

    CerFiltroService(CerFiltroRepository cerFiltroRepository) {
        this.cerFiltroRepository = cerFiltroRepository
    }

    List<CerFiltro> listAllByTipoCompetenza(ETipoCompetenzaCertificazioneOnLine tipoCompetenza) {
        cerFiltroRepository.findAllByTipoCompetenzaOrderById(tipoCompetenza)
    }

}
