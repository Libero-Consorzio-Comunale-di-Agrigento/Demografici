package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ETipoSiNo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaFamigliaService {

    private final AnaFamigliaRepository anaFamigliaRepository

    AnaFamigliaService(AnaFamigliaRepository anaFamigliaRepository) {

        this.anaFamigliaRepository = anaFamigliaRepository
    }

    AnaFamiglia get(String id, Map params) {
        return anaFamigliaRepository.getByParams(id, params)
    }

    AnaFamiglia findById(String id) {
        return anaFamigliaRepository.findById(id)
    }

    Page<AnaEventoFamiglia> findAllEventoFamigliaById(String id, Pageable pageable) {
        return anaFamigliaRepository.findAllEventoFamigliaById(id, pageable)
    }

    void saveOrUpdate(AnaFamiglia famiglia) {
        anaFamigliaRepository.save(famiglia)
    }
}
