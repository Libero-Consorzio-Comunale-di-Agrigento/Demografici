package it.finmatica.de4gsdzk.statocivile.embed

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Embeddable
import javax.persistence.Temporal
import javax.persistence.TemporalType

@Embeddable
class Protocollo {

    @Column(name = "ANNO")
    Integer anno

    @Column(name = "PROTOCOLLO")
    Integer numero

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO")
    Date data

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Protocollo"),
                                              Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Anno_Protocollo"),
                                              Etichette.getEtichetta("Data"), Etichette.getEtichetta("Data_Protocollo")]

}
