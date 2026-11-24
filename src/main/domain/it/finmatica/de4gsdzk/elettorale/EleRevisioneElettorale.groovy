package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ELEDSR_V")
class EleRevisioneElettorale extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="REVISIONE", nullable = true, updatable = false, insertable = false)
    EleTipoRevisione tipoRevisione

    @Column(name = "ANNO", nullable = true, updatable = false, insertable = false)
    Integer anno

    @Column(name = "PROGR_REVISIONE", nullable = true, updatable = false, insertable = false)
    Integer progressivo

    @Column(name = "VERBALE", nullable = true, updatable = false, insertable = false)
    String verbale

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_VERBALE", nullable = true)
    Date dataVerbale

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Revisione"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Verbale"), Etichette.getEtichetta("Data_Verbale")]
}
