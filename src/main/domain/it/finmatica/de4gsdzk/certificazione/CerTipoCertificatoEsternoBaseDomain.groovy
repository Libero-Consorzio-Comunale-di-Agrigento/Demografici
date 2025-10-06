package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.DiscriminatorFormula

import javax.persistence.*

@Entity
@Table(name = "ANPT13")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorFormula("case when FLAG_CIV = 'S' then 'ANSC' else 'ANPR' end")
abstract class CerTipoCertificatoEsternoBaseDomain extends GsdBaseDomain {

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
