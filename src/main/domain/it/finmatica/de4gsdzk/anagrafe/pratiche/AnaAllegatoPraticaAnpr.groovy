package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANPP02_ALLEGATI")
class AnaAllegatoPraticaAnpr extends GsdBaseDomain implements IAllegatoPratica {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "CONTENUTO_BLOB", nullable = false)
    @Lob
    byte[] blob

    @Column(name = "NOMEFILE")
    String nome

    @Column(name = "SEQUENZA")
    Integer sequenza

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICERICHIESTA", nullable = false)
    AnaPraticaAnpr praticaAnpr
}
