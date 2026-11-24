package it.finmatica.de4gsdzk.anagrafe.pratiche

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaTipoConvivnezaService {

    private final AnaTipoConvivenzaRepository anaTipoConvivenzaRepository

    AnaTipoConvivnezaService(AnaTipoConvivenzaRepository anaTipoConvivenzaRepository) {
        this.anaTipoConvivenzaRepository = anaTipoConvivenzaRepository
    }

    List<AnaTipoConvivenza> findAll(){
        return anaTipoConvivenzaRepository.findAll()
    }
}
