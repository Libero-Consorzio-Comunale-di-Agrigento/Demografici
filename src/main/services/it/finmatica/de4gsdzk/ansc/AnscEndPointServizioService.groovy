package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioRepository
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscEndPointServizioService {

    private final AnscEndPointServizioRepository anscEndPointServizioRepository

    AnscEndPointServizioService(AnscEndPointServizioRepository anscEndPointServizioRepository) {
        this.anscEndPointServizioRepository = anscEndPointServizioRepository
    }

    AnscEndPointServizio get (String id){
        return anscEndPointServizioRepository.findById(id)
    }

    Page<AnscEndPointServizio> listAllByServizioOrDescrizioneLike(String filtro, PageRequest p) {
        if ( (filtro?.trim()?:"") != "") {
            return anscEndPointServizioRepository.findAllByServizioLikeIgnoreCaseOrDescrizioneLikeIgnoreCase(filtro, filtro, p)
        } else {
            return anscEndPointServizioRepository.findAll(p)
        }
    }

    /*
    AnscEndPointServizio getServizioNotificaRicerca(){
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagNotificaRicercaIsTrue()
        if ( (ls?.size()?:0) == 1){
            return ls[0]
        }
        return null
    }

    AnscEndPointServizio getServizioNotificaConferma(){
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagNotificaConfermaIsTrue()
        if ( (ls?.size()?:0) == 1){
            return ls[0]
        }
        return null
    }

    AnscEndPointServizio getServizioConsultazioneEvento(){
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagConsultazioneEventoIsTrue()
        if ( (ls?.size()?:0) == 1){
            return ls[0]
        }
        return null
    }

    AnscEndPointServizio getServizioConsultazioneSoggetto(){
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagConsultazioneSoggettoIsTrueAndFlagDefaultIsTrue()
        if ( (ls?.size()?:0) == 1){
            return ls[0]
        }
        return null
    }
    */

    AnscEndPointServizio getServizioCertificatoSemplice(){
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagCertificatoSempliceIsTrue()
        if ( (ls?.size()?:0) == 1){
            return ls[0]
        }
        return null
    }

    AnscEndPointServizio getServizioCertificazioneGenerale() {
        List<AnscEndPointServizio> ls = anscEndPointServizioRepository.findAllByFlagCertificazioneIsTrueAndFlagDefaultIsTrue()
        if ((ls?.size() ?: 0) == 1) {
            return ls[0]
        }
        return null
    }

    private void validaDati(AnscEndPointServizio obj){
        if ( ((obj.servizio?:"") == "") || ((obj.descrizione?:"") == "") || ((obj.indirizzoURL?:"") == "") || ((obj.id?:"") == "")){
            throw new CampoMandatoryRuntimeException()
        }
    }

    AnscEndPointServizio save (AnscEndPointServizio obj){
        validaDati(obj)

        return anscEndPointServizioRepository.save(obj)
    }

    void delete(AnscEndPointServizio obj){
        if (obj.id != null) {
            anscEndPointServizioRepository.delete(obj)
        }
    }

}
