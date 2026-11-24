package it.finmatica.de4gsdzk.certificazione.generazione

import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.FileUtils

class CertificatoGenerato {
    private String formato
    private byte[] bytes
    private ETipoGenerazioneCertificato tipoGenerazioneCertificato

    CertificatoGenerato(ETipoGenerazioneCertificato tipoGenerazioneCertificato, byte[] bytes, String formato) {
        this.tipoGenerazioneCertificato = tipoGenerazioneCertificato
        this.bytes = bytes
        this.formato = formato
    }

    String getFormato() {
        return formato
    }

    byte[] getBytes() {
        return bytes
    }

    ETipoGenerazioneCertificato getTipoGenerazioneCertificato() {
        return tipoGenerazioneCertificato
    }

    String generateNomeFile(String identificativoCertificato) {
        String tipoGenerazione
        switch (tipoGenerazioneCertificato) {
            case ETipoGenerazioneCertificato.GTE:
                tipoGenerazione = null
                break
            case ETipoGenerazioneCertificato.ANSC:
                tipoGenerazione = Etichette.getEtichetta("ANSC").defaultValue
                break
            case ETipoGenerazioneCertificato.ANPR:
                tipoGenerazione = Etichette.getEtichetta("ANPR").defaultValue
                break
            default:
                throw new RuntimeException("Tipo generazione certificato non previsto: ${tipoGenerazioneCertificato}")
        }
        String nome = "Certificato_${identificativoCertificato}${tipoGenerazione ? '_' + tipoGenerazione : ''}"
        nome = FileUtils.sanitizeFilename(nome)
        return nome + (formato ? "." + formato : "")
    }
}
