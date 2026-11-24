package it.finmatica.de4gsdzk.elettorale

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleVistoService {

    private final EleVistoRepository eleVistoRepository

    EleVistoService(EleVistoRepository eleVistoRepository) {
        this.eleVistoRepository = eleVistoRepository
    }

    EleVisto get() {
        List<EleVisto> records = eleVistoRepository.findAll()
        return records?.size() > 0 ? records.get(0) : null
    }

    EleVisto save(EleVisto obj) {
        return eleVistoRepository.save(obj)
    }
}
