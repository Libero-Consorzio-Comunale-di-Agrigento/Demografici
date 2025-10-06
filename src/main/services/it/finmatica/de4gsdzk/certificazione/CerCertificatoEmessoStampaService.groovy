package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmessoRepository
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CerCertificatoEmessoStampaService {

    private final CerCertificatoEmessoRepository cerCertificatoEmessoRepository
    private final CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService

    CerCertificatoEmessoStampaService(CerCertificatoEmessoRepository cerCertificatoEmessoRepository,
                                      CerFondoCassaTerminalistaService cerFondoCassaTerminalistaService) {
        this.cerCertificatoEmessoRepository = cerCertificatoEmessoRepository
        this.cerFondoCassaTerminalistaService = cerFondoCassaTerminalistaService
    }

    Page<CerCertificatoEmesso> listAllByRicercaCertificatoStampa(RicercaCertificatoStampa r, PageRequest p) {
        if (r.dataEmissioneDal == null || r.dataEmissioneAl == null) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_estrazione_certificati)
        }
        return cerCertificatoEmessoRepository.findAllByRicercaCertificatoStampa(r, p)
    }

    DirittiReport getDirittiByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        if (r.dataEmissioneDal == null || r.dataEmissioneAl == null) {
            throw new IllegalStateException("Data di emissione non valorizzata")
        }
        return cerCertificatoEmessoRepository.findDirittiByRicercaCertificatoStampa(r)
    }

    DirittiRiepilogoReport getDirittiRiepilogoByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        if (!r.riepilogo.stampaRiepilogo) {
            return null
        }
        return cerCertificatoEmessoRepository.findDirittiRiepilogoByRicercaCertificatoStampa(r)
    }

    List<DirittiTipoPagamentoReport> getDirittiTipoPagamentoByRicercaCertificatoStampa(RicercaCertificatoStampa r) {
        if (r.dataEmissioneDal == null || r.dataEmissioneAl == null) {
            throw new IllegalStateException("Data di emissione non valorizzata")
        }
        return cerCertificatoEmessoRepository.findAllDirittiTipoPagamentoByRicercaCertificatoStampa(r)
    }

    FondoCassaReport getFondoCassaByRicercaCertificatoStampaAndDiritti(RicercaCertificatoStampa r, DirittiReport diritti) {
        if (r.dataEmissioneDal == null || r.dataEmissioneDal != r.dataEmissioneAl || r.terminalista == null) {
            throw new IllegalStateException("Fondo Cassa non attivo")
        }
        if(!r.terminalista.flagFondoCassa){
            return null
        }
        CerFondoCassaTerminalista fct = cerFondoCassaTerminalistaService.findByTerminalistaAndData(r.terminalista, r.dataEmissioneDal)
        if(fct == null){
            return null
        }
        BigDecimal fondoCassaIniziale = fct.fondoCassa
        BigDecimal fondoCassaFinale = fondoCassaIniziale + diritti.totale
        return new FondoCassaReport(fondoCassaIniziale, fondoCassaFinale)
    }

}
