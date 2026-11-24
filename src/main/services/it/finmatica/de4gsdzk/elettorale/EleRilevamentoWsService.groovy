package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleRilevamentoWsService {

    private final EleRilevamentoWsRepository eleRilevamentoWsRepository

    EleRilevamentoWsService(EleRilevamentoWsRepository eleRilevamentoWsRepository) {
        this.eleRilevamentoWsRepository = eleRilevamentoWsRepository
    }

    Page<EleRilevamentoWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleRilevamentoWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione,elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleRilevamentoWs get(Long id) {
        return eleRilevamentoWsRepository.findOne(id)
    }

    EleRilevamentoWs save(EleRilevamentoWs obj) {
        return eleRilevamentoWsRepository.save(obj)
    }

    void delete(EleRilevamentoWs obj) {
        eleRilevamentoWsRepository.delete(obj)
    }
}
