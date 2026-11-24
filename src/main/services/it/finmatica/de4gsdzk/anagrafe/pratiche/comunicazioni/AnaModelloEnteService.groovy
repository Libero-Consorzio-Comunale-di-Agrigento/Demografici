package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaModelloEnteService {

    private final AnaModelloEnteRepository anaModelloEnteRepository

    private final GsdService gsdService

    AnaModelloEnteService(AnaModelloEnteRepository anaModelloEnteRepository,
                          GsdService gsdService) {
        this.anaModelloEnteRepository = anaModelloEnteRepository
        this.gsdService = gsdService
    }

    List<AnaModelloEnte> findAll() {
        return anaModelloEnteRepository.findAll(new Sort(SortUtils.idAsc))
    }

    AnaModelloEnte get(Long id) {
        return anaModelloEnteRepository.findById(id)
    }

    Page<AnaModelloEnte> listAllByTipoModelloAndFiltroLike(ETipoModello tipoModello, String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaModelloEnteRepository.findAllByTipoModelloAndFiltroLike(tipoModello, SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaModelloEnteRepository.findAllByTipoModelloAndFiltroLike(tipoModello, "%", p)
        }
    }

    List<AnaModelloEnte> findAllByTipoModello(ETipoModello tipoModello) {
        return anaModelloEnteRepository.findAllByTipoModello(tipoModello)
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaModelloEnte obj) {
        // Campi obbligatori
        if (obj.modello == null || obj.ente == null || obj.sequenza == null || (obj.tipoModello == null)) {
            throw new CampoMandatoryRuntimeException()
        }

        // Duplicati in INSERT
        if (tipoOperazione.isInsert()) {
            long n = anaModelloEnteRepository.countByModelloAndEnte(obj.modello, obj.ente)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaModelloEnte save(ETipoOperazione tipoOperazione, AnaModelloEnte obj) {
        validaDati(tipoOperazione, obj)

        if(tipoOperazione == ETipoOperazione.INS) {
            obj.id = gsdService.getIdFromSequence(obj, obj.getTableName())
        }
        return anaModelloEnteRepository.save(obj)
    }

    void delete(AnaModelloEnte obj) {
        anaModelloEnteRepository.delete(obj)
    }
}