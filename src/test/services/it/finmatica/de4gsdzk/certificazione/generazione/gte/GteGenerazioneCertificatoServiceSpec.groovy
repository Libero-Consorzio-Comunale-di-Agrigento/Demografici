package it.finmatica.de4gsdzk.certificazione.generazione.gte

import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiModelloRelazioneService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.errors.ErroreModelloNonTrovatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.GestioneTestiModelloRelazione
import it.finmatica.gestionetesti.GestioneTestiService
import spock.lang.Specification
import spock.lang.Subject

class GteGenerazioneCertificatoServiceSpec extends Specification {

    GsdService gsdService = Mock(GsdService)
    private GestioneTestiService gestioneTestiService = Mock(GestioneTestiService)
    private GestioneTestiModelloRelazioneService gestioneTestiModelloRelazioneService = Mock(GestioneTestiModelloRelazioneService)

    @Subject
    GteGenerazioneCertificatoService service = new GteGenerazioneCertificatoService(gsdService, gestioneTestiService, gestioneTestiModelloRelazioneService)

    def "Check su possibilità di generare il certificato quando modello non trovato"() {
        given: "Il certificato avente il tipo certificato con un modello non trovato"
        CerCertificatoEmesso certificato = new CerCertificatoEmesso(tipoCertificato: new CerTipoCertificato(id: "TIPO_CERTIFICATO_ID"))
        gestioneTestiModelloRelazioneService.getByIdTipoCertificato("TIPO_CERTIFICATO_ID") >> new GestioneTestiModelloRelazione(modello: null)

        when: "Eseguo validazione"
        service.validateGenerazioneCertificato(certificato)

        then: "Genera eccezione"
        thrown(ErroreModelloNonTrovatoRuntimeException)
    }

    def "Check su possibilità di generare il certificato quando modello valido"() {
        given: "Il certificato avente il tipo certificato con un modello trovato"
        CerCertificatoEmesso certificato = new CerCertificatoEmesso(tipoCertificato: new CerTipoCertificato(id: "TIPO_CERTIFICATO_ID"))
        gestioneTestiModelloRelazioneService.getByIdTipoCertificato("TIPO_CERTIFICATO_ID") >> new GestioneTestiModelloRelazione(modello: new GestioneTestiGsdModello())

        when: "Eseguo validazione"
        service.validateGenerazioneCertificato(certificato)

        then: "Non genera eccezione"
        noExceptionThrown()
    }
}
