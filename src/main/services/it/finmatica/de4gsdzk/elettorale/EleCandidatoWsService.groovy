package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleCandidatoWsService {

    private final EleCandidatoWsRepository eleCandidatoWsRepository

    EleCandidatoWsService(EleCandidatoWsRepository eleCandidatoWsRepository) {
        this.eleCandidatoWsRepository = eleCandidatoWsRepository
    }

    Page<EleCandidatoWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleCandidatoWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleCandidatoWs get(Long id) {
        return eleCandidatoWsRepository.findOne(id)
    }

    EleCandidatoWs save(EleCandidatoWs obj) {
        return eleCandidatoWsRepository.save(obj)
    }

    void delete(EleCandidatoWs obj) {
        eleCandidatoWsRepository.delete(obj)
    }
}
