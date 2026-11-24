package it.finmatica.de4gsdzk.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnscEndPointServizioAllegatoService {

    private final GsdService gsdService

    private final AnscEndPointServizioAllegatoRepository anscEndPointServizioAllegatoRepository

    AnscEndPointServizioAllegatoService(GsdService gsdService, AnscEndPointServizioAllegatoRepository anscEndPointServizioAllegatoRepository) {
        this.gsdService = gsdService
        this.anscEndPointServizioAllegatoRepository = anscEndPointServizioAllegatoRepository
    }

    AnscEndPointServizioAllegato get (Long id){
        return anscEndPointServizioAllegatoRepository.findById(id)
    }

    List<AnscEndPointServizioAllegato> listAllByServizioAndCasoUsoOrderBySequenza(AnscEndPointServizio servizio, Long idCasoUso, Integer tipoAtto, String tipoDocumentoCdu) {
        if (servizio && idCasoUso && tipoAtto) {
            List<AnscEndPointServizioAllegato> lAlle = anscEndPointServizioAllegatoRepository.findAllByServizioAndCasoUsoOrderBySequenza(servizio, idCasoUso, tipoAtto, tipoDocumentoCdu)
            return lAlle
        }
        return []
    }

    Page<AnscEndPointServizioAllegato> findAllByArchivioAndCasoUso(Long idCasoUso, Pageable pageable){
        return anscEndPointServizioAllegatoRepository.findAllByCasoUso(idCasoUso, pageable)
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
            obj.id = gsdService.getIdFromSequence(obj)
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
