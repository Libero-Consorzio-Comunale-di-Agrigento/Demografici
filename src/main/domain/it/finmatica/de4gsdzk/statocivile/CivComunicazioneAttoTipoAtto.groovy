package it.finmatica.de4gsdzk.statocivile

import javax.persistence.*

@Entity
@Table(name = "CIVDCT")
class CivComunicazioneAttoTipoAtto {

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDCA", nullable = false)
    CivComunicazioneAtto comunicazioneAtto

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVDTA")
    CivTipoAtto tipoAttoDomain

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
