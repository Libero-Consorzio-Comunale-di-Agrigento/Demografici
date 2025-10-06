package it.finmatica.de4gsdzk.ansc


import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "ANSCU1")
class AnscCasoUsoCittadinanza extends AnscCasoUsoBaseDomain{

    @Column(name="MOTIVO_CITTADINANZA", nullable = true)
    Long idMotivoCittadinanza

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = []

}
