package it.finmatica.de4gsdzk.certificazione.generazione

abstract class GenerazioneCertificatoFactory<T> {
    private final T anprObject
    private final T anscObject
    private final T gteObject

    GenerazioneCertificatoFactory(T anprObject, T anscObject, T gteObject) {
        this.anprObject = Objects.requireNonNull(anprObject, "anprObject must not be null")
        this.anscObject = Objects.requireNonNull(anscObject, "anscObject must not be null")
        this.gteObject = Objects.requireNonNull(gteObject, "gteObject must not be null")
    }

    T getObject(ETipoGenerazioneCertificato tipoGenerazioneCertificato) {
        switch (tipoGenerazioneCertificato) {
            case ETipoGenerazioneCertificato.ANPR:
                return anprObject
            case ETipoGenerazioneCertificato.ANSC:
                return anscObject
            case ETipoGenerazioneCertificato.GTE:
                return gteObject
            default:
                throw new IllegalStateException("Unknown ETipoGenerazioneCertificato: ${tipoGenerazioneCertificato}")
        }
    }
}
