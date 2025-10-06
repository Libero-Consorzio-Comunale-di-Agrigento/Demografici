package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ETipoRichiesta

class CivCategoriaTipoRichiestaCompositeId implements Serializable {

    Integer tipoAtto

    String siglaCategoria

    ETipoRichiesta tipoRichiesta

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        CivCategoriaTipoRichiestaCompositeId that = (CivCategoriaTipoRichiestaCompositeId) obj;
        return Objects.equals(tipoAtto, that.tipoAtto) &&
                Objects.equals(siglaCategoria, that.siglaCategoria) &&
                Objects.equals(tipoRichiesta, that.tipoRichiesta)
    }

    @Override
    int hashCode() {
        return Objects.hash(tipoAtto, siglaCategoria, tipoRichiesta);
    }
}