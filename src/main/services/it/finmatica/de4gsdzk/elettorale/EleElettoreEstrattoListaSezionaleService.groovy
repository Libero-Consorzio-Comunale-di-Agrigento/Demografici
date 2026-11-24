package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.EStatoElettore
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleElettoreEstrattoListaSezionaleService {


    EleElettoreEstrattoListaSezionaleOrdinariaRepository eleElettoreEstrattoListaSezionaleOrdinariaRepository
    EleElettoreEstrattoListaSezionaleAggiuntaRepository eleElettoreEstrattoListaSezionaleAggiuntaRepository

    EleElettoreEstrattoListaSezionaleService(EleElettoreEstrattoListaSezionaleOrdinariaRepository eleElettoreEstrattoListaSezionaleOrdinariaRepository,
                                             EleElettoreEstrattoListaSezionaleAggiuntaRepository eleElettoreEstrattoListaSezionaleAggiuntaRepository) {
        this.eleElettoreEstrattoListaSezionaleOrdinariaRepository = eleElettoreEstrattoListaSezionaleOrdinariaRepository
        this.eleElettoreEstrattoListaSezionaleAggiuntaRepository = eleElettoreEstrattoListaSezionaleAggiuntaRepository
    }


    List<EleElettoreListaSezionaleBaseDomain> findAllByParams(Integer sezione, Long progressivoDa, Long progressivoA,
                                                             EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, EleTipoLista tipoLista, Boolean flagAmministrative, Sort ordinamento) {
        if(tipoLista.id == EleTipoListaService.ID_LISTA_ORDINARIA) {
            findAllByParamsOrdinaria(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, isSoloElettoriAttivi, flagAmministrative, ordinamento)
        } else {
            findAllByParamsAggiunta(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, isSoloElettoriAttivi, tipoLista, flagAmministrative, ordinamento)
        }

    }

    List<EleElettoreListaSezionaleBaseDomain> findAllByParamsOrdinaria(Integer sezione, Long progressivoDa, Long progressivoA,
                                                              EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, Boolean flagAmministrative, Sort ordinamento) {
        if(isSoloElettoriAttivi) {
            // Quando isSoloElettoriAttivi=true, include solo elettori con tutti i flag a false
            return eleElettoreEstrattoListaSezionaleOrdinariaRepository.findAllElettoriAttiviByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, flagAmministrative, ordinamento)
        } else {
            // Quando isSoloElettoriAttivi=false, non filtrare sui flag (passa null)
            return eleElettoreEstrattoListaSezionaleOrdinariaRepository.findAllByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, ordinamento)
        }
    }

    List<EleElettoreListaSezionaleBaseDomain> findAllByParamsAggiunta(Integer sezione, Long progressivoDa, Long progressivoA,
                                                                       EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, EleTipoLista tipoLista, Boolean flagAmministrative, Sort ordinamento) {
        if(isSoloElettoriAttivi) {
            // Quando isSoloElettoriAttivi=true, include solo elettori con tutti i flag a false
            return eleElettoreEstrattoListaSezionaleAggiuntaRepository.findAllElettoriAttiviByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, tipoLista, flagAmministrative, ordinamento)
        } else {
            // Quando isSoloElettoriAttivi=false, non filtrare sui flag (passa null)
            return eleElettoreEstrattoListaSezionaleAggiuntaRepository.findAllByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, tipoLista, ordinamento)
        }
    }

    int countElettoriByParams(Integer sezione, Long progressivoDa, Long progressivoA,
                              EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, EleTipoLista tipoLista, Boolean flagAmministrative){
        if(tipoLista.id == EleTipoListaService.ID_LISTA_ORDINARIA) {
            countByParamsOrdinaria(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, isSoloElettoriAttivi, flagAmministrative)
        } else {
            countByParamsAggiunta(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, isSoloElettoriAttivi, tipoLista, flagAmministrative)
        }
    }

    int countByParamsOrdinaria(Integer sezione, Long progressivoDa, Long progressivoA,
                                                                       EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, Boolean flagAmministrative) {
        if(isSoloElettoriAttivi) {
            // Quando isSoloElettoriAttivi=true, include solo elettori con tutti i flag a false
            return eleElettoreEstrattoListaSezionaleOrdinariaRepository.countElettoriAttiviByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, flagAmministrative)
        } else {
            // Quando isSoloElettoriAttivi=false, non filtrare sui flag (passa null)
            return eleElettoreEstrattoListaSezionaleOrdinariaRepository.countByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA)
        }
    }

    int countByParamsAggiunta(Integer sezione, Long progressivoDa, Long progressivoA,
                                                                      EStatoElettore stato, String cognomeDa, String cognomeA, Boolean isSoloElettoriAttivi, EleTipoLista tipoLista, Boolean flagAmministrative) {
        if(isSoloElettoriAttivi) {
            // Quando isSoloElettoriAttivi=true, include solo elettori con tutti i flag a false
            return eleElettoreEstrattoListaSezionaleAggiuntaRepository.countElettoriAttiviByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, tipoLista, flagAmministrative)
        } else {
            // Quando isSoloElettoriAttivi=false, non filtrare sui flag (passa null)
            return eleElettoreEstrattoListaSezionaleAggiuntaRepository.countByParams(sezione, progressivoDa, progressivoA, stato, cognomeDa, cognomeA, tipoLista)
        }
    }
}
