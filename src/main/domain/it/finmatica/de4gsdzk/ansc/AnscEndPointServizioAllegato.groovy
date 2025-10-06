package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo

import javax.persistence.*

@Entity
@Table(name = "ANSTWS_DDO")
class AnscEndPointServizioAllegato extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVDDO", nullable = false)
    CivTipoDocumentoFascicolo tipoDocumentoFascicolo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANSTWS", nullable = false)
    AnscEndPointServizio servizio

    @Column(name = "ID_ANST03")
    Long idCasoUso

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_OBBLIGATORIO", nullable = true)
    Boolean flagObbligatorio

    @Column(name = "SEQUENZA")
    Integer sequenza

    @Column(name = "TIPO_DOCUMENTO", nullable = true)
    String tipoDocumento

    @Version
    Long version

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
