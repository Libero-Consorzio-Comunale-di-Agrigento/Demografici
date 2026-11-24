package it.finmatica.de4gsdzk.certificazione.generazione.anpr

import it.finmatica.de4gsdzk.certificazione.AnprRichiestaCertificatoResult
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.CertificatoGenerato
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.ETipoFile
import spock.lang.Specification
import spock.lang.Subject

class AnprGenerazioneCertificatoServiceSpec extends Specification {

    private static byte[] certificatoContent = "certificato-content".bytes
    private static String certificatoError = "certificato-error"

    GsdService gsdService = Mock()

    @Subject
    AnprGenerazioneCertificatoService service = new AnprGenerazioneCertificatoService(gsdService)

    def "Check su possibilità di generare il certificato"() {
        given: "Parametri per la generazione del certificato"
        CerCertificatoEmesso certificato = new CerCertificatoEmesso()

        when: "Controllo la possibilità di salvare il certificato"
        service.validateGenerazioneCertificato(certificato)

        then: "La possibilità di generare il certificato non dovrebbe generare eccezione"
        noExceptionThrown()
    }

    def "Generazione del certificato dovrebbe eseguire onSuccess quando ANPR ritorna il certificato"() {
        given: "Parametri per la generazione del certificato"
        AnprGenerazioneCertificatoParams anprParams = Mock(AnprGenerazioneCertificatoParams) {
            getCertificato() >> Mock(CerCertificatoEmesso)
            getOnSuccess() >> Mock(Closure)
        }

        when: "La chiamata ANPR ritorna il certificato"
        AnprRichiestaCertificatoResult anprResult = new AnprRichiestaCertificatoResult(certificatoContent, null)
        gsdService.anprRichiestaCertificato(_, _) >> anprResult

        and: "La generazione del certificato viene invocata"
        service.generateCertificato(anprParams)

        then: "La callback del metodo on success viene effettuata passandogli il certificato generato"
        1 * anprParams.onSuccess.call({ arg ->
            arg instanceof CertificatoGenerato &&
                    arg.tipoGenerazioneCertificato == ETipoGenerazioneCertificato.ANPR &&
                    arg.bytes == certificatoContent &&
                    arg.formato == ETipoFile.PDF.estensione
        })
    }

    def "Generazione del certificato dovrebbe eseguire onFailure quando ANPR ritorna un errore"() {
        given: "Parametri per la generazione del certificato"
        AnprGenerazioneCertificatoParams anprParams = Mock(AnprGenerazioneCertificatoParams) {
            getCertificato() >> Mock(CerCertificatoEmesso)
            getOnFailure() >> Mock(Closure)
        }

        when: "La chiamata ANPR ritorna un errore"
        AnprRichiestaCertificatoResult anprResult = new AnprRichiestaCertificatoResult(certificatoContent, certificatoError)
        gsdService.anprRichiestaCertificato(_, _) >> anprResult

        and: "La generazione del certificato viene invocata"
        service.generateCertificato(anprParams)

        then: "La callback del metodo on failure viene effettuata passandogli l'errore generato"
        1 * anprParams.onFailure.call({ arg ->
            arg instanceof AnprGenerazioneCertificatoRuntimeException &&
                    arg.generationError == certificatoError
        })
    }

    def "Generazione del certificato dovrebbe eseguire onFailure quando invocazione ANPR fallisce"() {
        given: "Parametri per la generazione del certificato"
        AnprGenerazioneCertificatoParams anprParams = Mock(AnprGenerazioneCertificatoParams) {
            getCertificato() >> Mock(CerCertificatoEmesso)
            getOnFailure() >> Mock(Closure)
        }

        when: "La chiamata ANPR ritorna un errore"
        gsdService.anprRichiestaCertificato(_, _) >> { throw new Exception("Invalid input") }

        and: "La generazione del certificato viene invocata"
        service.generateCertificato(anprParams)

        then: "La callback del metodo on failure viene effettuata passandogli l'errore generato"
        1 * anprParams.onFailure.call({ arg ->
            arg instanceof AnprGenerazioneCertificatoRuntimeException &&
                    arg.generationError == "Invalid input"
        })
    }
}
