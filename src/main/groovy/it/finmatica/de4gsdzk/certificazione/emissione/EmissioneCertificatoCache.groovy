package it.finmatica.de4gsdzk.certificazione.emissione

import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmesso

import java.util.concurrent.LinkedBlockingQueue

class EmissioneCertificatoCache {
    private static final int MAX_CAPACITY = 10
    private Queue<CerCertificatoEmesso> listaCertificatoEmessi

    EmissioneCertificatoCache() {
        listaCertificatoEmessi = new LinkedBlockingQueue<>(MAX_CAPACITY)
    }

    void store(CerCertificatoEmesso element) {
        if (!listaCertificatoEmessi.offer(element)) {
            listaCertificatoEmessi.poll()
            listaCertificatoEmessi.offer(element)
        }
    }

    Boolean shouldAlert(CerCertificatoEmesso daEmettere) {
        return listaCertificatoEmessi.any { EmissioneCertificatoService.shouldAlertEmissioneCertificato(it, daEmettere) }
    }
}
