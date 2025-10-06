package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.ENaturaAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVDCA", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "CODICE_CO"]))
class CivComunicazioneAtto extends CivComunicazioneRelazione2BaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA_ATTO")
    ENaturaAtto natura

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Tipo_Atto, Etichette.Natura_Atto]

}
