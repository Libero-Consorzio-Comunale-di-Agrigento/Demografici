package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVDDC")
class CivComunicazioneEnte extends CivComunicazioneRelazioneBaseDomain {

    @Id @Column
    Long id

    @Column(nullable = false)
    Integer tipoAtto

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_EN", nullable = false)
    CivEnte ente

    @Column(nullable = false)
    Integer sequenza

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ente,
                                              Etichette.Sequenza,
                                              Etichette.Comunicazione,
                                              Etichette.Codice,
                                              Etichette.Descrizione,
                                              Etichette.Tipo_Atto]

}
