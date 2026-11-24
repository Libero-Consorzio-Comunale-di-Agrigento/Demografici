package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Transactional
@Service
class AnaUrnaCinerariaService {

    private final AnaUrnaCinerariaRepository anaUrnaCinerariaRepository
    private final GsdService gsdService
    private final UtenteCustomService utenteCustomService

    AnaUrnaCinerariaService(AnaUrnaCinerariaRepository anaUrnaCinerariaRepository,
                            GsdService gsdService,
                            UtenteCustomService utenteCustomService) {
        this.anaUrnaCinerariaRepository = anaUrnaCinerariaRepository
        this.gsdService = gsdService
        this.utenteCustomService = utenteCustomService
    }

    AnaUrnaCineraria get(Long id) {
        return anaUrnaCinerariaRepository.findById(id)
    }

    List<AnaUrnaCineraria> findByAnagrafe(AnaAnagrafe anagrafe) {
        return anaUrnaCinerariaRepository.findByMatricola(anagrafe)
    }

    void save(AnaUrnaCineraria urna) {
        if (urna.id == null) {
            urna.id = gsdService.getIdFromSequence(urna, urna.getTableName())
        }
        urna.terminalista = utenteCustomService.getLoggedUser()
        anaUrnaCinerariaRepository.save(urna)
    }

    void delete(AnaUrnaCineraria urna) {
        anaUrnaCinerariaRepository.delete(urna)
    }
}