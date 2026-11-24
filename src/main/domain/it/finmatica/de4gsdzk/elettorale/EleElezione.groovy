package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ELEDCE_V")
class EleElezione extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    String getIdentificativo() {
        return id.toString()
    }

    @Column(name = "ANNO_ELEZIONI", nullable = true, updatable = false, insertable = false)
    Integer anno

    @Column(name = "PROGR_ELEZIONI", nullable = true, updatable = false, insertable = false)
    Integer progressivo

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_ELEZIONI", nullable = true)
    Date data

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Data")]
}
