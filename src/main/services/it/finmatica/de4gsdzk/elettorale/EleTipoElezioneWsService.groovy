package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class EleTipoElezioneWsService {

    private final EleTipoElezioneWsRepository eleTipoElezioneWsRepository

    EleTipoElezioneWsService(EleTipoElezioneWsRepository eleTipoElezioneWsRepository) {
        this.eleTipoElezioneWsRepository = eleTipoElezioneWsRepository
    }

    Page<EleTipoElezioneWs> listAllByFiltroLike(String filtro, PageRequest p) {
        return eleTipoElezioneWsRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro ?: "%"), p)
    }

    EleTipoElezioneWs get(Long id) {
        return eleTipoElezioneWsRepository.findOne(id)
    }

    EleTipoElezioneWs save(EleTipoElezioneWs obj) {
        return eleTipoElezioneWsRepository.save(obj)
    }

    void delete(EleTipoElezioneWs obj) {
        eleTipoElezioneWsRepository.delete(obj)
    }
}
