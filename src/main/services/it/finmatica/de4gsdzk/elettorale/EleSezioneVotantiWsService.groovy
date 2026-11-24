package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleSezioneVotantiWsService {

    private final EleSezioneVotantiWsRepository eleSezioneVotantiWsRepository

    EleSezioneVotantiWsService(EleSezioneVotantiWsRepository eleSezioneVotantiWsRepository) {
        this.eleSezioneVotantiWsRepository = eleSezioneVotantiWsRepository
    }

    Page<EleSezioneVotantiWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleSezioneVotantiWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleSezioneVotantiWs get(Long id) {
        return eleSezioneVotantiWsRepository.findOne(id)
    }

    EleSezioneVotantiWs save(EleSezioneVotantiWs obj) {
        return eleSezioneVotantiWsRepository.save(obj)
    }

    void delete(EleSezioneVotantiWs obj) {
        eleSezioneVotantiWsRepository.delete(obj)
    }
}
