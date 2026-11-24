package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Embeddable
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Temporal
import javax.persistence.TemporalType
import javax.persistence.Transient

@Embeddable
class ModelloAireCancellazione {

    @Column(name = "ANNO_PROTOCOLLO_AIRE")
    Integer annoProtocolloAire

    @Column(name = "PROTOCOLLO_AIRE")
    Integer protocolloAire

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PRATICA")
    Date dataProtocolloAire

    @Column(name = "ANNO_PRATICA")
    Integer annoPratica

    @Column(name = "PRATICA")
    Integer pratica

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DECORRENZA")
    Date dataDecorrenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DEFINIZIONE")
    Date dataDefinizione

    @Transient
    AnaDizionarioPratiche motivoCancellazione

    @Column(name = "MOTIVO")
    String codiceMotivo


    @Column(name = "COD_FAM")
    Long numeroFoglio

    static final List<Map> etichetteDomain = [
            Etichette.getEtichetta("Anno_Protocollo_Aire"),
            Etichette.getEtichetta("Protocollo_Aire"),
            Etichette.getEtichetta("Data_Protocollo_Aire"),
            Etichette.getEtichetta("Anno_Pratica"),
            Etichette.getEtichetta("Pratica"),
            Etichette.getEtichetta("Data_Decorrenza"),
            Etichette.getEtichetta("Data_Definizione"),
            Etichette.getEtichetta("Motivo_Cancellazione"),
            Etichette.getEtichetta("Numero_Foglio")
    ]

}
