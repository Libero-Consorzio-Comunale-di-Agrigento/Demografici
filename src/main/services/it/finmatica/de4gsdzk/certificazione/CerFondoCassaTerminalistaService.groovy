package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerFondoCassaTerminalistaRepository
import it.finmatica.de4gsdzk.utils.DataUtils
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerFondoCassaTerminalistaService {

    private final CerFondoCassaTerminalistaRepository cerFondoCassaTerminalistaRepository

    CerFondoCassaTerminalistaService(CerFondoCassaTerminalistaRepository cerFondoCassaTerminalistaRepository) {
        this.cerFondoCassaTerminalistaRepository = cerFondoCassaTerminalistaRepository
    }

    CerFondoCassaTerminalista create(CerTerminalista terminalista) {
        CerFondoCassaTerminalista ctf = new CerFondoCassaTerminalista()
        CerFondoCassaTerminalistaCompositeId id = new CerFondoCassaTerminalistaCompositeId()
        id.terminalista = terminalista
        id.data = DataUtils.getDataCorrente()
        ctf.id = id
        ctf.fondoCassa = 0

        return ctf
    }

    CerFondoCassaTerminalista save(CerFondoCassaTerminalista cerFondoCassa) {
        cerFondoCassaTerminalistaRepository.save(cerFondoCassa)
    }

    CerFondoCassaTerminalista findByTerminalistaAndData(CerTerminalista terminalista, Date data) {
        return cerFondoCassaTerminalistaRepository.findByTerminalistaAndData(terminalista, data)
    }

    Boolean existsByTerminalistaAndData(CerTerminalista terminalista, Date data) {
        return cerFondoCassaTerminalistaRepository.existsByTerminalistaAndData(terminalista, data)
    }

    Boolean shouldAdjustFondoCassa(CerCertificatoEmesso certificato) {
        return certificato?.tipoPagamento?.isContanti()
    }

    @Deprecated
    void incrementFondoCassa(CerCertificatoEmesso certificato) {
        if (!shouldAdjustFondoCassa(certificato)) {
            return
        }
        CerFondoCassaTerminalista ctf = findByTerminalistaAndData(certificato.terminalista, certificato.dataEmissione)
        ctf.fondoCassa += certificato.totale
        save(ctf)
    }

    @Deprecated
    void decrementFondoCassa(CerCertificatoEmesso certificato) {
        if (!shouldAdjustFondoCassa(certificato)) {
            return
        }
        CerFondoCassaTerminalista ctf = findByTerminalistaAndData(certificato.terminalista, certificato.dataEmissione)
        ctf.fondoCassa -= certificato.totale
        if (ctf.fondoCassa < 0) {
            ctf.fondoCassa = 0
        }
        save(ctf)
    }

}
