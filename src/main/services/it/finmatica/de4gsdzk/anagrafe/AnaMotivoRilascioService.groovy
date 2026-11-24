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
class AnaMotivoRilascioService {

    private final AnaMotivoRilascioRepository anaMotivoRilascioRepository
    private final UtenteCustomService utenteCustomService

    AnaMotivoRilascioService(AnaMotivoRilascioRepository anaMotivoRilascioRepository,
                             UtenteCustomService utenteCustomService) {
        this.anaMotivoRilascioRepository = anaMotivoRilascioRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaMotivoRilascio> findAll() {
        return anaMotivoRilascioRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaMotivoRilascio get(Integer codice) {
        return anaMotivoRilascioRepository.findByCodice(codice)
    }

    Page<AnaMotivoRilascio> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaMotivoRilascioRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaMotivoRilascioRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaMotivoRilascio obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = anaMotivoRilascioRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaMotivoRilascio save(ETipoOperazione tipoOperazione, AnaMotivoRilascio obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaMotivoRilascioRepository.save(obj)
    }

    void delete(AnaMotivoRilascio obj) {
        anaMotivoRilascioRepository.delete(obj)
    }
}
