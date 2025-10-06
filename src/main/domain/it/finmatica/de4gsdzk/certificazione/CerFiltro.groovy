package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine

import javax.persistence.*

@Entity
@Table(name = "CERDFC")
class CerFiltro extends GsdBaseDomain {

    @Id
    @Column(name = "COD_FC", nullable = false)
    private String id

    String getId() { id }

    void setId(String id) { this.id = id?.toUpperCase() }

    @Enumerated(EnumType.STRING)
    @Column(name = "COMPETENZA", nullable = false)
    ETipoCompetenzaCertificazioneOnLine tipoCompetenza

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

}
