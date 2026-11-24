package it.finmatica.de4gsdzk.certificazione.generazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsterno
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class TipoGenerazioneCertificatoService {

    private final ArcParametroService arcParametroService
    private final CivAttoService civAttoService

    TipoGenerazioneCertificatoService(ArcParametroService arcParametroService, CivAttoService civAttoService) {
        this.arcParametroService = arcParametroService
        this.civAttoService = civAttoService
    }

    ETipoGenerazioneCertificato get(Boolean forceGenerazioneGte, CerTipoCertificato tipoCertificato, CivAttoBaseDomain atto = null) {
        if (!forceGenerazioneGte &&
                tipoCertificato.isStatoCivile() &&
                tipoCertificato.isGenerazioneEsterna() &&
                tipoCertificato.tipoCertificatoEsterno instanceof AnscTipoCertificatoEsterno &&
                arcParametroService.isIntegrazioneAnscAttiva()) {
            if (atto == null) {
                return ETipoGenerazioneCertificato.ANSC
            }
            if (civAttoService.isInviatoAnsc(atto.getTipoAttoEnum(), atto.id, true)) {
                return ETipoGenerazioneCertificato.ANSC
            } else {
                return ETipoGenerazioneCertificato.GTE
            }
        } else if (!forceGenerazioneGte &&
                tipoCertificato.isAnagrafe() &&
                tipoCertificato.isGenerazioneEsterna() &&
                tipoCertificato.tipoCertificatoEsterno instanceof AnprTipoCertificatoEsterno) {
            return ETipoGenerazioneCertificato.ANPR
        } else {
            return ETipoGenerazioneCertificato.GTE
        }
    }

}
