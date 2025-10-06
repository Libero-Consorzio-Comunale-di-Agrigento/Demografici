package it.finmatica.de4gsdzk.certificazione

import javax.persistence.Column
import javax.persistence.Embeddable
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Embeddable
class CerFondoCassaTerminalistaCompositeId implements Serializable {

    @ManyToOne
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    CerTerminalista terminalista

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA", nullable = false)
    Date data

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        CerFondoCassaTerminalistaCompositeId entity = (CerFondoCassaTerminalistaCompositeId) obj
        return Objects.equals(this.terminalista, entity.terminalista) &&
                Objects.equals(this.data, entity.data)
    }

    @Override
    int hashCode() {
        return Objects.hash(terminalista, data)
    }

}