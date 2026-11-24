package it.finmatica.de4gsdzk.anagrafe.pratiche


import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaDichiarazioneIscrizioneResService implements IDichiarazioneIscrizioneService, IDichiarazioneResService {

    private final AnaDichiarazioneIscrizioneResRepository anaDichiarazioneIscrizioneResRepository

    AnaDichiarazioneIscrizioneResService(AnaDichiarazioneIscrizioneResRepository anaDichiarazioneIscrizioneResRepository) {
        this.anaDichiarazioneIscrizioneResRepository = anaDichiarazioneIscrizioneResRepository
    }

    AnaDichiarazioneIscrizioneRes findByPratica(AnaPratica pratica) {
        return anaDichiarazioneIscrizioneResRepository.findByPratica(pratica)
    }

    void updateCodiceFamiglia(Integer id, Long codFamigliaProv) {
        anaDichiarazioneIscrizioneResRepository.updateCodiceFamiglia(id, codFamigliaProv)
    }

    void saveOrUpdate(AnaDichiarazioneIscrizioneRes anaDichiarazioneIscrizioneRes) {
        anaDichiarazioneIscrizioneResRepository.save(anaDichiarazioneIscrizioneRes)
    }
}
