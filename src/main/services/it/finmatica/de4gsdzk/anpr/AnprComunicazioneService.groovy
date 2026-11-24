package it.finmatica.de4gsdzk.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnprComunicazioneService {

    private final AnprComunicazioneRepository anprComunicazioneRepository
    private final AnprDatiAggiuntiviComunicazioneRepository anprDatiAggiuntiviComunicazioneRepository
    private final CerTerminalistaService cerTerminalistaService

    AnprComunicazioneService(AnprComunicazioneRepository anprComunicazioneRepository,
                             AnprDatiAggiuntiviComunicazioneRepository anprDatiAggiuntiviComunicazioneRepository,
                             CerTerminalistaService cerTerminalistaService) {
        this.anprComunicazioneRepository = anprComunicazioneRepository
        this.anprDatiAggiuntiviComunicazioneRepository = anprDatiAggiuntiviComunicazioneRepository
        this.cerTerminalistaService = cerTerminalistaService
    }

    List<AnprComunicazione> findAllByPraticaAndInviatoAndArchivioRif(Long idPratica, String filtroInviato, AnprTipoArchivio archivioRif) {
        return anprComunicazioneRepository.findAllByPraticaAndInviatoAndArchivioRif(idPratica, filtroInviato, archivioRif)
    }

    List<AnprComunicazione> findAllByPraticaOrMatricoleAndInviatoAndArchivioRif(Long idPratica, List<Integer> matricole, String filtroInviato, AnprTipoArchivio archivioRif) {
        if (matricole.size() == 0) {
            return anprComunicazioneRepository.findAllByPraticaAndInviatoAndArchivioRif(idPratica, filtroInviato, archivioRif)
        } else {
            return anprComunicazioneRepository.findAllByPraticaOrMatricoleAndInviatoAndArchivioRif(idPratica, matricole, filtroInviato, archivioRif)
        }
    }

    List<AnprComunicazione> findAllByMatricolaAndInviatoAndArchivioRif(Integer matricola, String filtroInviato, AnprTipoArchivio archivioRif) {
        return anprComunicazioneRepository.findAllByMatricolaAndInviatoAndArchivioRif(matricola, filtroInviato, archivioRif)
    }

    AnprComunicazione findById(Long id) {
        return anprComunicazioneRepository.findById(id)
    }

    void saveOrUpdate(AnprComunicazione comunicazione, Boolean forzatoFlag) {
        if (forzatoFlag) {
            if(comunicazione.inviato) {
                comunicazione.noteWS = "Forzato invio WS (${cerTerminalistaService.getTerminalistaUtente().id})"
            } else {
                comunicazione.noteWS = ""
            }
        }
        anprComunicazioneRepository.save(comunicazione)
    }

    void salvaModificheComunicazione(AnprComunicazione comunicazione) {
        anprDatiAggiuntiviComunicazioneRepository.save(comunicazione.datiAggiuntivi)
        anprComunicazioneRepository.save(comunicazione)
    }

}
