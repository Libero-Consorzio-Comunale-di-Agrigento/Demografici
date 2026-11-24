package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleElettoreListaGeneraleService {

    EleElettoreListaGeneraleOrdinariaRepository eleElettoreListaGeneraleOrdinariaRepository
    EleElettoreListaGeneraleAggiuntaRepository eleElettoreListaGeneraleAggiuntaRepository

    EleElettoreListaGeneraleService(EleElettoreListaGeneraleOrdinariaRepository eleElettoreListaGeneraleRepository, EleElettoreListaGeneraleAggiuntaRepository eleElettoreListaGeneraleAggiuntaRepository) {
        this.eleElettoreListaGeneraleOrdinariaRepository = eleElettoreListaGeneraleRepository
        this.eleElettoreListaGeneraleAggiuntaRepository = eleElettoreListaGeneraleAggiuntaRepository
    }

    List<EleElettoreListaBaseDomain> findAllOrderByProgressivo(Long progressivoDa, Long progressivoA, EleTipoLista tipoLista) {
        return EleTipoListaService.ID_LISTA_ORDINARIA.equals(tipoLista.id) ? findAllOrderByProgressivoListaOrdinaria(progressivoDa, progressivoA) : findAllOrderByProgressivoListaAggiunta(progressivoDa, progressivoA, tipoLista)
    }

    List<EleElettoreListaBaseDomain> findAllOrderByProgressivoListaOrdinaria(Long progressivoDa, Long progressivoA) {
        if(progressivoDa && progressivoA) {
            return eleElettoreListaGeneraleOrdinariaRepository.findAllByProgressivoOrderByProgressivo(progressivoDa, progressivoA)
        } else {
            return eleElettoreListaGeneraleOrdinariaRepository.findAllOrderByProgressivo()
        }
    }

    List<EleElettoreListaBaseDomain> findAllOrderByProgressivoListaAggiunta(Long progressivoDa, Long progressivoA, EleTipoLista tipoLista) {
        if(progressivoDa && progressivoA) {
            return eleElettoreListaGeneraleAggiuntaRepository.findAllByProgressivoOrderByProgressivo(progressivoDa, progressivoA, tipoLista)
        } else {
            return eleElettoreListaGeneraleAggiuntaRepository.findAllOrderByProgressivo(tipoLista)
        }
    }
}
