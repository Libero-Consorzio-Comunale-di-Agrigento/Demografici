package it.finmatica.de4gsdzk.anagrafe.pratiche


import it.finmatica.de4gsdzk.anagrafe.ETipoFamiglia
import it.finmatica.de4gsdzk.utils.ESesso
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaRapportoParentelaIstatService {

    private final AnaRapportoParentelaIstatRepository anaRapportoParentelaIstatRepository

    AnaRapportoParentelaIstatService(AnaRapportoParentelaIstatRepository anaRapportoParentelaIstatRepository) {
        this.anaRapportoParentelaIstatRepository = anaRapportoParentelaIstatRepository
    }

    AnaRapportoParentelaIstat findBySessoAndCodiceRapportoParentela(ESesso sesso, String codRp) {
        return anaRapportoParentelaIstatRepository.findBySessoAndCodiceRapportoParentela(sesso, codRp)
    }
}
