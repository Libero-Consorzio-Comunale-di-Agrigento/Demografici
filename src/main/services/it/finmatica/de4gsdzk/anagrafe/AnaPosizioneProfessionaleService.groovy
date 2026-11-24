package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaPosizioneProfessionaleService {

    private final AnaPosizioneProfessionaleRepository anaPosizioneProfessionaleRepository
    private final UtenteCustomService utenteCustomService

    AnaPosizioneProfessionaleService(AnaPosizioneProfessionaleRepository anaPosizioneProfessionaleRepository,
                                     UtenteCustomService utenteCustomService) {
        this.anaPosizioneProfessionaleRepository = anaPosizioneProfessionaleRepository
        this.utenteCustomService = utenteCustomService
    }

    AnaPosizioneProfessionale get(Integer codice) {
        return anaPosizioneProfessionaleRepository.findByCodice(codice)
    }

    List<AnaPosizioneProfessionale> findAll() {
        return anaPosizioneProfessionaleRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    Page<AnaPosizioneProfessionale> listAllByFiltroLike(String filtro, PageRequest pr) {
        String filtroLike = "%" + (filtro ?: "") + "%"
        return anaPosizioneProfessionaleRepository.findAllByFiltroLike(filtroLike, pr)
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaPosizioneProfessionale obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }
        if (tipoOperazione.isInsert()) {
            long n = anaPosizioneProfessionaleRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaPosizioneProfessionale save(ETipoOperazione tipoOperazione, AnaPosizioneProfessionale obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaPosizioneProfessionaleRepository.save(obj)
    }

    void delete(AnaPosizioneProfessionale obj) {
        anaPosizioneProfessionaleRepository.delete(obj)
    }
}
