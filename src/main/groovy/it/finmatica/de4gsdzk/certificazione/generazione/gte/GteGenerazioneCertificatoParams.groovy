package it.finmatica.de4gsdzk.certificazione.generazione.gte

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
import it.finmatica.de4gsdzk.certificazione.generazione.IGenerazioneCertificatoParams

class GteGenerazioneCertificatoParams implements IGenerazioneCertificatoParams {
    CerCertificatoEmesso certificato
    Closure onSuccess
    Closure onFailure

    @Override
    ETipoGenerazioneCertificato getTipoGenerazioneCertificato() {
        return ETipoGenerazioneCertificato.GTE
    }
}
