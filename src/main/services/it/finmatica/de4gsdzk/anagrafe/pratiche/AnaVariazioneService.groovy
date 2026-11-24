package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoPratica
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaVariazioneService {

    private final String WEB = 'W'
    private final String ANPR = 'Y'

    private final AnaVariazioneRepository anaVariazioneRepository

    AnaVariazioneService(AnaVariazioneRepository anaVariazioneRepository) {
        this.anaVariazioneRepository = anaVariazioneRepository
    }

    List<AnaVariazione> findVariazioniValide(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica) {
        return anaVariazioneRepository.findByAnagrafeAndTipoPraticaAndFlagTprTrueAndDescrizioneTprIsNotNullOrderBySequenzaEventoTprAscDescrizioneTprAsc(tipoArchivioAnagrafe, tipoPratica)
    }

    AnaVariazione getVariazioneWebAnpr(ETipoAnagrafe tipoArchivioAnagrafe, ETipoPratica tipoPratica, String archivio) {
        return anaVariazioneRepository.findByAnagrafeAndTipoPraticaAndCodiceVariazioneTprAndFlagTprTrue(tipoArchivioAnagrafe, tipoPratica, archivio.equalsIgnoreCase('WEB') ? WEB : ANPR)
    }

    AnaVariazione findByFlagReimmigrazioneAireIsTrue() {
        return anaVariazioneRepository.findByFlagReimmigrazioneAireIsTrue()
    }
}
