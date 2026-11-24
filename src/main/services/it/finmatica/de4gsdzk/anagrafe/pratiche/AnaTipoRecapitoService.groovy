package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaTipoRecapitoService {

    private final AnaTipoRecapitoRepository anaTipoRecapitoRepository

    AnaTipoRecapitoService(AnaTipoRecapitoRepository anaTipoRecapitoRepository) {
        this.anaTipoRecapitoRepository = anaTipoRecapitoRepository
    }

    List<AnaTipoRecapito> findAll(){
        return anaTipoRecapitoRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }
}
