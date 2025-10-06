package it.finmatica.de4gsdzk.certificazione

class CerTipoCertificatoTariffaDirittoCompositeId implements Serializable {

    CerTipoCertificato tipoCertificato
    CerTariffaDiritto tariffaDiritto

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        CerTipoCertificatoTariffaDirittoCompositeId entity = (CerTipoCertificatoTariffaDirittoCompositeId) obj
        return Objects.equals(this.tipoCertificato, entity.tipoCertificato) &&
                Objects.equals(this.tariffaDiritto, entity.tariffaDiritto)
    }

    @Override
    int hashCode() {
        return Objects.hash(tipoCertificato, tariffaDiritto)
    }

}