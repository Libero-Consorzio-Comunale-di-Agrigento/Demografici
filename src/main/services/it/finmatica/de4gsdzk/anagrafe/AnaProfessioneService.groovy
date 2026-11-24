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
class AnaProfessioneService {

    private final AnaProfessioneRepository anaProfessioneRepository

    private final UtenteCustomService utenteCustomService

    AnaProfessioneService(AnaProfessioneRepository anaProfessioneRepository,
                          UtenteCustomService utenteCustomService) {
        this.anaProfessioneRepository = anaProfessioneRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaProfessione> findAll() {
        return anaProfessioneRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    List<AnaProfessione> findAllBySesso(ESesso sesso) {
        return anaProfessioneRepository.findAllBySessoOrderByDescrizioneAsc(sesso)
    }

    AnaProfessione get(String id) {
        return anaProfessioneRepository.findById(id)
    }

    Page<AnaProfessione> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaProfessioneRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaProfessioneRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaProfessione obj) {
        if ( (obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione) || obj?.sesso == null){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anaProfessioneRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaProfessione save(ETipoOperazione tipoOperazione, AnaProfessione obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        if(tipoOperazione.isInsert()) {
            obj.id = "${obj.sesso.id}${obj.codice.toString().padRight(5, '0')}"
        }
        return anaProfessioneRepository.save(obj)
    }


    void delete(AnaProfessione obj) {
        anaProfessioneRepository.delete(obj)
    }

}
