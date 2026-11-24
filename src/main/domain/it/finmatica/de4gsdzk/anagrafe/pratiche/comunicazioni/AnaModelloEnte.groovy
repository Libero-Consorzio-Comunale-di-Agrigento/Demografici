package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoModello
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADDC_V")
class AnaModelloEnte extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "COD_MODELLO")
    String codModello

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_MODELLO")
    ETipoModello tipoModello

    @Column(name = "SEQUENZA")
    Integer sequenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_EN")
    AnaEnte ente

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANAMOD", updatable = false, insertable = false)
    AnaModello modello

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice"),
            Etichette.getEtichetta("Descrizione"),
            Etichette.getEtichetta("Modello"),
            Etichette.getEtichetta("Tipo_Modello"),
            Etichette.getEtichetta("Sequenza"),
            Etichette.getEtichetta("Ente"),
            Etichette.getEtichetta("Modello")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnaModelloEnte that = (AnaModelloEnte) obj
        return Objects.equals(id, that.id)
    }

    @Override
    int hashCode() {
        return Objects.hash(id)
    }

    @Override
    String toString() {
        return "AnaModelloEnte{id=${id}, codModello='${codModello}', tipoModello=${tipoModello}, sequenza=${sequenza}}"
    }
}