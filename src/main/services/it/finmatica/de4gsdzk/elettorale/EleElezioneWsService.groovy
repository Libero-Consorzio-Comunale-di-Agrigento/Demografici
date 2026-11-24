package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleElezioneWsService {

    private final EleElezioneWsRepository eleElezioneWsRepository

    EleElezioneWsService(EleElezioneWsRepository eleElezioneWsRepository) {
        this.eleElezioneWsRepository = eleElezioneWsRepository
    }

    Page<EleElezioneWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleElezioneWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleElezioneWs get(Long id) {
        return eleElezioneWsRepository.findOne(id)
    }

    EleElezioneWs save(EleElezioneWs obj) {
        return eleElezioneWsRepository.save(obj)
    }

    void delete(EleElezioneWs obj) {
        eleElezioneWsRepository.delete(obj)
    }
}
