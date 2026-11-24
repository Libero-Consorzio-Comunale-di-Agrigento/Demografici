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
class AnaMotivoProvvedimentoService {

    private final AnaMotivoProvvedimentoRepository anaMotivoProvvedimentoRepository

    private final UtenteCustomService utenteCustomService

    AnaMotivoProvvedimentoService(AnaMotivoProvvedimentoRepository anaMotivoProvvedimentoRepository,
                                  UtenteCustomService utenteCustomService) {
        this.anaMotivoProvvedimentoRepository = anaMotivoProvvedimentoRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaMotivoProvvedimento> findAll() {
        return anaMotivoProvvedimentoRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    List<AnaMotivoProvvedimento> findAllByTipoDivorzioNotNull() {
        return anaMotivoProvvedimentoRepository.findAllByTipoDivorzioNotNull()
    }

    AnaMotivoProvvedimento get(Integer codice) {
        return anaMotivoProvvedimentoRepository.findByCodice(codice)
    }

    Page<AnaMotivoProvvedimento> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaMotivoProvvedimentoRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaMotivoProvvedimentoRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaMotivoProvvedimento obj) {
        if ((obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()) {
            long n = anaMotivoProvvedimentoRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaMotivoProvvedimento save(ETipoOperazione tipoOperazione, AnaMotivoProvvedimento obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaMotivoProvvedimentoRepository.save(obj)
    }

    void delete(AnaMotivoProvvedimento obj) {
        anaMotivoProvvedimentoRepository.delete(obj)
    }
}