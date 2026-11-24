package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.IEnteRepository
import it.finmatica.de4gsdzk.TraitEnteService
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
class AnaEnteService implements TraitEnteService {

    private final AnaEnteRepository anaEnteRepository

    private final UtenteCustomService utenteCustomService

    AnaEnteService(AnaEnteRepository anaEnteRepository,
                   UtenteCustomService utenteCustomService) {
        this.anaEnteRepository = anaEnteRepository
        this.utenteCustomService = utenteCustomService
    }

    @Override
    IEnteRepository getEnteRepository() {
        return anaEnteRepository
    }

    List<AnaEnte> findAll() {
        return anaEnteRepository.findAll(new Sort(SortUtils.descrizioneAsc))
    }

    List<AnaEnte> findAllByCodiceAnprNotNull() {
        return anaEnteRepository.findAllByCodiceAnprNotNull()
    }

    AnaEnte get(Integer codice) {
        return anaEnteRepository.findByCodice(codice)
    }

    Page<AnaEnte> listAllByFiltroLike(String filtro, Boolean siglaNull, PageRequest p) {
        if ((filtro?.trim() ?: "") != "") {
            if(siglaNull) {
                return anaEnteRepository.findAllByFiltroLikeAndSiglaNull(SqlUtils.beginsAndEndsLike(filtro), p)
            } else {
                return anaEnteRepository.findAllByFiltroLikeAndSiglaNotNull(SqlUtils.beginsAndEndsLike(filtro), p)
            }

        } else {
            if(siglaNull) {
                return anaEnteRepository.findAllByFiltroLikeAndSiglaNull("%", p)
            } else {
                return anaEnteRepository.findAllByFiltroLikeAndSiglaNotNull("%", p)
            }
        }
    }

    private void validaDati(ETipoOperazione tipoOperazione, AnaEnte obj, Boolean sezioneComunicazioni = Boolean.FALSE) {
        if ( (obj.codice == null) || TestoUtils.isVuoto(obj?.descrizione) || (sezioneComunicazioni && obj?.sigla == null)){
            throw new CampoMandatoryRuntimeException()
        }

        if (tipoOperazione.isInsert()){
            long n = anaEnteRepository.countById(obj.codice)
            if (n > 0) {
                throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_duplicato"))
            }
        }
    }

    List<AnaEnte> findAllByCdfIsFalse() {
        return anaEnteRepository.findAllByCdfIsFalse()
    }

    AnaEnte save(ETipoOperazione tipoOperazione, AnaEnte obj, Boolean sezioneComunicazioni = Boolean.FALSE) {
        validaDati(tipoOperazione, obj, sezioneComunicazioni)
        obj.terminalista = utenteCustomService.getLoggedUser()
        return anaEnteRepository.save(obj)
    }

    void delete(AnaEnte obj) {
        anaEnteRepository.delete(obj)
    }

}
