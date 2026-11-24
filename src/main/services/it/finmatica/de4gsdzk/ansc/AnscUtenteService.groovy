package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
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
class AnscUtenteService {

    private final UtenteCustomService utenteCustomService

    private final AnscUtenteRepository anscUtenteRepository

    AnscUtenteService(AnscUtenteRepository anscUtenteRepository, UtenteCustomService utenteCustomService) {
        this.anscUtenteRepository = anscUtenteRepository
        this.utenteCustomService = utenteCustomService
    }

    AnscUtente get (String id){
        return anscUtenteRepository.findById(id)
    }

    AnscUtente getAnscUtenteCorrente(){
        return get(utenteCustomService.loggedUserId)
    }

    Page<AnscUtente> listAllByFiltroLike(String filtro, PageRequest pageRequest) {
        if ((filtro?.trim() ?: "") != "") {
            return anscUtenteRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), pageRequest)
        } else {
            return anscUtenteRepository.findAllByFiltroLike("%", pageRequest)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnscUtente obj, boolean dizionario){
        if (TestoUtils.isVuoto(obj.id)){
            throw new CampoMandatoryRuntimeException()
        }

        if (dizionario && (TestoUtils.isVuoto(obj.cognome) || TestoUtils.isVuoto(obj.nome) || TestoUtils.isVuoto(obj.codiceFiscale))) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
        }

        if (tipoOperazione.isInsert()){
            AnscUtente esistente = anscUtenteRepository.findById(obj.id)
            if (esistente != null) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnscUtente save (ETipoOperazione tipoOperazione, AnscUtente obj, boolean dizionario){
        validaDati(tipoOperazione, obj, dizionario)

        return anscUtenteRepository.save(obj)
    }

    void delete(AnscUtente obj) {
        anscUtenteRepository.delete(obj)
    }

}
