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
class AnaAttivitaService {

    private final AnaAttivitaRepository anaAttivitaRepository
    private final UtenteCustomService utenteCustomService

    AnaAttivitaService(AnaAttivitaRepository anaAttivitaRepository,
                       UtenteCustomService utenteCustomService) {
        this.anaAttivitaRepository = anaAttivitaRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaAttivita> findAll() {
        return anaAttivitaRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaAttivita get(Integer codice) {
        return anaAttivitaRepository.findByCodice(codice)
    }

    Page<AnaAttivita> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaAttivitaRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaAttivitaRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaAttivita obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = anaAttivitaRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaAttivita save(ETipoOperazione tipoOperazione, AnaAttivita obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaAttivitaRepository.save(obj)
    }

    void delete(AnaAttivita obj) {
        anaAttivitaRepository.delete(obj)
    }
}
