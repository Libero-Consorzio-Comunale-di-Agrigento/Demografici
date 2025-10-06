package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.utils.ETipoSiNo

import javax.persistence.*

@Entity
@Table(name = "ANSCU4")
class AnscCasoUsoMatrimonio extends AnscCasoUsoBaseDomain{

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
    @Column(name = "FLAG_RITO_CATTOLICO", nullable = true)
    Boolean flagRitoCattolico

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CASA_COMUNALE", nullable = true)
    Boolean flagCasaComunale

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_EX_ART19", nullable = true)
    Boolean flagExArt19

    @Enumerated(EnumType.STRING)
    @Column(name = "RICONOSCIMENTO_FIGLI", nullable = true)
    ETipoSiNo riconoscimentoFigli

    @Column(name = "TIPO_DIVORZIO", nullable = true)
    String tipoDivorzio

    @Column(name = "TIPO_DIVORZIO_ALTRO", nullable = true)
    String tipoDivorzioAltro

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_STRANIERI_NON_RESIDENTI", nullable = true)
    Boolean flagStranieriNonResidenti

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_IN_VIAGGIO", nullable = true)
    Boolean flagInViaggio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
