package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.certificazione.generazione.anpr.AnprGenerazioneCertificatoService
import it.finmatica.de4gsdzk.certificazione.generazione.ansc.AnscGenerazioneCertificatoService
import it.finmatica.de4gsdzk.certificazione.generazione.gte.GteGenerazioneCertificatoService
import org.springframework.stereotype.Component

@Component
class GenerazioneCertificatoServiceFactory extends GenerazioneCertificatoFactory<IGenerazioneCertificatoService> {
    GenerazioneCertificatoServiceFactory(AnprGenerazioneCertificatoService anprGenerazioneCertificatoService,
                                         AnscGenerazioneCertificatoService anscGenerazioneCertificatoService,
                                         GteGenerazioneCertificatoService gteGenerazioneCertificatoService) {
        super(anprGenerazioneCertificatoService, anscGenerazioneCertificatoService, gteGenerazioneCertificatoService)
    }
}
