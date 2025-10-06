package it.finmatica.de4gsdzk.certificazione.generazione.gte

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.CertificatoGenerato
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoService
import it.finmatica.de4gsdzk.errors.ErroreModelloNonTrovatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.gestionetesti.GestioneTestiService
import org.springframework.stereotype.Service

@Slf4j
@Service
class GteGenerazioneCertificatoService implements IGenerazioneCertificatoService {
    private StatoCivileService statoCivileService
    private GestioneTestiService gestioneTestiService
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService

    GteGenerazioneCertificatoService(StatoCivileService statoCivileService,
                                     GestioneTestiService gestioneTestiService,
                                     GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService) {
        this.statoCivileService = statoCivileService
        this.gestioneTestiService = gestioneTestiService
        this.gestioneTestiModelloRelazioneService = gestioneTestiModelloRelazioneService
    }

    @Override
    void validateGenerazioneCertificato(CerCertificatoEmesso certificato) {
        GestioneTestiGsdModello g = gestioneTestiModelloRelazioneService.getByIdTipoCertificato(certificato.tipoCertificato.id)?.modello
        if (g == null) {
            throw new ErroreModelloNonTrovatoRuntimeException()
        }
    }

    @Override
    void generateCertificato(IGenerazioneCertificatoParams p) {
        try {
            Map<?, ?> parametriQuery = [:] // al momento vuoto, i parametri vengono caricati al volo

            // Controllo un po' inutile visto che viene fatto da validateGenerazioneCertificato
            GestioneTestiGsdModello g = gestioneTestiModelloRelazioneService.getByIdTipoCertificato(p.certificato.tipoCertificato.id)?.modello
            if (g == null) {
                throw new ErroreModelloNonTrovatoRuntimeException()
            }

            log.info("Avvio recupero xml data per certificato ${p.certificato.tipoCertificato.id}")
            String queryModello = statoCivileService.getDataSourceXmlCertificato(p.certificato)
            log.info("Recuperato xml data per per certificato ${p.certificato.tipoCertificato.id}")
            String formato = (g.formatoTesto?.name() ?: g.tipo).toLowerCase()
            ByteArrayInputStream bais = new ByteArrayInputStream(g.fileTemplate)
            InputStream out = gestioneTestiService.stampaUnione(bais, queryModello, parametriQuery, formato, true)
            byte[] bytes = out.bytes
            out.close()

            p.onSuccess.call(new CertificatoGenerato(ETipoGenerazioneCertificato.GTE, bytes, formato))
        } catch (Exception e) {
            p.onFailure.call(new GteGenerazioneCertificatoRuntimeException(e))
        }
    }
}
