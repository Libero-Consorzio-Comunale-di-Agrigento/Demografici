package it.finmatica.de4gsdzk.anagrafe.pratiche


import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaDichiarazioneRettificaService  {

    private final AnaDichiarazioneRettificaRepository anaDichiarazioneRettificaRepository

    AnaDichiarazioneRettificaService(AnaDichiarazioneRettificaRepository anaDichiarazioneRettificaRepository) {
        this.anaDichiarazioneRettificaRepository = anaDichiarazioneRettificaRepository
    }

    AnaDichiarazioneRettifica findByPratica(AnaPratica pratica) {
        return anaDichiarazioneRettificaRepository.findByPratica(pratica)
    }

    void saveOrUpdate(AnaDichiarazioneRettifica anaDichiarazioneRettifica) {
        anaDichiarazioneRettificaRepository.save(anaDichiarazioneRettifica)
    }
}
