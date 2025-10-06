package it.finmatica.de4gsdzk.anagrafe


import javax.persistence.*

@Embeddable
class AnaMessaggioCompositeId implements Serializable {

    @Column(name = "SEQUENZA")
    Integer sequenza

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MATRICOLA", nullable = true)
    AnaAnagrafe anagrafe

    @Override
    boolean equals(Object obj) {
        if (this == obj) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaMessaggioCompositeId entity = (AnaMessaggioCompositeId) obj
        return Objects.equals(this.sequenza, entity.sequenza) &&
                Objects.equals(this.anagrafe, entity.anagrafe)
    }

    @Override
    int hashCode() {
        return Objects.hash(sequenza, anagrafe)
    }

}