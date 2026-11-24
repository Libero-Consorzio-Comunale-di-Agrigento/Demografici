package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anpr.AnpAnagrafe
import it.finmatica.de4gsdzk.anpr.AnpOperazione
import it.finmatica.de4gsdzk.errors.NoRecordFoundRuntimeException
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnpOperazioneService {

    private final AnpOperazioneRepository anpOperazioneRepository

    private final GsdService gsdService

    AnpOperazioneService(AnpOperazioneRepository anpOperazioneRepository, GsdService gsdService) {
        this.anpOperazioneRepository = anpOperazioneRepository
        this.gsdService = gsdService
    }

    Page<AnpOperazione> listAllByAnpAnagrafe(AnpAnagrafe anpAnagrafe, PageRequest pr) {
        if (anpAnagrafe == null) {
            return new PageImpl<AnpOperazione>([])
        }

        Long op = gsdService.ricercaOperazioniANPR(anpAnagrafe.codiceFiscale, anpAnagrafe.idSoggettoAnpr)
        if (op != null) {
            if (op.compareTo(0L) > 0) {
                return anpOperazioneRepository.findAllByIdOperazione(op, pr)
            } else {
                throw new NoRecordFoundRuntimeException(Etichette.getEtichetta("Errore_Ricerca_ANPR_No_Result"))
            }
        } else {
            return null
        }
    }
}
