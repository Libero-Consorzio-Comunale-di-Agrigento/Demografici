package it.finmatica.de4gsdzk.anagrafe.pratiche

import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaDichiarazioneVariazioneResService implements IDichiarazioneVariazioneService, IDichiarazioneResService{

    private final AnaDichiarazioneVariazioneResRepository anaDichiarazioneVariazioneResRepository

    AnaDichiarazioneVariazioneResService(AnaDichiarazioneVariazioneResRepository anaDichiarazioneVariazioneResRepository) {
        this.anaDichiarazioneVariazioneResRepository = anaDichiarazioneVariazioneResRepository
    }

    AnaDichiarazioneVariazioneRes findByPratica(AnaPratica pratica) {
        return anaDichiarazioneVariazioneResRepository.findByPratica(pratica)
    }

    void saveOrUpdate(AnaDichiarazioneVariazioneRes anaDichiarazioneVariazioneRes) {
        anaDichiarazioneVariazioneResRepository.save(anaDichiarazioneVariazioneRes)

    }

}
