package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.DiscriminatorFormula

import javax.persistence.*

@Entity
@Table(name = "ANPT39")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorFormula("case when CODICE like 'S%' then 'ANSC' else 'ANPR' end")
abstract class CerMotivoEsenzioneBolloBaseDomain extends GsdBaseDomain {

    @Id
    @Column(name = "CODICE")
    String id

    @Column(name = "DESCRIZIONE", nullable = true)
    String descrizione

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ESENZIONE", nullable = true)
    Boolean flagEsenzione

    @Column(name = "NOTE", nullable = true)
    String note

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]
}
