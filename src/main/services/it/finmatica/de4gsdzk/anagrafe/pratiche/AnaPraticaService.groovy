package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaPraticaService {

    private final AnaPraticaRepository anaPraticaRepository
    private final CerTerminalistaService cerTerminalistaService

    AnaPraticaService(AnaPraticaRepository anaPraticaRepository, CerTerminalistaService cerTerminalistaService) {
        this.anaPraticaRepository = anaPraticaRepository
        this.cerTerminalistaService = cerTerminalistaService
    }

    AnaPratica findById(Long id) {
        return anaPraticaRepository.findById(id)
    }

    AnaPratica findAvanzamentiById(Long id) {
        return anaPraticaRepository.findAvanzamentiById(id)
    }

    AnaPratica saveOrUpdate(AnaPratica pratica) {
        pratica.terminalista = cerTerminalistaService.getTerminalistaUtente()
        return anaPraticaRepository.save(pratica)
    }

    void saveAvanzamenti(AnaPratica pratica) {
        for (AnaAvanzamentoPratica a : pratica.avanzamentiPratica) {
            a.terminalista = cerTerminalistaService.getTerminalistaUtente()
        }

        anaPraticaRepository.save(pratica)
    }
}
