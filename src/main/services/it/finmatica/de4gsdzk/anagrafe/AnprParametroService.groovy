package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnprParametroService {

    private final AnprParametroRepository anprParametroRepository

    AnprParametroService(AnprParametroRepository anprParametroRepository) {
        this.anprParametroRepository = anprParametroRepository
    }

    List<AnprParametro> findAll() {
        return anprParametroRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    AnprParametro get(String parametro) {
        return anprParametroRepository.findByParametro(parametro)
    }

    Page<AnprParametro> listAllByFiltroLike(String filtro, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            return anprParametroRepository.findAllByFiltroLike(SqlUtils.beginsAndEndsLike(filtro), p)
        } else {
            return anprParametroRepository.findAllByFiltroLike("%", p)
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnprParametro obj) {
        if ( (obj.parametro == null) || TestoUtils.isVuoto(obj?.descrizione) ){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anprParametroRepository.countByParametro(obj.parametro)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            } else {
                obj.flagVisibile = true
            }
        }
    }

    AnprParametro save(ETipoOperazione tipoOperazione, AnprParametro obj) {
        validaDati(tipoOperazione, obj)
        return anprParametroRepository.save(obj)
    }

    void delete(AnprParametro obj) {
        anprParametroRepository.delete(obj)
    }

}
