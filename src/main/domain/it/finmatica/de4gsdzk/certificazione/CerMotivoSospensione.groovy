package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anpr.AnprCertificabilita
import it.finmatica.de4gsdzk.anpr.AnprTutela
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CERDMS")
class CerMotivoSospensione extends GsdBaseDomain {

    @Id
    @Column(name = "COD_MS")
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AVVISO", nullable = true)
    Boolean flagAvviso

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_ANPR", nullable = false)
    AnprCertificabilita certificabilita

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_ANPR_TUTELA", nullable = true)
    AnprTutela tutela

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Avviso"),
                                              Etichette.getEtichetta("Anpr_Certificabilita"), Etichette.getEtichetta("Anpr_Tutela")]
}
