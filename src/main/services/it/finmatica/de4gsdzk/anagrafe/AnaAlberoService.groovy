package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaAlberoService {

    private final AnaAlberoRepository anaAlberoRepository

    private final UtenteCustomService utenteCustomService

    AnaAlberoService(AnaAlberoRepository anaAlberoRepository,
                     UtenteCustomService utenteCustomService) {
        this.anaAlberoRepository = anaAlberoRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaAlbero> findAll() {
        return anaAlberoRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaAlbero get(Integer codice) {
        return anaAlberoRepository.findByCodice(codice)
    }

    Page<AnaAlbero> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaAlberoRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaAlberoRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaAlbero obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = anaAlberoRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaAlbero save(ETipoOperazione tipoOperazione, AnaAlbero obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaAlberoRepository.save(obj)
    }

    void delete(AnaAlbero obj) {
        anaAlberoRepository.delete(obj)
    }
}