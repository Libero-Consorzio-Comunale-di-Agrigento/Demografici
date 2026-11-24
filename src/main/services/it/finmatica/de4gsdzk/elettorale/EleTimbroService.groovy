package it.finmatica.de4gsdzk.elettorale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.ETipoLista
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class EleTimbroService {

    EleTimbroRepository eleTimbroRepository

    private final GsdService gsdService

    private final UtenteCustomService utenteCustomService

    EleTimbroService(EleTimbroRepository eleTimbroRepository, GsdService gsdService, UtenteCustomService utenteCustomService) {
        this.eleTimbroRepository = eleTimbroRepository
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    List<EleTimbro> findAllByTipoListaAndTipoAndProgressivo(ETipoLista tipoLista, Integer tipo, Integer progressivo) {
        return eleTimbroRepository.findAllByTipoListaAndTipoAndProgressivo(tipoLista, tipo, progressivo)
    }

    EleTimbro findByTipoListaAndTipoAndProgressivo(ETipoLista tipoLista, Integer tipo, Integer progressivo) {
        return eleTimbroRepository.findByTipoListaAndTipoAndProgressivo(tipoLista, tipo, progressivo)
    }

    List<EleTimbro> findAllByTipoListaAndTipoAndFlagDefaultEstrattoIsTrue(ETipoLista tipoLista, Integer tipo) {
        return eleTimbroRepository.findAllByTipoListaAndTipoAndFlagDefaultEstrattoIsTrue(tipoLista, tipo)
    }

    EleTimbro get(Long id) {
        return eleTimbroRepository.findById(id)
    }

    Page<EleTimbro> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return eleTimbroRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return eleTimbroRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(EleTimbro obj){
        if ( (obj.tipo == null) || (obj.tipoLista == null) || (obj.progressivo == null) ||
                (obj.descrizione == null) || (obj.testo == null)) {
            throw new CampoMandatoryRuntimeException()
        }
    }

    EleTimbro save(EleTimbro obj) {
        validaDati(obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return eleTimbroRepository.save(obj)
    }

    void delete(EleTimbro obj) {
        eleTimbroRepository.delete(obj)
    }
}
