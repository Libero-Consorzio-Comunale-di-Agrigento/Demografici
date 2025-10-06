package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioAllegatoRepository
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscEndPointServizioAllegatoService {

    private final StatoCivileService statoCivileService

    private final AnscEndPointServizioAllegatoRepository anscEndPointServizioAllegatoRepository

    AnscEndPointServizioAllegatoService(StatoCivileService statoCivileService, AnscEndPointServizioAllegatoRepository anscEndPointServizioAllegatoRepository) {
        this.statoCivileService = statoCivileService
        this.anscEndPointServizioAllegatoRepository = anscEndPointServizioAllegatoRepository
    }

    List<AnscEndPointServizioAllegato> listAllByServizioAndCasoUsoOrderBySequenza(AnscEndPointServizio servizio, Long idCasoUso, Integer tipoAtto, String tipoDocumentoCdu) {
        if (servizio && idCasoUso && tipoAtto) {
            List<AnscEndPointServizioAllegato> lAlle = anscEndPointServizioAllegatoRepository.findAllByServizioAndCasoUsoOrderBySequenza(servizio, idCasoUso, tipoAtto, tipoDocumentoCdu)
            return lAlle
        }
        return []
    }

    private void validaDati(AnscEndPointServizioAllegato obj){
        if ( (obj.servizio == null) || (obj.tipoDocumentoFascicolo == null) ) {
            throw new CampoMandatoryRuntimeException()
        }
    }

    AnscEndPointServizioAllegato save (AnscEndPointServizioAllegato obj) {
        validaDati(obj)

        if (obj.id == null) {
            // solo in caso di inserimento
            obj.id = statoCivileService.getIdFromSequence(obj)
        }
        log.info("Lancio salvataggio su ANSTWS_DDO per id " + obj.id)
        return anscEndPointServizioAllegatoRepository.save(obj)
    }

    void delete(AnscEndPointServizioAllegato obj){
        if (obj.id != null) {
            anscEndPointServizioAllegatoRepository.delete(obj)
        }
    }

}
