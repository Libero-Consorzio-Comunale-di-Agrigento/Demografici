package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaEventoPraticaService {

    private final AnaEventoPraticaRepository anaEventoPraticaRepository

    AnaEventoPraticaService(AnaEventoPraticaRepository anaEventoPraticaRepository) {
        this.anaEventoPraticaRepository = anaEventoPraticaRepository
    }

    List<AnaEventoPratica> findStatiValidi(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica) {
        return anaEventoPraticaRepository.findStatiValidi(tipoArchivioAnagrafe, tipoPratica)
    }

    List<AnaEventoPratica> findEventiValidi(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica) {
        return anaEventoPraticaRepository.findEventiValidi(tipoArchivioAnagrafe , tipoPratica)
    }

    AnaEventoPratica findNextEvento(AnaEventoPratica evento, EEsito esito, ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica) {
        if(esito == EEsito.P) {
            return anaEventoPraticaRepository.findNextEventoPositivo(evento.codEp, tipoArchivioAnagrafe , tipoPratica)
        } else if (esito == EEsito.N) {
            return anaEventoPraticaRepository.findNextEventoNegativo(evento.codEp,tipoArchivioAnagrafe , tipoPratica)
        }

    }

    AnaEventoPratica getAvanzamentoAnnullamento(){
        return anaEventoPraticaRepository.findByFlagAnnullamentoIsTrue()
    }

    AnaEventoPratica getAvanzamentoPerfezionamento(){
        return anaEventoPraticaRepository.findByFlagPerfezionamentoIsTrue()
    }

    List<AnaEventoPratica> findAllByArchivioAnagrafeAndTipoPratica(ETipoAnagrafe archivioAnagrafe, ETipoPratica tipoPratica) {
        return anaEventoPraticaRepository.findAllByArchivioAnagrafeAndTipoPraticaAndFlagFalse(archivioAnagrafe, tipoPratica)
    }


}
