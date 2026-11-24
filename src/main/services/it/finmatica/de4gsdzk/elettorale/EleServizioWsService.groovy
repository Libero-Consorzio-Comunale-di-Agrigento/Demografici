package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleServizioWsService {

    private final EleServizioWsRepository eleServizioWsRepository

    EleServizioWsService(EleServizioWsRepository eleServizioWsRepository) {
        this.eleServizioWsRepository = eleServizioWsRepository
    }

    Page<EleServizioWs> listAllByFiltroLike(String filtro, PageRequest p) {
        return eleServizioWsRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleServizioWs get(Long id) {
        return eleServizioWsRepository.findOne(id)
    }

    EleServizioWs save(EleServizioWs obj) {
        return eleServizioWsRepository.save(obj)
    }

    void delete(EleServizioWs obj) {
        eleServizioWsRepository.delete(obj)
    }
}