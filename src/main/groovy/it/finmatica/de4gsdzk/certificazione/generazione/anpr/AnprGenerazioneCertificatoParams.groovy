package it.finmatica.de4gsdzk.certificazione.generazione.anpr

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams

class AnprGenerazioneCertificatoParams implements IGenerazioneCertificatoParams {
    CerCertificatoEmesso certificato
    Closure onSuccess
    Closure onFailure

    Boolean flagForzatura

    @Override
    ETipoGenerazioneCertificato getTipoGenerazioneCertificato() {
        return ETipoGenerazioneCertificato.ANPR
    }
}
