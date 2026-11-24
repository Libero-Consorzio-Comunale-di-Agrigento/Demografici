package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnscService
import it.finmatica.de4gsdzk.certificazione.CerStatoCivileFiltro
import it.finmatica.de4gsdzk.utils.EMotivoRecupero
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CivMorteCertificazioneService implements IAttoAnscService {

    private final CivMorteCertificazioneRepository civMorteCertificazioneRepository

    CivMorteCertificazioneService(CivMorteCertificazioneRepository civMorteCertificazioneRepository) {
        this.civMorteCertificazioneRepository = civMorteCertificazioneRepository
    }


    CivAttoBaseDomain findById(Long id) {
        return civMorteCertificazioneRepository.findById(id)
    }

    List<CivMorteCertificazione> listAllByStatoCivileFiltroList(List<CerStatoCivileFiltro> statoCivileFiltroList) {
        List<Long> ids = statoCivileFiltroList.collect { it.id }
        return civMorteCertificazioneRepository.findAllByIdIn(ids)
    }

    @Override
    CivAttoBaseDomain getByIdAttoAnsc(String idAttoAnsc) {
        return null
    }

    @Override
    void updateIdAnscUseCase(Long id, Long idAnscUseCase) {

    }

    @Override
    void updateMotivoRecuperoAnsc(Long id, EMotivoRecupero motivoRecuperoAnsc) {

    }

    @Override
    void updateIdAttoAnsc(Long id, String idAttoAnsc) {

    }

    @Override
    EMotivoRecupero getMotivoRecuperoAnsc(Long id) {
        return null
    }

    Boolean isInviatoAnsc(Long id) {
        String idAttoAnsc = civMorteCertificazioneRepository.findIdAttoAnsc(id)
        return (!(TestoUtils.isVuoto(idAttoAnsc)))
    }

    @Override
    Boolean isFirmatoUscAnsc(Long id) {
        return null
    }

    @Override
    Boolean isFirmatoCartaceoAnsc(Long id) {
        return null
    }

    @Override
    Boolean hasAllegatiInviatiAnsc(Long id) {
        return null
    }

    @Override
    Boolean isConformeAnsc(Long id) {
        return null
    }

    @Override
    Boolean existsIdAttoAnsc(String idAttoAnsc) {
        return null
    }

    @Override
    Integer getCodiceRecord(Long id) {
        return null
    }

    @Override
    Boolean getBloccato(Long id) {
        return null
    }

    @Override
    CivAttoBaseDomain get(Long id, Map params) {
        return null
    }

    @Override
    CivAttoBaseDomain getByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
        return null
    }

    @Override
    Boolean existsByUkAtto(Integer ufficio, Integer anno, Integer atto, Integer parte, String serie) {
        return null
    }
}
