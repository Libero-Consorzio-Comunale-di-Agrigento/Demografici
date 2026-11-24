package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleSezioneArchivioWsService {

    private final EleSezioneArchivioWsRepository eleSezioneArchivioWsRepository

    EleSezioneArchivioWsService(EleSezioneArchivioWsRepository eleSezioneArchivioWsRepository) {
        this.eleSezioneArchivioWsRepository = eleSezioneArchivioWsRepository
    }

    Page<EleSezioneArchivioWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleSezioneArchivioWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleSezioneArchivioWs get(Long id) {
        return eleSezioneArchivioWsRepository.findOne(id)
    }

    EleSezioneArchivioWs save(EleSezioneArchivioWs obj) {
        return eleSezioneArchivioWsRepository.save(obj)
    }

    void delete(EleSezioneArchivioWs obj) {
        eleSezioneArchivioWsRepository.delete(obj)
    }
}
