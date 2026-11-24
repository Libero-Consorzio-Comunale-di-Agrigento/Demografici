package it.finmatica.de4gsdzk.anagrafe

import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpCodiceProfessioneService {

    private final AnpCodiceProfessioneRepository anpCodiceProfessioneRepository

    AnpCodiceProfessioneService(AnpCodiceProfessioneRepository anpCodiceProfessioneRepository) {
        this.anpCodiceProfessioneRepository = anpCodiceProfessioneRepository
    }

    List<AnpCodiceProfessione> listAll() {
        Sort s = new Sort(Sort.Direction.ASC, "codice")
        return anpCodiceProfessioneRepository.findAll(s)
    }

}
