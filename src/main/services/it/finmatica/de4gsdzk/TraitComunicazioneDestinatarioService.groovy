package it.finmatica.de4gsdzk

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.ErroreDatiComunicazioneRuntimeException
import it.finmatica.de4gsdzk.utils.EStatoProtocollazione
import it.finmatica.de4gsdzk.utils.Etichette

@Slf4j
trait TraitComunicazioneDestinatarioService {

    abstract IComunicazioneDestinatarioRepository getComunicazioneDestinatarioRepository()

    abstract IArchivioComunicazioneService getArchivioComunicazioneService()

    abstract GsdService getGsdService()

    IComunicazioneDestinatario get (Long id){
        return comunicazioneDestinatarioRepository.findById(id)
    }

    List<IComunicazioneDestinatario> listAllByArchivioComunicazione(Long idArcCom){
        return comunicazioneDestinatarioRepository.findAllByArchivioComunicazione(idArcCom)
    }

    private void validaDati(IComunicazioneDestinatario obj) {

        archivioComunicazioneService.bloccaSeProtocollata(obj.archivioComunicazione)

        archivioComunicazioneService.bloccaSeInviataAlbo(obj.archivioComunicazione)

    }

    IComunicazioneDestinatario save(IComunicazioneDestinatario obj){
        validaDati(obj)

        if (obj.id == null){
            // solo in caso di inserimento
            obj.id = gsdService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su ---COM_DEST per id " + obj.id)
        return  comunicazioneDestinatarioRepository.save(obj)
    }

    void delete(IComunicazioneDestinatario obj){
        validaDati(obj)

        log.info("Tento cancellazione su ---COM_DEST per id " + obj.id)
        comunicazioneDestinatarioRepository.delete(obj)
    }

    String inviaPec(IComunicazioneDestinatario obj){
        EStatoProtocollazione sp = archivioComunicazioneService.getStatoProtocollazione(obj.archivioComunicazione.id)
        if ( (sp == null) || (sp != EStatoProtocollazione.P) ) {
            throw new ErroreDatiComunicazioneRuntimeException(Etichette.getEtichetta("Errore_invio_pec_comunicazione_non_protocollata"))
        }

        String retVal = gsdService.inviaPecComunicazione(obj.archivioComunicazione.id, obj.id)
        return retVal
    }

}