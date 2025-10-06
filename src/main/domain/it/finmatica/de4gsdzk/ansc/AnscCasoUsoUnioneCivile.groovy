package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.utils.ETipoDivorzioAltro

import javax.persistence.*

@Entity
@Table(name = "ANSCUU")
class AnscCasoUsoUnioneCivile extends AnscCasoUsoBaseDomain{

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CASA_COMUNALE", nullable = true)
    Boolean flagCasaComunale

    @Column(name = "TIPO_DICHIARANTE", nullable = true)
    String tipoDichiarante

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DIVORZIO_ALTRO", nullable = true)
    ETipoDivorzioAltro tipoDivorzioAltro

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_EX_ART19", nullable = true)
    Boolean flagExArt19

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
