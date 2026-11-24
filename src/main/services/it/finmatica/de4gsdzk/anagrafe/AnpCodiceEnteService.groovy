package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpCodiceEnteService {

    private final AnpCodiceEnteRepository anpCodiceEnteRepository

    AnpCodiceEnteService(AnpCodiceEnteRepository anpCodiceEnteRepository) {
        this.anpCodiceEnteRepository = anpCodiceEnteRepository
    }

    List<AnpCodiceEnte> listAll() {
        Sort s = new Sort(Sort.Direction.ASC, "codice")
        return anpCodiceEnteRepository.findAll(s)
    }


}