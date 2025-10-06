package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADCI")
class AnaNazionalita extends GsdBaseDomain{

    public static final String ID_ITALIA = "I"

    @Id
    @Column(name = "COD_CI")
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Column(name = "DESCRIZIONE_M")
    String descrizioneMaschile

    @Column(name = "DESCRIZIONE_F")
    String descrizioneFemminile

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "CEE", nullable = true)
    Boolean paeseUE

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////


    static final List<Map> etichetteDomain = [Etichette.Codice, Etichette.Descrizione]

}
