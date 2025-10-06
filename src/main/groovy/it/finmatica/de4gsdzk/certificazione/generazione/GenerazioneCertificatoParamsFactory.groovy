package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.certificazione.generazione.anpr.AnprGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.ansc.AnscGenerazioneCertificatoParams
import it.finmatica.de4gsdzk.certificazione.generazione.gte.GteGenerazioneCertificatoParams
import org.springframework.stereotype.Component

@Component
class GenerazioneCertificatoParamsFactory extends GenerazioneCertificatoFactory<IGenerazioneCertificatoParams> {
    GenerazioneCertificatoParamsFactory() {
        super(new AnprGenerazioneCertificatoParams(), new AnscGenerazioneCertificatoParams(), new GteGenerazioneCertificatoParams())
    }

}
