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
class AnaCittadinanzaService {

    private final AnaCittadinanzaRepository anaCittadinanzaRepository

    private final UtenteCustomService utenteCustomService

    AnaCittadinanzaService(AnaCittadinanzaRepository anaCittadinanzaRepository,
                           UtenteCustomService utenteCustomService) {
        this.anaCittadinanzaRepository = anaCittadinanzaRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaCittadinanza> findAll() {
        return anaCittadinanzaRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    List<AnaCittadinanza> listAll() {
        return findAll()
    }

    AnaCittadinanza findByCodCi(String codCi) {
        return anaCittadinanzaRepository.findByCodCi(codCi)
    }

    AnaCittadinanza get(String codCi) {
        return findByCodCi(codCi)
    }

    Page<AnaCittadinanza> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaCittadinanzaRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaCittadinanzaRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaCittadinanza obj) {
        if ( (obj.codCi == null) || TestoUtils.isVuoto(obj?.descrizione) || obj?.istCi == null){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anaCittadinanzaRepository.countByCodCi(obj.codCi)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaCittadinanza save(ETipoOperazione tipoOperazione, AnaCittadinanza obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaCittadinanzaRepository.save(obj)
    }


    void delete(AnaCittadinanza obj) {
        anaCittadinanzaRepository.delete(obj)
    }

}