package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADSC_V")
class AnaStatoCivile {

    @Id
    @Column(name = "ID")
    String id

    // TODO: use EStatoCivile
    @Column(name = "COD_SC", nullable = false)
    String codice

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Column(name = "DESCRIZIONE")
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////


    static final List<Map<String, String>> etichetteDomain = [Etichette.Descrizione]

}
