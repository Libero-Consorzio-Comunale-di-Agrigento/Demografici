package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.ETipoLista
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleTipoListaService {

    static final String ID_LISTA_ORDINARIA = "O"

    EleTipoListaRepository eleTipoListaRepository

    EleTipoListaService(EleTipoListaRepository eleTipoListaRepository) {
        this.eleTipoListaRepository = eleTipoListaRepository
    }

    List<EleTipoLista> findAll() {
        return eleTipoListaRepository.findAll()
    }

    EleTipoLista findTipoListaDefault(){
        return eleTipoListaRepository.findById(ID_LISTA_ORDINARIA)
    }


}
