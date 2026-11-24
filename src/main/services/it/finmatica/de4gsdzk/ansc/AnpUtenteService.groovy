package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnpUtenteService {

    private final AnpUtenteRepository anpUtenteRepository

    AnpUtenteService(AnpUtenteRepository anpUtenteRepository) {
        this.anpUtenteRepository = anpUtenteRepository
    }

    AnpUtente get(String id) {
        return anpUtenteRepository.findById(id)
    }

    Page<AnpUtente> listAllByFiltroLike(String filtro, PageRequest pageRequest) {
        if ((filtro?.trim() ?: "") != "") {
            return anpUtenteRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), pageRequest)
        } else {
            return anpUtenteRepository.findAllByFiltroLike("%", pageRequest)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnpUtente obj) {
        if (TestoUtils.isVuoto(obj.id)) {
            throw new CampoMandatoryRuntimeException()
        }

        if (TestoUtils.isVuoto(obj.cognome) || TestoUtils.isVuoto(obj.nome) || TestoUtils.isVuoto(obj.codiceFiscale)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }

        if (tipoOperazione.isInsert()) {
            AnpUtente esistente = anpUtenteRepository.findById(obj.id)
            if (esistente != null) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnpUtente save(ETipoOperazione tipoOperazione, AnpUtente obj) {
        validaDati(tipoOperazione, obj)

        return anpUtenteRepository.save(obj)
    }

    void delete(AnpUtente obj) {
        anpUtenteRepository.delete(obj)
    }

}