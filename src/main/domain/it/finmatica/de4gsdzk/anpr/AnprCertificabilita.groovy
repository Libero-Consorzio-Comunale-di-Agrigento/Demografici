package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPT42")
class AnprCertificabilita extends GsdBaseDomain{

    @Id
    @Column(name = "CODICE")
    String id

    @Column(name = "DESCRIZIONE", nullable = true)
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione]
}
