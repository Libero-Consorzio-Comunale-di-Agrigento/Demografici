package it.finmatica.de4gsdzk.anagrafe.pratiche


import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaRapportoParentelaService {

    private final AnaRapportoParentelaRepository anaRapportoParentelaRepository

    AnaRapportoParentelaService(AnaRapportoParentelaRepository anaRapportoParentelaRepository) {
        this.anaRapportoParentelaRepository = anaRapportoParentelaRepository
    }

    List<AnaRapportoParentela> findAllBySessoAndTipoFamiglia(ESesso sesso, ETipoFamiglia tipoFamiglia) {
        return anaRapportoParentelaRepository.findAllBySessoAndTipoFamigliaOrderByDescrizioneAsc(sesso, tipoFamiglia)
    }

    List<AnaRapportoParentela> findBySessoConCodiceIstat(ESesso sesso) {
        return anaRapportoParentelaRepository.findBySessoConCodiceIstat(sesso)
    }
}
