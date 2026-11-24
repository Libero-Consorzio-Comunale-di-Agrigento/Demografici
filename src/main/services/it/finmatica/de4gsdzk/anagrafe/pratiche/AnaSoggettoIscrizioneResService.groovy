package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaSoggettoIscrizioneResService implements ISoggettoService {

    private final AnaSoggettoIscrizioneResRepository anaSoggettoIscrizioneResRepository
    private final GsdService gsdService

    AnaSoggettoIscrizioneResService(AnaSoggettoIscrizioneResRepository anaSoggettoIscrizioneResRepository, GsdService gsdService) {
        this.anaSoggettoIscrizioneResRepository = anaSoggettoIscrizioneResRepository
        this.gsdService = gsdService
    }

    void saveOrUpdate(AnaSoggettoIscrizioneRes soggetto){
        if(soggetto.id == null) {
            soggetto.id = gsdService.getIntegerIdFromSequence(soggetto, soggetto.getTableName())
        }
        anaSoggettoIscrizioneResRepository.save(soggetto)
    }

    void delete(AnaSoggettoIscrizioneRes soggetto){
        anaSoggettoIscrizioneResRepository.delete(soggetto)
    }

}
