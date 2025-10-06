package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso

interface IGenerazioneCertificatoService {
    void validateGenerazioneCertificato(CerCertificatoEmesso certificato)
    void generateCertificato(IGenerazioneCertificatoParams params)
}