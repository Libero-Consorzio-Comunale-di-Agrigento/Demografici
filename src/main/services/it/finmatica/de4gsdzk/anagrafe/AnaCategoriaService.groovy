package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SqlUtils
import it.finmatica.de4gsdzk.utils.SortUtils
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaCategoriaService {

    private final AnaCategoriaRepository anaCategoriaRepository

    private final UtenteCustomService utenteCustomService

    AnaCategoriaService(AnaCategoriaRepository anaCategoriaRepository,
                        UtenteCustomService utenteCustomService) {
        this.anaCategoriaRepository = anaCategoriaRepository
        this.utenteCustomService = utenteCustomService
    }

    List<AnaCategoria> findAll(){
        return anaCategoriaRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnaCategoria get(Integer codice) {
        return anaCategoriaRepository.findByCodice(codice)
    }

    Page<AnaCategoria> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anaCategoriaRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anaCategoriaRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaCategoria obj) {
        if ( (obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione) ){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anaCategoriaRepository.countByCodice(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    AnaCategoria save(ETipoOperazione tipoOperazione, AnaCategoria obj) {
        validaDati(tipoOperazione, obj)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaCategoriaRepository.save(obj)
    }

    void delete(AnaCategoria obj) {
        anaCategoriaRepository.delete(obj)
    }

    List<AnaCategoria> findAllByTipoDocumento(AnaTipoDocumento tipoDocumento){
        return anaCategoriaRepository.findAllByTipoDocumentoOrderByDescrizioneAsc(tipoDocumento)
    }
}
