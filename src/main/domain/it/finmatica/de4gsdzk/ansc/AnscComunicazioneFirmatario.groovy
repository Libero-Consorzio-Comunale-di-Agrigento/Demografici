package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IAnscComunicazione

import javax.persistence.*

@Entity
@Table(name = "ANSCIU_V_FIR")
class AnscComunicazioneFirmatario extends GsdBaseDomain implements IAnscComunicazione {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_OPERAZIONE", nullable = false)
    AnscComunicazione comunicazione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ULTIMA", nullable = true)
    Boolean flagUltima

    @Column(name = "ID_CIVFIR")
    Long idFirmatario

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []
}

