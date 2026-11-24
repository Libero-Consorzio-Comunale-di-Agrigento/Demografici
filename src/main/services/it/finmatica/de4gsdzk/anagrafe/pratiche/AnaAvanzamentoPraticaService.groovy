package it.finmatica.de4gsdzk.anagrafe.pratiche


import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaAvanzamentoPraticaService {

    private final AnaAvanzamentoPraticaRepository anaAvanzamentoPraticaRepository

    AnaAvanzamentoPraticaService(AnaAvanzamentoPraticaRepository anaAvanzamentoPraticaRepository) {
        this.anaAvanzamentoPraticaRepository = anaAvanzamentoPraticaRepository
    }

    AnaAvanzamentoPratica findById(Integer id){
        return anaAvanzamentoPraticaRepository.findById(id)
    }

    void save(AnaAvanzamentoPratica avanzamento) {
        anaAvanzamentoPraticaRepository.save(avanzamento)
    }

}
