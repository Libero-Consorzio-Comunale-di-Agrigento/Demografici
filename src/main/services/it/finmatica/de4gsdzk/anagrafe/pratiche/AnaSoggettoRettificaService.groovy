package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaSoggettoRettificaService implements ISoggettoService {

    private final AnaSoggettoRettificaRepository anaSoggettoRettificaRepository
    private final GsdService gsdService

    AnaSoggettoRettificaService(AnaSoggettoRettificaRepository anaSoggettoRettificaRepository, GsdService gsdService) {
        this.anaSoggettoRettificaRepository = anaSoggettoRettificaRepository
        this.gsdService = gsdService
    }

    void saveOrUpdate(AnaSoggettoRettifica soggetto){
        if(soggetto.id == null) {
            soggetto.id = gsdService.getIntegerIdFromSequence(soggetto, soggetto.getTableName())
        }
        anaSoggettoRettificaRepository.save(soggetto)
    }

    void delete(AnaSoggettoRettifica soggetto){
        anaSoggettoRettificaRepository.delete(soggetto)
    }

}
