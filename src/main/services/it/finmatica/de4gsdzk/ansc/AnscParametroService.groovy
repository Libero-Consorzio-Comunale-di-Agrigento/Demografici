package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscParametroRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscParametroService {

    private final AnscParametroRepository anscParametroRepository

    AnscParametroService(AnscParametroRepository anscParametroRepository) {
        this.anscParametroRepository = anscParametroRepository
    }

    AnscParametro get (String id){
        return anscParametroRepository.findById(id)
    }

    Page<AnscParametro> listAllByFlagVisibileTrueAndIdLike(String parametroLike, PageRequest p){
        return anscParametroRepository.findAllByFlagVisibileTrueAndIdLike(parametroLike, p)
    }

    List<AnscParametro> listAllWhereIdIn (List<String> ids){
        return anscParametroRepository.findAllByIdIn(ids)
    }

    AnscParametro save(AnscParametro obj) {
        return anscParametroRepository.save(obj)
    }

    void delete(AnscParametro obj){
        if (obj.id != null) {
            anscParametroRepository.delete(obj)
        }
    }
}
