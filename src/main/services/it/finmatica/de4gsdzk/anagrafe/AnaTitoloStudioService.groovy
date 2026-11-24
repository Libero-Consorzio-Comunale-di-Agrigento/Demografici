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
class AnaTitoloStudioService {

    private final AnaTitoloStudioRepository anaTitoloStudioRepository

    private final UtenteCustomService utenteCustomService

    AnaTitoloStudioService(AnaTitoloStudioRepository anaTitoloStudioRepository,
                           UtenteCustomService utenteCustomService) {
        this.anaTitoloStudioRepository = anaTitoloStudioRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaTitoloStudio> findAll(){
        return anaTitoloStudioRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaTitoloStudio get(String codice) {
        return anaTitoloStudioRepository.findByCodice(codice)
    }

    Page<AnaTitoloStudio> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaTitoloStudioRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaTitoloStudioRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaTitoloStudio obj) {
        if ( (obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione) ){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anaTitoloStudioRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaTitoloStudio save(ETipoOperazione tipoOperazione, AnaTitoloStudio obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaTitoloStudioRepository.save(obj)
    }


    void delete(AnaTitoloStudio obj) {
        anaTitoloStudioRepository.delete(obj)
    }

}
