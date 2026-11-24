package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.ETipoComunicazioneAnagrafe
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnaComunicazioneService {

    private final AnaComunicazioneRepository anaComunicazioneRepository
    private final UtenteCustomService utenteCustomService

    AnaComunicazioneService(AnaComunicazioneRepository anaComunicazioneRepository,
                            UtenteCustomService utenteCustomService) {
        this.anaComunicazioneRepository = anaComunicazioneRepository
        this.utenteCustomService = utenteCustomService
    }

    AnaComunicazione get(Integer id) {
        return anaComunicazioneRepository.findById(id)
    }

    Page<AnaComunicazione> listAllByTipoComunicazioneAndFiltroLike(ETipoComunicazioneAnagrafe tipoComunicazione, String filtro, Pageable pageable) {
        if ((filtro?.trim() ?: "") != "") {
            return anaComunicazioneRepository.findAllByTipoComunicazioneAndFiltroLike(tipoComunicazione, SqlUtils.beginsAndEndsLike(filtro), pageable)
        } else {
            return anaComunicazioneRepository.findAllByTipoComunicazioneAndFiltroLike(tipoComunicazione, "%", pageable)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaComunicazione obj) {
        // Campi obbligatori
        if ((obj.tipoComunicazione == null) || (obj.id == null) || (obj.modello == null) || ((obj?.descrizione?.trim() ?: "") == "")) {
            throw new CampoMandatoryRuntimeException()
        }

        // Duplicati in INSERT
        if (tipoOperazione.isInsert()) {
            long n = anaComunicazioneRepository.countById(obj.id)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaComunicazione save(ETipoOperazione tipoOperazione, AnaComunicazione obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        log.info("Salvataggio AnaComunicazione per id ${obj.id}")
        return anaComunicazioneRepository.save(obj)
    }

    void delete(AnaComunicazione obj) {
        log.info("Eliminazione AnaComunicazione per id ${obj.id}")
        anaComunicazioneRepository.delete(obj)
    }

}