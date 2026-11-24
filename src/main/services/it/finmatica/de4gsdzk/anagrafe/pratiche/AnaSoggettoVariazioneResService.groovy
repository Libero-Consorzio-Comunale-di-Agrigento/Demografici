package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaSoggettoVariazioneResService implements ISoggettoService {

    private final AnaSoggettoVariazioneResRepository anaSoggettoVariazioneResRepository
    private final GsdService gsdService

    AnaSoggettoVariazioneResService(AnaSoggettoVariazioneResRepository anaSoggettoVariazioneResRepository, GsdService gsdService) {
        this.anaSoggettoVariazioneResRepository = anaSoggettoVariazioneResRepository
        this.gsdService = gsdService
    }

    void saveOrUpdate(AnaSoggettoVariazioneRes soggetto){
        if(soggetto.id == null) {
            soggetto.id = gsdService.getIntegerIdFromSequence(soggetto, soggetto.getTableName())
        }
        anaSoggettoVariazioneResRepository.save(soggetto)
    }

    void delete(AnaSoggettoVariazioneRes soggetto){
        anaSoggettoVariazioneResRepository.delete(soggetto)
    }

}
