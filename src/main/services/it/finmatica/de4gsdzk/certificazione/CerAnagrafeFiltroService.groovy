package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltroRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerAnagrafeFiltroService {

    private final CerAnagrafeFiltroRepository cerAnagrafeFiltroRepository
    private final AnaAnagrafeService anaAnagrafeService

    CerAnagrafeFiltroService(CerAnagrafeFiltroRepository cerAnagrafeFiltroRepository, AnaAnagrafeService anaAnagrafeService) {
        this.cerAnagrafeFiltroRepository = cerAnagrafeFiltroRepository
        this.anaAnagrafeService = anaAnagrafeService
    }

    List<CerAnagrafeFiltro> listAllByAnagrafe(GsdAnagrafeBaseDomain anagrafe) {
        if (anagrafe.matricola != null) {
            return cerAnagrafeFiltroRepository.findAllByMatricola(anagrafe.matricola)
        }

        return cerAnagrafeFiltroRepository.findAllByCognomeAndNomeAndSessoAndDataNascita(anagrafe.cognome, anagrafe.nome, anagrafe.sesso, anagrafe.dataNascita)
    }

}
