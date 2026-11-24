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
class AnaTipoProvvedimentoService {

    private final AnaTipoProvvedimentoRepository anaTipoProvvedimentoRepository

    private final UtenteCustomService utenteCustomService

    AnaTipoProvvedimentoService(AnaTipoProvvedimentoRepository anaTipoProvvedimentoRepository,
                                UtenteCustomService utenteCustomService) {
        this.anaTipoProvvedimentoRepository = anaTipoProvvedimentoRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaTipoProvvedimento> findAll() {
        return anaTipoProvvedimentoRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaTipoProvvedimento get(Integer codice) {
        return anaTipoProvvedimentoRepository.findByCodice(codice)
    }

    Page<AnaTipoProvvedimento> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaTipoProvvedimentoRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaTipoProvvedimentoRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaTipoProvvedimento obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = anaTipoProvvedimentoRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaTipoProvvedimento save(ETipoOperazione tipoOperazione, AnaTipoProvvedimento obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaTipoProvvedimentoRepository.save(obj)
    }

    void delete(AnaTipoProvvedimento obj) {
        anaTipoProvvedimentoRepository.delete(obj)
    }
}