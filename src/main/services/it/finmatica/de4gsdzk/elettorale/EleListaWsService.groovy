package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleListaWsService {

    private final EleListaWsRepository eleListaWsRepository

    EleListaWsService(EleListaWsRepository eleListaWsRepository) {
        this.eleListaWsRepository = eleListaWsRepository
    }

    Page<EleListaWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleListaWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleListaWs get(Long id) {
        return eleListaWsRepository.findOne(id)
    }

    EleListaWs save(EleListaWs obj) {
        return eleListaWsRepository.save(obj)
    }

    void delete(EleListaWs obj) {
        eleListaWsRepository.delete(obj)
    }
}
