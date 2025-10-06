package it.finmatica.de4gsdzk.certificazione.generazione.anpr

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.AnprRichiestaCertificatoResult
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.CertificatoGenerato
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoService
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.ETipoFile
import org.springframework.stereotype.Service

@Slf4j
@Service
class AnprGenerazioneCertificatoService implements IGenerazioneCertificatoService {
    private StatoCivileService statoCivileService

    AnprGenerazioneCertificatoService(StatoCivileService statoCivileService) {
        this.statoCivileService = statoCivileService
    }

    @Override
    void validateGenerazioneCertificato(CerCertificatoEmesso certificato) {
        // Sempre valido
    }

    @Override
    void generateCertificato(IGenerazioneCertificatoParams p) {
        try {
            AnprGenerazioneCertificatoParams anprParams = (AnprGenerazioneCertificatoParams) p
            Boolean flagForzatura = anprParams.flagForzatura ?: Boolean.FALSE
            AnprRichiestaCertificatoResult anpr = statoCivileService.anprRichiestaCertificato(anprParams.certificato.idEmissione, flagForzatura)
            if (anpr.error) {
                throw new De4gsdzkRuntimeException(anpr.error)
            }

            p.onSuccess.call(new CertificatoGenerato(ETipoGenerazioneCertificato.ANPR, anpr.blob, ETipoFile.PDF.estensione))
        } catch (Exception e) {
            log.error("Errore durante la generazione del certificato ANPR", e)
            p.onFailure.call(new AnprGenerazioneCertificatoRuntimeException(e))
        }
    }
}
