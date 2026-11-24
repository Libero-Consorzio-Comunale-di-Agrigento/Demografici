package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.anpr.AnpElettorale
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpElettoraleService {

    private final AnpElettoraleRepository anpElettoraleRepository

    AnpElettoraleService(AnpElettoraleRepository anpElettoraleRepository) {
        this.anpElettoraleRepository = anpElettoraleRepository
    }

    Page<AnpElettorale> findAllByIdOperazione(Long idOperazione, PageRequest pr) {
        if (idOperazione == null) {
            return new PageImpl<AnpElettorale>([])
        }
        return anpElettoraleRepository.findAllByIdOperazione(idOperazione, pr)
    }
}
