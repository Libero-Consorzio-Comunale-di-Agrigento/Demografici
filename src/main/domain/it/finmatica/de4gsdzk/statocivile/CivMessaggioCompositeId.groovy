package it.finmatica.de4gsdzk.statocivile


import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.TipoAttoUtils

import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class CivMessaggioCompositeId implements Serializable {

    @Column(name = "TIPO_ATTO")
    Integer tipoAtto

    ETipoAtto getTipoAttoEnum() {
        return TipoAttoUtils.fromValoreDefault(this.tipoAtto.intValue())
    }

    @Column(name = "ID")
    Long id

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        CivMessaggioCompositeId entity = (CivMessaggioCompositeId) obj
        return Objects.equals(this.tipoAtto, entity.tipoAtto) &&
                Objects.equals(this.id, entity.id) &&
                Objects.equals(this.sequenza, entity.sequenza)
    }

    @Override
    int hashCode() {
        return Objects.hash(tipoAtto, id, sequenza)
    }

}