package it.finmatica.de4gsdzk.anagrafe

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaConvivenzaDiFattoService {

    private final AnaConvivenzaDiFattoRepository anaConvivenzaDiFattoRepository

    AnaConvivenzaDiFattoService(AnaConvivenzaDiFattoRepository anaConvivenzaDiFattoRepository) {
        this.anaConvivenzaDiFattoRepository = anaConvivenzaDiFattoRepository
    }

    AnaConvivenzaDiFatto get(Long id) {
        return anaConvivenzaDiFattoRepository.findById(id)
    }
}
