package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreDatiAttoRuntimeException
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service

import javax.transaction.Transactional

@Slf4j
@Service
@Transactional
class CivRubricaNasciteService {

    CivRubricaNasciteRepository civRubricaNasciteRepository

    GsdService gsdService

    CivRubricaNasciteService(CivRubricaNasciteRepository civRubricaNasciteRepository, GsdService gsdService) {
        this.civRubricaNasciteRepository = civRubricaNasciteRepository
        this.gsdService = gsdService
    }

    CivRubricaNascite create(Map params) {
        CivRubricaNascite obj = new CivRubricaNascite(params)
        obj.attoNascita = new EstremiAtto()
        return obj
    }

    CivRubricaNascite get(Long id) {
        civRubricaNasciteRepository.findOne(id)
    }

    Page<CivRubricaNascite> search (RicercaRubricaNascite params, Pageable pr) {
        if ( (params.annoRegistrazioneDa != null) || (params.annoRegistrazioneA != null) || (params.dataRegistrazioneDa) || (params.dataRegistrazioneA) || (params.dataNascitaDa) || (params.dataNascitaA) ) {
            return listAll(params, pr)
        }
        throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori"))
    }

    Page<CivRubricaNascite> listAll(RicercaRubricaNascite params, Pageable pageable) {
        civRubricaNasciteRepository.findAll(
                (Integer) params?.annoRegistrazione,
                (Integer) params?.annoRegistrazioneDa,
                (Integer) params?.annoRegistrazioneA,
                (Integer) params?.codiceComuneAttoNascita,
                (Integer) params?.codiceProvinciaAttoNascita,
                (Integer) params?.ufficio, (Integer) params?.anno, (Integer) params?.atto,
                (Integer) params?.parte, (String) params?.serie?.toUpperCase(),
                (String) params?.idAttoAnsc,
                (ESesso) params?.sesso,
                (Date) params?.dataNascitaDa,
                (Date) params?.dataNascitaA,
                (Date) params?.dataRegistrazioneDa,
                (Date) params?.dataRegistrazioneA,
                SqlUtils.getFiltroLike(params?.cognome),
                SqlUtils.getFiltroLike(params?.nome), pageable)
    }

    void validaDati(CivRubricaNascite obj, boolean force) {
        if (DataUtils.isDataFutura(obj.dataNascita)){
            throw new ErroreDatiAttoRuntimeException(Etichette.getEtichetta("Errore_data_futura"))
        }

        ValidationUtils.validaDatiObbligatori(obj)

        DatiValidazioneEstremi dve = new DatiValidazioneEstremi(ETipoAtto.NAS,
                obj.attoNascita,
                false,
                false)
        DatiValidazioneComune dvc = new DatiValidazioneComune(obj.codiceComuneAttoNascita, obj.codiceProvinciaAttoNascita, true)

        ValidationUtils.validaEstremiAtto(dve, "Estremi Atto di Nascita")
        ValidationUtils.validaEstremiAttoComune(dvc, "Estremi Atto di Nascita")

        if ((!(force)) && civRubricaNasciteRepository.existsByUkAtto(obj.id, obj.attoNascita.anno, obj.attoNascita.atto, obj.attoNascita.parte, obj.attoNascita.serie, obj.attoNascita.ufficio, obj.attoNascita.idAttoAnsc, obj.codiceComuneAttoNascita, obj.codiceProvinciaAttoNascita)) {
            throw new RecordDuplicatoRuntimeException(Etichette.getEtichetta("Errore_Inserimento_Record_Rubrica_Duplicato"))
        }
    }

    CivRubricaNascite save(CivRubricaNascite obj, boolean force=false) {
        validaDati(obj, force)

        if (obj.id == null) {
            obj.id = gsdService.getIdFromSequence(obj)
        }

        return civRubricaNasciteRepository.save(obj)
    }

    void delete(CivRubricaNascite obj){
        log.info("Tento cancellazione su CIVRNA per id " + obj.id)
        if (obj.id != null) {
            civRubricaNasciteRepository.delete(obj)
        }
    }

}
