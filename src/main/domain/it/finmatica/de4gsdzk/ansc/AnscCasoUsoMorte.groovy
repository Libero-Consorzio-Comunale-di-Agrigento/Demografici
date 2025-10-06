package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.utils.ETipoSiNo

import javax.persistence.*

@Entity
@Table(name = "ANSCU5")
class AnscCasoUsoMorte extends AnscCasoUsoBaseDomain{

    @Enumerated(EnumType.STRING)
    @Column(name = "ESTREMI_DECESSO_NOTI", nullable = true)
    ETipoSiNo estremiDecessoNoti

    @Enumerated(EnumType.STRING)
    @Column(name = "MORTE_VIOLENTA", nullable = true)
    ETipoSiNo morteViolenta

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
    @Column(name = "FLAG_EX_ART19", nullable = true)
    Boolean flagExArt19

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_IN_VIAGGIO", nullable = true)
    Boolean flagInViaggio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
