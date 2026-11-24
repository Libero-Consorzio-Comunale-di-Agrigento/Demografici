package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.AnpCodiceTitoloStudio
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpCodiceTitoloStudioService {

    private final AnpCodiceTitoloStudioRepository anpCodiceTitoloStudioRepository

    AnpCodiceTitoloStudioService(AnpCodiceTitoloStudioRepository anpCodiceTitoloStudioRepository) {
        this.anpCodiceTitoloStudioRepository = anpCodiceTitoloStudioRepository
    }

    List<AnpCodiceTitoloStudio> listAll() {
        return anpCodiceTitoloStudioRepository.findAll().sort()
    }

}