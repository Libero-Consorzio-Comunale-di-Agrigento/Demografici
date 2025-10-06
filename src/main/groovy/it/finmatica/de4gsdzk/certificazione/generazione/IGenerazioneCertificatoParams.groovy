package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso

interface IGenerazioneCertificatoParams {
    ETipoGenerazioneCertificato getTipoGenerazioneCertificato()

    CerCertificatoEmesso getCertificato()

    void setCertificato(CerCertificatoEmesso certificato)

    Closure getOnSuccess()

    void setOnSuccess(Closure onSuccess)

    Closure getOnFailure()

    void setOnFailure(Closure onFailure)
}