package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort

@Slf4j
trait TraitEnteService {
    
    abstract IEnteRepository getEnteRepository()

    IEnte get (Integer id){
        return enteRepository.findById(id)
    }

    List<IEnte> listAll(Sort s) {
        return enteRepository.findAll(s)
    }

    List<IEnte> listAll() {
        return enteRepository.findAll()
    }

    List<IEnte> listAllByTipoEnteDestinatario(ETipoEnteDestinatario tipoEnteDestinatario) {
        return enteRepository.findAllByTipoEnteDestinatario(tipoEnteDestinatario, new Sort(SortUtils.descrizioneAsc))
    }

    Page<IEnte> listAllByDescrizioneOrPecLike (String filtro, PageRequest p) {
        if ( (filtro?.trim()?:"") != "") {
            return enteRepository.findAllByDescrizioneLikeIgnoreCaseOrPecLikeIgnoreCase(filtro, filtro, p)
        } else {
            return enteRepository.findAll(p)
        }
    }

    List<IEnte> listAllByTipoEnteDestinatarioAndIdNotIn(ETipoEnteDestinatario tipoEnteDestinatario, List<Integer> listaId) {
        return enteRepository.findAllByTipoEnteDestinatarioAndIdNotInOrderByDescrizione(tipoEnteDestinatario, listaId)
    }

    private void validaDati(ETipoOperazione tipoOperazione, IEnte obj) {
        ValidationUtils.validaDatiObbligatori(obj)

        if (tipoOperazione.isInsert()){
            long n = enteRepository.countById(obj.id)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Ente_Duplicato"))
            }
        }
    }

    IEnte save (ETipoOperazione tipoOperazione, IEnte obj) {

        validaDati(tipoOperazione, obj)

        log.info("Lancio salvataggio su ---DEN_V per id " + obj.id)
        return enteRepository.save(obj)
    }
}