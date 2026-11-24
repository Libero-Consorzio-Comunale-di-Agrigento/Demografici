package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleComunicazioneWsService {

    private final EleComunicazioneWsRepository eleComunicazioneWsRepository

    EleComunicazioneWsService(EleComunicazioneWsRepository eleComunicazioneWsRepository) {
        this.eleComunicazioneWsRepository = eleComunicazioneWsRepository
    }

    Page<EleComunicazioneWs> listAllByElezioneAndElezioneAdsAndFiltroLike(EleElezione elezione, De4Elezione elezioneAds, String filtro, PageRequest p) {
        if (elezione == null) {
            return new PageImpl([])
        }
        return eleComunicazioneWsRepository.findAllByElezioneAndElezioneAdsAndFiltroLike(elezione, elezioneAds, SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleComunicazioneWs get(Long id) {
        return eleComunicazioneWsRepository.findOne(id)
    }

    EleComunicazioneWs save(EleComunicazioneWs obj) {
        return eleComunicazioneWsRepository.save(obj)
    }

    void delete(EleComunicazioneWs obj) {
        eleComunicazioneWsRepository.delete(obj)
    }
}
