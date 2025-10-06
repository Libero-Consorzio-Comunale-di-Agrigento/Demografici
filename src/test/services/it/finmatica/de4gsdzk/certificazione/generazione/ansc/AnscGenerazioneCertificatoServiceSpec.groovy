package it.finmatica.de4gsdzk.certificazione.generazione.ansc

import it.finmatica.de4gsdzk.ansc.AnscAllegatoService
import it.finmatica.de4gsdzk.ansc.AnscComunicazioneService
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioService
import it.finmatica.de4gsdzk.ansc.AnscUtenteService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.statocivile.CivDatiProvenienzaAttoService
import spock.lang.Specification
import spock.lang.Subject

class AnscGenerazioneCertificatoServiceSpec extends Specification {

    AnscEndPointServizioService anscEndPointServizioService = Mock(AnscEndPointServizioService)
    AnscUtenteService anscUtenteService = Mock(AnscUtenteService)
    AnscAllegatoService anscAllegatoService = Mock(AnscAllegatoService)
    AnscComunicazioneService anscComunicazioneService = Mock(AnscComunicazioneService)
    CivDatiProvenienzaAttoService civDatiProvenienzaAttoService = Mock(CivDatiProvenienzaAttoService)

    @Subject
    AnscGenerazioneCertificatoService service = new AnscGenerazioneCertificatoService(
            anscEndPointServizioService,
            anscUtenteService,
            anscAllegatoService,
            anscComunicazioneService,
            civDatiProvenienzaAttoService
    )

    def "Check su possibilità di generare il certificato"() {
        given: "Parametri per la generazione del certificato"
        CerCertificatoEmesso certificato = new CerCertificatoEmesso()

        when: "Controllo la possibilità di salvare il certificato"
        service.validateGenerazioneCertificato(certificato)

        then: "La possibilità di generare il certificato non dovrebbe generare eccezione"
        noExceptionThrown()
    }
}
